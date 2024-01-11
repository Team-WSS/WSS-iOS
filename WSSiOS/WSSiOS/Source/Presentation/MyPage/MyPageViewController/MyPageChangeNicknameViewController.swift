//
//  MyPageChangeNicknameViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/12/24.
//

import UIKit

import RxSwift
import RxCocoa

class MyPageChangeNicknameViewController: UIViewController {
    
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
            .subscribe(onNext: { _ in
                self.rootView.textFieldUnderBarView.backgroundColor = .Primary100
            })
            .disposed(by: disposeBag)
        
        rootView.changeNicknameTextField.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(onNext: { _ in
                self.rootView.textFieldUnderBarView.backgroundColor = .Gray200
            })
            .disposed(by: disposeBag)
        
        rootView.changeNicknameTextField.rx.text
            .subscribe(onNext: { text in
                if let countText = text?.count {
                    self.rootView.countNicknameLabel.text = "\(countText)/10"
                }
            })
            .disposed(by: disposeBag)
        
        rootView.changeNicknameTextField.rx.text.orEmpty
            .subscribe(onNext: { text in 
                self.limitNum(text)
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
