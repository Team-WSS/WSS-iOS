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
    private var userRepository: DefaultUserRepository
    private var settingData = MyPageViewModel.setting
    private var userNickName = ""
    private var representativeAvatarId = 0
    private var hasAvatar = false
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository as! DefaultUserRepository
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
        pushChangeNickNameViewController()
        addNotificationCenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reSetNavigationBar()
        bindDataAgain()
    }
    
    //MARK: - set NavigationBar
    
    private func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = StringLiterals.Navigation.Title.myPage
        
        if let navigationBar = self.navigationController?.navigationBar {
            let titleTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.Title2
            ]
            navigationBar.titleTextAttributes = titleTextAttributes
        }
    }
    
    private func reSetNavigationBar() {
        showTabBar()
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
                owner.rootView.dataBind(data)
                owner.representativeAvatarId = data.representativeAvatarId
                owner.userNickName = data.userNickName
                owner.avaterListRelay = BehaviorRelay(value: data.userAvatars)
                owner.bindColletionView()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindColletionView() {
        avaterListRelay.bind(to: rootView.myPageInventoryView.myPageAvaterCollectionView.rx.items(
            cellIdentifier: "MyPageInventoryCollectionViewCell",
            cellType: MyPageInventoryCollectionViewCell.self)) { [weak self] (row, element, cell) in
                guard let self = self else { return }
                cell.bindData(element, representativeId: self.representativeAvatarId)
                cell.myPageAvaterButton.rx.tap
                    .bind(with: self, onNext: { owner, _ in 
                        owner.hasAvatar = element.hasAvatar
                        print("🐱", element.avatarId)
                        owner.pushModalViewController(avatarId: element.avatarId)
                    })
            }
            .disposed(by: disposeBag)
        
        settingData.bind(to: rootView.myPageSettingView.myPageSettingCollectionView.rx.items(
            cellIdentifier: "MyPageSettingCollectionViewCell",
            cellType: MyPageSettingCollectionViewCell.self)) {[weak self] (row, element, cell) in
                guard let self = self else { return }
                cell.myPageSettingCellButton.setTitle(element, for: .normal)
                cell.myPageSettingCellButton.rx.tap
                    .bind(with: self, onNext: { owner, _ in 
                        switch row {
                        case 0:
                            let infoViewController = MyPageInfoViewController()
                            infoViewController.rootView.bindData(self.userNickName)
                            owner.navigationController?.pushViewController(infoViewController, animated: true)
                            
                        default:
                            break
                        }
                    })
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - reDataBind
    
    private func bindDataAgain() {
        getDataFromAPI(disposeBag: disposeBag) { data, list in 
            self.updateUI(userData: data, avatarList: list)
        }
    }
    
    private func getDataFromAPI(disposeBag: DisposeBag, completion: @escaping (UserResult, [UserAvatar]) -> Void) {
        self.userRepository.getUserData()
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, userData in
                owner.representativeAvatarId = userData.representativeAvatarId
                owner.userNickName = userData.userNickName
                completion(userData, userData.userAvatars)
            }, onError: { error, _ in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateUI(userData: UserResult, avatarList: [UserAvatar]) {
        self.rootView.dataBind(userData)
        self.representativeAvatarId = userData.representativeAvatarId
        self.avaterListRelay.accept(avatarList)
    }
}

extension MyPageViewController {
    
    //MARK: - push To ViewController
    
    @objc func pushModalViewController(avatarId: Int) {
        let modalVC = MyPageCustomModalViewController(
            avatarRepository:DefaultAvatarRepository(
                avatarService: DefaultAvatarService()),
            avatarId: avatarId,
            modalHasAvatar: hasAvatar
        )
        print("💖", avatarId)
        modalVC.modalPresentationStyle = .overFullScreen
        present(modalVC, animated: true)
    }
    
    private func pushChangeNickNameViewController() {
        rootView.myPageTallyView.myPageUserNameButton.rx.tap
            .bind(with: self, onNext: { owner, _ in 
                self.hideTabBar()
                let changeNicknameViewController = MyPageChangeNicknameViewController(userRepository: DefaultUserRepository(
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
