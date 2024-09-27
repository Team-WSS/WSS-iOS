//
//  FeedGenreViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 9/28/24.
//

import Foundation

import RxSwift
import RxCocoa

final class FeedGenreViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let feedRepository: FeedRepository
    private let category: String
    private var lastFeedId: Int = 0
    private var isLoading = false
    
    //MARK: - Life Cycle
    
    init(feedRepository: FeedRepository, category: String) {
        self.feedRepository = feedRepository
        self.category = category
    }
    
    struct Input {
        let loadMoreTrigger: Observable<Void>
    }
    
    struct Output {
        let feedList = BehaviorRelay<[TotalFeeds]>(value: [])
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        getFeedData(category: category, lastFeedId: lastFeedId)
            .subscribe(with: self, onNext: { owner, data in
                owner.lastFeedId = data.feeds.last?.feedId ?? owner.lastFeedId
                output.feedList.accept(data.feeds)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    //MARK: - API
    
    private func getFeedData(category: String, lastFeedId: Int) -> Observable<TotalFeed> {
        return self.feedRepository.getFeedData(category: category, lastFeedId: lastFeedId)
    }
}

