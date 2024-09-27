//
//  FeedViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 5/14/24.
//

import Foundation

import RxSwift
import RxRelay

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
        var feedList = PublishRelay<[TotalFeeds]>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        feedRepository.getFeedData(category: "romance",
                                   lastFeedId: 1)
        .subscribe(with: self, onNext: { owner, data in
            output.feedList.accept(data.feeds)
        }, onError: { owner, error in
            print(error)
        })
        .disposed(by: disposeBag)
        
        return output
    }
    
    //MARK: - Custom Method
    
    
    //MARK: - API
    
    private func getFeedData(category: String, lastFeedId: Int) -> Observable<TotalFeed> {
        return self.feedRepository.getFeedData(category: category, lastFeedId: lastFeedId)
    }
}
