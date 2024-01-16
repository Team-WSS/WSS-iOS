//
//  MemoCreateViewController.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/13/24.
//

import UIKit

import RxCocoa
import RxKeyboard
import RxSwift

final class MemoCreateViewController: UIViewController {
    
    //MARK: - set Properties
    
    private let disposeBag = DisposeBag()
    
    private var memoContent = ""

    // MARK: - UI Components

     private let rootView = MemoCreateView()

     // MARK: - Life Cycle

     override func loadView() {
         self.view = rootView
     }

     override func viewDidLoad() {
         super.viewDidLoad()
         
         setTapGesture()
         setBinding()
     }
    
    // MARK: - set tap gesture
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        view.addGestureRecognizer(tapGesture)
    }

    // MARK: - set Binding
    
    private func setBinding() {
        rootView.memoCreateContentView.memoTextView.rx.text.orEmpty
            .subscribe(onNext: { text in
                self.memoContent = text
                if text.count > 2000 {
                    self.rootView.memoCreateContentView.memoTextView.text = String(text.prefix(2000))
                }
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { keyboardHeight in
                self.rootView.memoCreateContentView.updateTextViewConstraint(keyboardHeight: keyboardHeight)
            })
            .disposed(by: disposeBag)
    }
    
    @objc func viewDidTap() {
        view.endEditing(true)
    }
}
