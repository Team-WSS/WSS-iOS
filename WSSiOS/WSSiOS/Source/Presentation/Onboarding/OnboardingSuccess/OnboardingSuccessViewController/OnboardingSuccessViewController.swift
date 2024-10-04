//
//  OnboardingSuccessViewController.swift
//  WSSiOS
//
//  Created by YunhakLee on 10/4/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then
 
final class OnboardingSuccessViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = OnboardingSuccessView()
    private let disposeBag = DisposeBag()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindAction()
    }
    
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - Bind
    
    func bindAction() {
        rootView.completeButton.button.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.onboardingCompleted()
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Custom Method
    
    private func onboardingCompleted() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        sceneDelegate.setRootToWSSTabBarController()
    }
}
