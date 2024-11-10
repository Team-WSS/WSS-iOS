//
//  InduceLoginViewController.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 11/10/24.
//

import UIKit

import RxSwift
import RxCocoa

final class InduceLoginViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private let rootView = InduceLoginView()
    
    //MARK: - Life Cycle
    
    init() {
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
        
        setAction()
        
    }
    
    private func setUI() {
        
    }
    
    private func setAction() {
        rootView.loginButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                    return
                }
                sceneDelegate.setRootToLoginViewController()
            })
            .disposed(by: disposeBag)
        
        rootView.cancelButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.dismissViewController()
            })
            .disposed(by: disposeBag)
    }
}
