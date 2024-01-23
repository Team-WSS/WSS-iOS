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
    
    //MARK: - Set Properties
    
    private var avaterListRelay = BehaviorRelay<[UserAvatar]>(value: [])
    private let disposeBag = DisposeBag()
    private let userRepository: UserRepository
    private let settingData = MyPageViewModel.setting
    private lazy var userNickName = ""
    private lazy var representativeAvatarId = 0
    private var currentPresentativeAvatar = false
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository 
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Components
    
    private var rootView = MyPageView()
    //    private let dimmedView = UIView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        register()
        
        bindUserData()
        bindAction()
        addNotificationCenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setTabBar()
        bindDataAgain()
    }
    
    //MARK: - set NavigationBar
    
    private func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        //self.navigationController?.navigationBar.backgroundColor = .White
        self.navigationItem.title = StringLiterals.Navigation.Title.myPage
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .White
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        if let navigationBar = self.navigationController?.navigationBar {
            let titleTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.Title2
            ]
            navigationBar.titleTextAttributes = titleTextAttributes
        }
    }
    
    private func setTabBar() {
        if let tabBarController = self.tabBarController as? WSSTabBarController {
            tabBarController.shadowView.isHidden = false
            tabBarController.tabBar.isHidden = false
        }
    }
    
    //MARK: - init DataBind
    
    private func register() {
        rootView.myPageInventoryView.myPageAvaterCollectionView.register(MyPageInventoryCollectionViewCell.self, forCellWithReuseIdentifier: "MyPageInventoryCollectionViewCell")
        
        rootView.myPageSettingView.myPageSettingCollectionView.register(MyPageSettingCollectionViewCell.self, forCellWithReuseIdentifier: "MyPageSettingCollectionViewCell")
    }
    
    private func bindUserData() {
        userRepository.getUserData()
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in 
                owner.rootView.bindData(data)
                owner.representativeAvatarId = data.representativeAvatarId
                owner.userNickName = data.userNickname
                owner.avaterListRelay = BehaviorRelay(value: data.userAvatars)
                owner.bindColletionView()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindColletionView() {
        avaterListRelay.bind(to: rootView.myPageInventoryView.myPageAvaterCollectionView.rx.items(
            cellIdentifier: "MyPageInventoryCollectionViewCell",
            cellType: MyPageInventoryCollectionViewCell.self)) { [weak self] (row, element, cell) in
                cell.bindData(data: element, representativeId: self?.representativeAvatarId ?? 0)
            }
            .disposed(by: disposeBag)
        
        settingData.bind(to: rootView.myPageSettingView.myPageSettingCollectionView.rx.items(
            cellIdentifier: "MyPageSettingCollectionViewCell",
            cellType: MyPageSettingCollectionViewCell.self)) { (row, element, cell) in
                cell.myPageSettingCellLabel.text = element
            }
            .disposed(by: disposeBag)
    }
    
    private func bindAction() {
        rootView.myPageSettingView.myPageSettingCollectionView.rx.itemSelected
            .subscribe(with: self, onNext: { owner, indexpath in
                switch indexpath.row {
                case 0:
                    let infoViewController = MyPageInfoViewController()
                    infoViewController.rootView.bindData(self.userNickName)
                    self.hideTabBar()
                    self.navigationController?.pushViewController(infoViewController, animated: true)
                    
                case 1:
                    if let openApp = URL(string: StringLiterals.MyPage.Setting.instaURL), UIApplication.shared.canOpenURL(openApp) {
                        UIApplication.shared.open(openApp, options: [:], completionHandler: nil)
                    } else {
                        if let url = URL(string: StringLiterals.MyPage.Setting.instaURL) {
                            UIApplication.shared.open(url, options: [:])
                        }
                    }
                    
                case 2:
                    if let url = URL(string: StringLiterals.MyPage.Setting.termsURL) {
                        UIApplication.shared.open(url, options: [:])
                    }
                    
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        
        rootView.myPageInventoryView.myPageAvaterCollectionView.rx.itemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                let avatars = self.avaterListRelay.value
                let selectedAvatarId = avatars[indexPath.row].avatarId
                let selectedAvatarHas = avatars[indexPath.row].hasAvatar
                
                if owner.representativeAvatarId == selectedAvatarId {
                    owner.currentPresentativeAvatar = true
                }
                else {
                    owner.currentPresentativeAvatar = false
                }
                
                owner.pushModalViewController(avatarId: selectedAvatarId,
                                              hasAvatar: selectedAvatarHas,
                                              currentRepresentativeAvatar: owner.currentPresentativeAvatar)
            })
            .disposed(by: disposeBag)
        
        rootView.myPageTallyView.myPageUserNameButton.rx.tap
            .bind(with: self, onNext: { owner, _ in 
                if let tabBarController = self.tabBarController as? WSSTabBarController {
                    tabBarController.shadowView.isHidden = true
                    tabBarController.tabBar.isHidden = true
                }
                
                let changeNicknameViewController = MyPageChangeNicknameViewController(userNickName: owner.userNickName,
                                                                                      userRepository: DefaultUserRepository(
                                                                                        userService: DefaultUserService()))
                changeNicknameViewController.bindData(self.userNickName)
                owner.navigationController?.pushViewController(changeNicknameViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        let tapGestureForRegister = UITapGestureRecognizer(target: self, action: #selector(pushToRegister))
        let tapGestureForRecord = UITapGestureRecognizer(target: self, action: #selector(pushToRecord))
        
        rootView.myPageTallyView.myPageRegisterView.addGestureRecognizer(tapGestureForRegister)
        rootView.myPageTallyView.myPageRecordView.addGestureRecognizer(tapGestureForRecord)
    }
    
    @objc
    func pushToRegister() {
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
    func pushToRecord() {
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
    
    //MARK: - reBindData
    
    private func bindDataAgain() {
        getDataFromAPI(disposeBag: disposeBag) { data, list in 
            self.updateUI(userData: data, avatarList: list)
        }
    }
    
    private func getDataFromAPI(disposeBag: DisposeBag,
                                completion: @escaping (UserResult, [UserAvatar]) -> Void) {
        self.userRepository.getUserData()
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, userData in
                owner.representativeAvatarId = userData.representativeAvatarId
                owner.userNickName = userData.userNickname
                completion(userData, userData.userAvatars)
            }, onError: { error, _ in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateUI(userData: UserResult, avatarList: [UserAvatar]) {
        self.rootView.bindData(userData)
        self.representativeAvatarId = userData.representativeAvatarId
        self.avaterListRelay.accept(avatarList)
    }
}

extension MyPageViewController {
    
    //MARK: - push To ViewController
    
    @objc
    func pushModalViewController(avatarId: Int,
                                 hasAvatar: Bool,
                                 currentRepresentativeAvatar: Bool) {
        let modalVC = MyPageCustomModalViewController(
            avatarRepository: DefaultAvatarRepository(
                avatarService: DefaultAvatarService()),
            avatarId: avatarId,
            modalHasAvatar: hasAvatar,
            currentRepresentativeAvatar: currentRepresentativeAvatar)
        
        modalVC.modalPresentationStyle = .overFullScreen
        present(modalVC, animated: true)
    }
    
    private func pushChangeNickNameViewController() {
        rootView.myPageTallyView.myPageUserNameButton.rx.tap
            .bind(with: self, onNext: { owner, _ in 
                self.hideTabBar()
                let changeNicknameViewController = MyPageChangeNicknameViewController(userNickName: owner.userNickName, userRepository: DefaultUserRepository(
                    userService: DefaultUserService()))
                changeNicknameViewController.bindData(self.userNickName)
                owner.navigationController?.pushViewController(changeNicknameViewController, animated: true)
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
