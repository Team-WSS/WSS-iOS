//
//  MyPageViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/8/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class MyPageViewController: UIViewController {
    
    //MARK: - Properties
    
    private var avaterListRelay = BehaviorRelay<[UserAvatar]>(value: [])
    private let disposeBag = DisposeBag()
    private let userRepository: UserRepository
    private let avatarRepository: AvatarRepository
    private let settingData = StringLiterals.MyPage.Setting.allCases.map { $0.rawValue }
    private lazy var userNickname = ""
    private lazy var representativeAvatarId = 0
    private var currentPresentativeAvatar = false
    
    //MARK: - UI Components
    
    private var rootView = MyPageView()
    
    // MARK: - Life Cycle
    
    init(userRepository: UserRepository, avatarRepository: AvatarRepository) {
        self.userRepository = userRepository 
        self.avatarRepository = avatarRepository
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.myPage,
                                    left: nil,
                                    right: nil)
        setAppearance()
        register()
        bindUserData()
        bindAction()
        addNotificationCenter()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showTabBar()
    }
    
    //MARK: - NavigationBar
    
    private func setAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .wssWhite
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    //MARK: - Bind
    
    private func register() {
        rootView.myPageInventoryView.myPageAvaterCollectionView.register(MyPageInventoryCollectionViewCell.self, forCellWithReuseIdentifier: MyPageInventoryCollectionViewCell.cellIdentifier)
        
        rootView.myPageSettingView.myPageSettingCollectionView.register(MyPageSettingCollectionViewCell.self, forCellWithReuseIdentifier: MyPageSettingCollectionViewCell.cellIdentifier)
    }
    
    private func bindUserData() {
        userRepository.getUserData()
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in 
                owner.rootView.bindData(data)
                owner.representativeAvatarId = data.representativeAvatarId
                owner.userNickname = data.userNickname
                owner.avaterListRelay.accept(data.userAvatars)
                owner.bindColletionView()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindColletionView() {
        avaterListRelay
            .bind(to: rootView.myPageInventoryView.myPageAvaterCollectionView.rx.items(
                cellIdentifier: "MyPageInventoryCollectionViewCell",
                cellType: MyPageInventoryCollectionViewCell.self)) { [weak self] (row, element, cell) in
                    cell.bindData(data: element, representativeId: self?.representativeAvatarId ?? 0)
                }
                .disposed(by: disposeBag)
        
        Observable.just(settingData)
            .bind(to: rootView.myPageSettingView.myPageSettingCollectionView.rx.items(
                cellIdentifier: "MyPageSettingCollectionViewCell",
                cellType: MyPageSettingCollectionViewCell.self)) { (row, element, cell) in
                    cell.myPageSettingCellLabel.text = element
                }
                .disposed(by: disposeBag)
        
        //초기값 100으로 설정, 아무 의미 없음, 초기값 설정마저 안하고 싶은데 방법을 모르겠음
        let collectionViewHeightConstraint = rootView.myPageSettingView.myPageSettingCollectionView.heightAnchor.constraint(equalToConstant: 100)
        collectionViewHeightConstraint.isActive = true
        let settingDataCount = CGFloat(settingData.count)
        let calculatedHeight = settingDataCount * 64.0 + (settingDataCount - 1) * 1.0 + 24.0
        collectionViewHeightConstraint.constant = calculatedHeight
        view.layoutIfNeeded()
    }
    
    private func bindDataAgain() {
        getDataFromAPI(disposeBag: disposeBag) { data, list in 
            self.updateUI(userData: data, avatarList: list)
        }
    }
    
    private func updateUI(userData: UserResult, avatarList: [UserAvatar]) {
        self.rootView.bindData(userData)
        self.representativeAvatarId = userData.representativeAvatarId
        self.avaterListRelay.accept(avatarList)
    }
    
    //MARK: - Actions
    
    private func bindAction() {
        rootView.myPageSettingView.myPageSettingCollectionView.rx.itemSelected
            .compactMap { StringLiterals.MyPage.Setting(rawValue: self.settingData[$0.row]) }
            .subscribe(with: self, onNext: { owner, option in
                switch option {
                case .accountInfo:
                    let infoViewController = MyPageInfoViewController()
                    infoViewController.rootView.bindData(self.userNickname)
                    self.hideTabBar()
                    self.navigationController?.pushViewController(infoViewController, animated: true)
                    
                case .webSoso:
                    if let openApp = URL(string: StringLiterals.MyPage.SettingURL.instaURL), UIApplication.shared.canOpenURL(openApp) {
                        UIApplication.shared.open(openApp, options: [:], completionHandler: nil)
                    } else {
                        if let url = URL(string: StringLiterals.MyPage.SettingURL.instaURL) {
                            UIApplication.shared.open(url, options: [:])
                        }
                    }
                    
                case .termsOfService:
                    if let url = URL(string: StringLiterals.MyPage.SettingURL.termsURL) {
                        UIApplication.shared.open(url, options: [:])
                    }
                }
            })
            .disposed(by: disposeBag)
        
        rootView.myPageInventoryView.myPageAvaterCollectionView.rx.itemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                let avatars = self.avaterListRelay.value
                
                if owner.representativeAvatarId == avatars[indexPath.row].avatarId {
                    owner.currentPresentativeAvatar = true
                }
                else {
                    owner.currentPresentativeAvatar = false
                }
                
                owner.pushModalViewController(avatarId: avatars[indexPath.row].avatarId,
                                              hasAvatar: avatars[indexPath.row].hasAvatar,
                                              currentRepresentativeAvatar: owner.currentPresentativeAvatar)
            })
            .disposed(by: disposeBag)
        
        rootView.myPageTallyView.myPageUserNameButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in 
                self.pushToChangeNicknameViewController(userNickname: owner.userNickname)
            })
            .disposed(by: disposeBag)
        
        let tapGestureForRegister = UITapGestureRecognizer(target: self, action: #selector(pushToRegisterTabBar))
        let tapGestureForRecord = UITapGestureRecognizer(target: self, action: #selector(pushToRecordTabBar))
        
        rootView.myPageTallyView.myPageRegisterView.addGestureRecognizer(tapGestureForRegister)
        rootView.myPageTallyView.myPageRecordView.addGestureRecognizer(tapGestureForRecord)
    }
    
    @objc
    func pushToRegisterTabBar() {
        if self.navigationController?.tabBarController?.selectedIndex == 3 {
            UIView.performWithoutAnimation {
                let tabBar = WSSTabBarController()
                tabBar.selectedIndex = 1
                let navigationController = UINavigationController(rootViewController: tabBar)
                navigationController.isNavigationBarHidden = true
                self.view.window?.rootViewController = navigationController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    @objc
    func pushToRecordTabBar() {
        if self.navigationController?.tabBarController?.selectedIndex == 3 {
            UIView.performWithoutAnimation {
                let tabBar = WSSTabBarController()
                tabBar.selectedIndex = 2
                let navigationController = UINavigationController(rootViewController: tabBar)
                navigationController.isNavigationBarHidden = true
                self.view.window?.rootViewController = navigationController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    //MARK: - API
    
    private func getDataFromAPI(disposeBag: DisposeBag,
                                completion: @escaping (UserResult, [UserAvatar]) -> Void) {
        self.userRepository.getUserData()
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, userData in
                owner.representativeAvatarId = userData.representativeAvatarId
                owner.userNickname = userData.userNickname
                completion(userData, userData.userAvatars)
            }, onError: { error, _ in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}

extension MyPageViewController {
    
    //MARK: - push To ViewController
    
    @objc
    func pushModalViewController(avatarId: Int,
                                 hasAvatar: Bool,
                                 currentRepresentativeAvatar: Bool) {
        let modalVC = MyPageCustomModalViewController(
            avatarRepository: self.avatarRepository,
            avatarId: avatarId,
            modalHasAvatar: hasAvatar,
            currentRepresentativeAvatar: currentRepresentativeAvatar,
            viewModel: MyPageCustomModalViewModel(
                avatarRepository: self.avatarRepository))
        
        modalVC.modalPresentationStyle = .overFullScreen
        present(modalVC, animated: true)
    }
    
    private func pushChangeNickNameViewController() {
        rootView.myPageTallyView.myPageUserNameButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in 
                self.hideTabBar()
                self.pushToChangeNicknameViewController(userNickname: owner.userNickname)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - notification
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.checkNotification(notification:)),
            name: NSNotification.Name("AvatarChanged"),
            object: nil
        )
    }
    
    @objc 
    func checkNotification(notification: Notification) {
        bindDataAgain()
    }
}
