//
//  MyPageDeleteIDViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 7/24/24.
//

import UIKit

import RxSwift
import RxCocoa

final class MyPageDeleteIDViewModel: ViewModelType {
    
    //MARK: - Properties
    
    static let textViewMaxLimit = 80
    
    //MARK: - Life Cycle
    
    struct Input {
        let completeButtonDidTap: ControlEvent<Void>
        let viewDidTap: ControlEvent<UITapGestureRecognizer>
        let textUpdated: Observable<String>
        let didBeginEditing: ControlEvent<Void>
        let didEndEditing: ControlEvent<Void>
    }
    
    struct Output {
        let textCountLimit = PublishRelay<Int>()
        let endEditing = PublishRelay<Bool>()
        let containText = BehaviorRelay<String>(value: "")
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidTap
            .subscribe(onNext: { _ in
                output.endEditing.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.textUpdated
            .subscribe(with: self, onNext: { owner, text in
                output.containText.accept(String(text.prefix(MyPageDeleteIDViewModel.textViewMaxLimit)))
                output.textCountLimit.accept(output.containText.value.count)
            })
            .disposed(by: disposeBag)
        
        input.didBeginEditing
            .subscribe(onNext: { _ in
               // 
            })
            .disposed(by: disposeBag)
        
        input.didEndEditing
            .subscribe(onNext: { _ in
               // 
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    //MARK: - Custom Method
    
    
    //MARK: - API
    
}
