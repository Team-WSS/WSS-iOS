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
    private var avatarId = 0
    private var userNickName = ""
    private var representativeAvatarId = 0
    private var representativeAvatar = false
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
        
        register()
        bindUserData()
        
        bindColletionView()
        pushViewController()
        //        removeDimmedView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarController = self.tabBarController as? WSSTabBarController {
            tabBarController.tabBar.isHidden = false
            tabBarController.shadowView.isHidden = false
        }
        
        bindDataAgain()
    }
    
    //MARK: - Custom Method
    
    private func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.title = "마이페이지"
        
        if let navigationBar = self.navigationController?.navigationBar {
            let titleTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.Title2
            ]
            navigationBar.titleTextAttributes = titleTextAttributes
        }
    }
    
    private func register() {
        rootView.myPageInventoryView.myPageAvaterCollectionView.register(MyPageInventoryCollectionViewCell.self, forCellWithReuseIdentifier: "MyPageInventoryCollectionViewCell")
        
        rootView.myPageSettingView.myPageSettingCollectionView.register(MyPageSettingCollectionViewCell.self, forCellWithReuseIdentifier: "MyPageSettingCollectionViewCell")
    }
    
    private func bindColletionView() {
        avaterListRelay.bind(to: rootView.myPageInventoryView.myPageAvaterCollectionView.rx.items(
            cellIdentifier: "MyPageInventoryCollectionViewCell",
            cellType: MyPageInventoryCollectionViewCell.self)) { [weak self] (row, element, cell) in
                guard let self = self else { return }
                
                self.representativeAvatarId == element.avatarId ? representativeAvatar : !representativeAvatar
                cell.bindData(element, representativeId: representativeAvatarId)
                cell.myPageAvaterButton.rx.tap
                    .bind(with: self, onNext: { owner, _ in 
                        owner.avatarId = element.avatarId
                        owner.hasAvatar = element.hasAvatar
                        owner.tapAvatarButton()
                    })
            }
            .disposed(by: disposeBag)
        
        settingData.bind(to: rootView.myPageSettingView.myPageSettingCollectionView.rx.items(
            cellIdentifier: "MyPageSettingCollectionViewCell",
            cellType: MyPageSettingCollectionViewCell.self)) { (row, element, cell) in
                cell.myPageSettingCellLabel.text = element
            }
            .disposed(by: disposeBag)
    }
    
    private func bindUserData() {
        userRepository.getUserData()
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in 
                owner.rootView.dataBind(data)
                owner.representativeAvatarId = data.representativeAvatarId
                owner.userNickName = data.userNickName
            })
            .disposed(by: disposeBag)
    }
    
    private func bindDataAgain() {
        getDataFromAPI(disposeBag: disposeBag) { data, list in 
            self.updateUI(userData: data, avatarList: list)
        }
    }
    
    private func getDataFromAPI(disposeBag: DisposeBag, completion: @escaping (UserResult, [UserAvatar]) -> Void) {
        self.userRepository.getUserData()
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, userData in
                completion(userData, userData.userAvatars)
            }, onError: { error, _ in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateUI(userData: UserResult, avatarList: [UserAvatar]) {
        self.userNickName = userData.userNickName
        self.rootView.dataBind(userData)
        self.avaterListRelay.accept(avatarList)
    }
    
    private func pushViewController() {
        rootView.myPageTallyView.myPageUserNameButton.rx.tap
            .bind(with: self, onNext: { owner, _ in 
                if let tabBarController = owner.tabBarController as? WSSTabBarController {
                    tabBarController.tabBar.isHidden = true
                    tabBarController.shadowView.isHidden = true
                }
                
                let changeNicknameViewController = MyPageChangeNicknameViewController(userRepository: DefaultUserRepository(
                    userService: DefaultUserService()))
                changeNicknameViewController.bindData(self.userNickName)
                owner.navigationController?.pushViewController(changeNicknameViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension MyPageViewController {
    @objc func tapAvatarButton() {
        let modalVC = MyPageCustomModalViewController(
            avatarRepository:DefaultAvatarRepository(
                avatarService: DefaultAvatarService()),
            avatarId: avatarId,
            representativeAvatar: representativeAvatar,
            modalHasAvatar: hasAvatar
        )
        
        //        addDimmedView()
        modalVC.modalPresentationStyle = .overFullScreen
        present(modalVC, animated: true)
    }
    
    //    private func addDimmedView() {
    //        view.addSubview(dimmedView)
    //        dimmedView.do {
    //            $0.backgroundColor = .Black
    //            $0.alpha = 0.6
    //            $0.addGestureRecognizer(tapGesture)
    //        }
    //        dimmedView.snp.makeConstraints() {
    //            $0.edges.equalToSuperview()
    //        }
    //    }
}
