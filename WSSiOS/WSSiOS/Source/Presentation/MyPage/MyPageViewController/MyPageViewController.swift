//
//  MyPageViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/8/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class MyPageViewController: UIViewController {
    
    //MARK: - Set Properties
    
    //DummyData
    private let items = Observable.just([UIImage(named: "exampleAvater"),
                                         UIImage(named: "exampleAvater"),
                                         UIImage(named: "exampleAvater"),
                                         UIImage(named: "exampleAvater")])
    private let items2 = Observable.just(["계정정보 확인",
                                          "로그아웃",
                                          "웹소소 인스타 보러가기",
                                          "서비스 이용약관"])
    private let viewModel: MyPageViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
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
        bindDataToMyPageCollectionView()
        pushChangeNicknameViewController()
        //        removeDimmedView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let input = MyPageViewModel.Input(viewWillAppearEvent: Observable.just(()))
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.profileData.subscribe(onNext: { [weak self] userDTO in
            self?.updateProfileView(with: userDTO)
        }).disposed(by: disposeBag)
    }
    
    private func updateProfileView(with userDTO: UserDTO) {
        print(userDTO.memoCount)
        print(userDTO.userNickName)
        rootView.myPageTallyView.myPageUserNameButton.setTitle("\(userDTO.userNickName)님", for: .normal)
        rootView.myPageTallyView.myPageRegisterView.tallyLabel.text = String(userDTO.userNovelCount)
        rootView.myPageTallyView.myPageRecordView.tallyLabel.text = String(userDTO.memoCount)
    }
                
    //MARK: - UI Components
    
    private func register() {
        rootView.myPageInventoryView.myPageAvaterCollectionView.register(MyPageInventoryCollectionViewCell.self, forCellWithReuseIdentifier: "MyPageInventoryCollectionViewCell")
        
        rootView.myPageSettingView.myPageSettingCollectionView.register(MyPageSettingCollectionViewCell.self, forCellWithReuseIdentifier: "MyPageSettingCollectionViewCell")
    }
    
    //MARK: - Custom Method
    
    private func bindDataToMyPageCollectionView() {
        items.bind(to: rootView.myPageInventoryView.myPageAvaterCollectionView.rx.items(
            cellIdentifier: "MyPageInventoryCollectionViewCell",
            cellType: MyPageInventoryCollectionViewCell.self)) { (row, element, cell) in
                cell.myPageAvaterButton.setImage(element, for: .normal)
                cell.myPageAvaterButton.rx.tap
                    .bind(with: self, onNext: { owner, _ in 
                        owner.tapAvatarButton()
                    })
            }
            .disposed(by: disposeBag)
        
        items2.bind(to: rootView.myPageSettingView.myPageSettingCollectionView.rx.items(
            cellIdentifier: "MyPageSettingCollectionViewCell",
            cellType: MyPageSettingCollectionViewCell.self)) { (row, element, cell) in
                cell.myPageSettingCellLabel.text = element
            }
            .disposed(by: disposeBag)
    }
    
    private func pushChangeNicknameViewController() {
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
    
//    private func bindViewModel() {
//        let input = MyPageViewModel.Input(
//            viewWillAppearEvent: self.rx.viewWillAppear.asObservable(),
//        )
//    }
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
