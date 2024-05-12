//
//  HomeNoticeViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/12/24.
//

import UIKit

import RxSwift
import RxCocoa

final class HomeNoticeViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let recommendRepository: DefaultRecommendRepository
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    struct Input {
        
    }
    
    // MARK: - Outputs
    
    struct Output {
        
    }
    
    //MARK: - init
    
    init(recommendRepository: DefaultRecommendRepository) {
        self.recommendRepository = recommendRepository
    }
}

extension HomeNoticeViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        return output
    }
}
