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
    
    private let reasonCellTitle = BehaviorRelay<[String]>(value: StringLiterals.MyPage.DeleteIDReason.allCases.map { $0.rawValue })
    private let checkCellTitle = BehaviorRelay<[(String, String)]>(value: zip(StringLiterals.MyPage.DeleteIDCheckTitle.allCases, StringLiterals.MyPage.DeleteIDCheckContent.allCases).map { ($0.rawValue, $1.rawValue) })
    
    //MARK: - Life Cycle
    
    struct Input {
        let backButtonDidTap: ControlEvent<Void>
        let reasonCellTap: ControlEvent<IndexPath>
        let completeButtonDidTap: ControlEvent<Void>
        let viewDidTap: ControlEvent<UITapGestureRecognizer>
        let textUpdated: Observable<String>
        let didBeginEditing: ControlEvent<Void>
        let didEndEditing: ControlEvent<Void>
    }
    
    struct Output {
        let bindReasonCell: Observable<[String]>
        let bindCheckCell: Observable<[(String, String)]>
        let tapReasonCell = PublishRelay<IndexPath>()
        let popViewController = PublishRelay<Bool>() 
        let textCountLimit = PublishRelay<Int>()
        let beginEditing = PublishRelay<Bool>()
        let endEditing = PublishRelay<Bool>()
        let containText = BehaviorRelay<String>(value: "")
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output(bindReasonCell: reasonCellTitle.asObservable(),
                            bindCheckCell: checkCellTitle.asObservable())
        
        input.backButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                output.popViewController.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.reasonCellTap
            .subscribe(with: self, onNext: { owner, indexPath in
                print(indexPath)
                output.tapReasonCell.accept(indexPath)
            })
            .disposed(by: disposeBag)
        
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
                output.beginEditing.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.didEndEditing
            .subscribe(onNext: { _ in
                output.endEditing.accept(true) 
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    //MARK: - Custom Method
    
    
    //MARK: - API
    
}
