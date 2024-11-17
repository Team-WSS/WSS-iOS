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
    
    private let disposeBag = DisposeBag()
    let nickname: String
    
    //MARK: - Components
    
    private let rootView = OnboardingSuccessView()
    
    //MARK: - Life Cycle
    
    init(nickname: String) {
        self.nickname = nickname
        
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
        
        setUI()
        bindAction()
    }
    
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - UI
    
    private func setUI() {
        rootView.updateNickname(nickname)
    }
    
    //MARK: - Bind
    
    private func bindAction() {
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
        UserDefaults.standard.set(true, forKey: StringLiterals.UserDefault.showReviewFirstDescription)
    }
}
