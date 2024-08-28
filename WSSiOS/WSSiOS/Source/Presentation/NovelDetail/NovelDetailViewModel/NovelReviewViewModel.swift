//
//  NovelReviewViewModel.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 8/28/24.
//

import UIKit

import RxSwift
import RxCocoa

final class NovelReviewViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let userNovelRepository: UserNovelRepository
    
    //MARK: - Life Cycle
    
    init(userNovelRepository: UserNovelRepository) {
        self.userNovelRepository = userNovelRepository
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
