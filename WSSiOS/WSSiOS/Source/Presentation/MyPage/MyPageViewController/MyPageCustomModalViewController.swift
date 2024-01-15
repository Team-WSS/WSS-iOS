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
    
    //MARK: - UI Components
    
    private var rootView = MyPageCustomModalView()
    private let myPageViewController = MyPageViewController(
        viewModel: MyPageViewModel(
            myUseCase: DefaultMyUseCase(
                userRepository: DefaultUserRepository.shared
            )
        )
    )
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierachy()
        setLayout()
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
}
