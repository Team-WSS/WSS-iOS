//
//  MemoEditViewModel.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 2/24/24.
//

import UIKit

import RxSwift
import RxCocoa

final class MemoEditViewModel: ViewModelType {
    
    //MARK: - Properties
        
    private let memoRepository: MemoRepository
       
    //MARK: - Life Cycle
    
    init(memoRepository: MemoRepository) {
        self.memoRepository = memoRepository
    }
    
    struct Input {
    }
    
    struct Output {
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        return output
    }
}
