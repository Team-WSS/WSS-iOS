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
    
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private var rootView = MyPageChangeNicknameView()
    
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
            })
            .disposed(by: disposeBag)
        
        rootView.changeNicknameTextField.rx.text
            .subscribe(with: self, onNext: { owner, text in
                if let countText = text?.count {
                    owner.rootView.countNicknameLabel.text = "\(countText)/10"
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
}
