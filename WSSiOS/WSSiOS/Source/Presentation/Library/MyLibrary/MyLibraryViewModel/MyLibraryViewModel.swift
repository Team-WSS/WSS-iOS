//
//  MyLibraryViewModel.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/25/24.
//

import UIKit

import RxSwift
import RxCocoa
import Then

final class MyLibraryViewModel: ViewModelType {
    
    //MARK: - Properties
    
    let filterOption = BehaviorRelay<LibraryFilterOption>(value: LibraryFilterOption())
    
    //MARK: - Life Cycle
    
    
    //MARK: - Transform
    
    struct Input {
        let interestFilterButtonDidTap: ControlEvent<Void>
        let sortButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let selectedFilterOption: Driver<LibraryFilterOption>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
       
        input.interestFilterButtonDidTap
            .withLatestFrom(filterOption)
            .map { option in
                var updated = option
                updated.interestedOption.toggle()
                return updated
            }
            .bind(to: filterOption)
            .disposed(by: disposeBag)
        
        return Output(
            selectedFilterOption: filterOption.asDriver()
        )
    }
    
    //MARK: - API
    
    
    //MARK: - Custom Method
    
    
}
