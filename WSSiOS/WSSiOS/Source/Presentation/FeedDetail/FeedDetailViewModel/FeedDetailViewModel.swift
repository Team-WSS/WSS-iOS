//
//  FeedDetailViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 6/23/24.
//

import UIKit

import RxSwift
import RxCocoa

final class FeedDetailViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let feedRepository: FeedRepository
    private let disposeBag = DisposeBag()
    
    private let feedDetailData = PublishRelay<Feed>()
    private let commentsDataList = PublishRelay<[Comment]>()
    
    //MARK: - Life Cycle
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
    
    struct Input {
        
    }
    
    struct Output {
        let feedProfileData = PublishRelay<Feed>()
        let feedDetailData = PublishRelay<Feed>()
        let commentCountLabel = BehaviorRelay<Int>(value: 0)
        let commentsDataList = PublishRelay<[Comment]>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        feedRepository.getSingleFeedData()
            .subscribe(with: self, onNext: { owner, data in
                output.feedProfileData.accept(data)
                output.feedDetailData.accept(data)
                output.commentCountLabel.accept(data.commentCount)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        feedRepository.getSingleFeedComments()
            .subscribe(with: self, onNext: { owner, data in
                output.commentsDataList.accept(data)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)

        return output
    }
}
