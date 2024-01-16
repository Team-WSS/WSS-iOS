//
//  MyPageCustomModalViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/13/24.
//

import UIKit

import RxCocoa
import RxSwift

class MyPageCustomModalViewController: UIViewController {
    
    //MARK: - Set Properties
    
    private let disposeBag = DisposeBag()
    private var avatarRepository: DefaultAvatarRepository
    private let avatarId: Int
    
    init(avatarRepository: DefaultAvatarRepository, avatarId: Int) {
        self.avatarRepository = avatarRepository
        self.avatarId = avatarId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Components
    
    private var rootView = MyPageCustomModalView()
//    private let myPageViewController = MyPageViewController(
//        userRepository: DefaultUserRepository(
//            userService: DefaultUserService())
//    )
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierachy()
        setLayout()
        bindAvatarData()
        tapContinueButton()
    }
    
    //MARK: - Custom Method
    
    private func setHierachy() {
        self.view.addSubview(rootView)
    }
    
    private func setLayout() {
        rootView.snp.makeConstraints() {
            $0.bottom.width.equalToSuperview()
            $0.height.equalTo(572)
        }
    }
    
    private func tapContinueButton() {
        rootView.modalContinueButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                //                owner.myPageViewController.myPageViewModel.removeDimmedView.onNext(())
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAvatarData() {
        avatarRepository.getAvatarData(avatarId: avatarId)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in 
                print(data)
                owner.rootView.bindData(data)
            })
            .disposed(by: disposeBag)
    }
}
