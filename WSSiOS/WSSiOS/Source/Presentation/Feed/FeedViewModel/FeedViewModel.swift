//
//  FeedViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 5/14/24.
//

import Foundation

final class FeedViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let feedRepository: FeedRepository
    
    //MARK: - Life Cycle
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
    
    struct Input {
       
    }
    
    struct Output {
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
      
        return output
    }
    
    //MARK: - Custom Method
    
    
    //MARK: - API
    
}
