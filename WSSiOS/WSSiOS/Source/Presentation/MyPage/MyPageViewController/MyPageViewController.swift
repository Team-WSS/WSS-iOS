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
        
        bindDataAgain()
    }
    
    //MARK: - Custom Method
    
    private func register() {
        rootView.myPageInventoryView.myPageAvaterCollectionView.register(MyPageInventoryCollectionViewCell.self, forCellWithReuseIdentifier: "MyPageInventoryCollectionViewCell")
        
        rootView.myPageSettingView.myPageSettingCollectionView.register(MyPageSettingCollectionViewCell.self, forCellWithReuseIdentifier: "MyPageSettingCollectionViewCell")
    }
    
    private func bindColletionView() {
        avaterListRelay.bind(to: rootView.myPageInventoryView.myPageAvaterCollectionView.rx.items(
            cellIdentifier: "MyPageInventoryCollectionViewCell",
            cellType: MyPageInventoryCollectionViewCell.self)) { (row, element, cell) in
                cell.bindData(element)
                cell.myPageAvaterButton.rx.tap
                    .bind(with: self, onNext: { owner, _ in 
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
                print(data)
                owner.rootView.dataBind(data)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindDataAgain() {
        getDataFromAPI(disposeBag: disposeBag) { avatarCount, avatarList in 
            self.updateUI(avatarList: avatarList)
        }
    }
    
    private func getDataFromAPI(disposeBag: DisposeBag, completion: @escaping (Int, [UserAvatar]) -> Void) {
        self.userRepository.getUserData()
            .subscribe(with: self, onNext: { owner, data in
                let avatarCount = data.userAvatars.count
                let avatarList = data.userAvatars
                
                completion(avatarCount, avatarList)
            }, onError: { error, _ in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateUI(avatarList: [UserAvatar]) {
        Observable.just(avatarList)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, list in 
                owner.avaterListRelay.accept(list)
            })
    }
    
    private func pushViewController() {
        rootView.myPageTallyView.myPageUserNameButton.rx.tap
            .bind(with: self, onNext: { owner, _ in 
                if let tabBarController = owner.tabBarController as? WSSTabBarController {
                    tabBarController.tabBar.isHidden = true
                    tabBarController.shadowView.isHidden = true
                }
                
                let changeNicknameViewController = MyPageChangeNicknameViewController()
                owner.navigationController?.pushViewController(changeNicknameViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension MyPageViewController {
    @objc func tapAvatarButton() {
        let modalVC = MyPageCustomModalViewController()
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
