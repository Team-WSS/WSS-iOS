//
//  MyPageChangeNicknameViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/12/24.
//

import UIKit

import RxSwift
import RxCocoa

final class MyPageChangeNicknameViewController: UIViewController {
    
    //MARK: - Set Properties
    
    private var userNickName = ""
    private let disposeBag = DisposeBag()
    private let userRepository : UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Components
    
    var rootView = MyPageChangeNicknameView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldEvent()
    }
    
    //MARK: - Custom Method
    
    private func textFieldEvent() {
        rootView.changeNicknameTextField.rx.controlEvent([.editingDidBegin, .editingChanged])
            .asObservable()
            .subscribe(with: self, onNext: { owner, _ in
                owner.rootView.textFieldUnderBarView.backgroundColor = .Primary100
            })
            .disposed(by: disposeBag)
        
        rootView.changeNicknameTextField.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(with: self, onNext: { owner, _ in
                owner.rootView.textFieldUnderBarView.backgroundColor = .Gray200
                owner.patchUserNickName()
            })
            .disposed(by: disposeBag)
        
        rootView.changeNicknameTextField.rx.text
            .subscribe(with: self, onNext: { owner, text in
                if let text = text {
                    owner.rootView.countNicknameLabel.text = "\(text.count)/10"
                    owner.userNickName = text
                }
            })
            .disposed(by: disposeBag)
        
        rootView.changeNicknameTextField.rx.text.orEmpty
            .subscribe(with: self, onNext: { owner, text in
                self.limitNum(text)
            })
            .disposed(by: disposeBag)
        
        rootView.setClearButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.rootView.changeNicknameTextField.text = ""
                owner.rootView.countNicknameLabel.text = "0/10"
            })
            .disposed(by: disposeBag)
    }
    
    private func limitNum(_ text: String) {
        if text.count > 9 {
            let index = text.index(text.startIndex, offsetBy: 9)
            self.rootView.changeNicknameTextField.text = String(text[..<index])
        }
    }
    
    private func patchUserNickName() {
        userRepository.patchUserName(userNickName: userNickName)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in 
            },onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    func bindData(_ data: String) {
        rootView.changeNicknameTextField.text = data
    }
}
