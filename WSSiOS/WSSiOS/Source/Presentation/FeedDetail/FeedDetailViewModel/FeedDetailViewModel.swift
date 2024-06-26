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
    
    private let feedDetailData = PublishSubject<Feed>()
    private let commentsDataList = PublishSubject<[Comment]>()
    
    //MARK: - Life Cycle
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
    
    struct Input {
        
    }
    
    struct Output {
        let feedDetailData: Observable<Feed>
        let commentDataList: Observable<[Comment]>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        feedRepository.getSingleFeedData()
            .subscribe(with: self, onNext: { owner, data in
                owner.feedDetailData.onNext(data)
            })
            .disposed(by: disposeBag)
        
        feedRepository.getSingleFeedComments()
            .subscribe(with: self, onNext: { owner, data in
                owner.commentsDataList.onNext(data)
            })
            .disposed(by: disposeBag)

        return Output(feedDetailData: feedDetailData.asObservable(),
                      commentDataList: commentsDataList.asObservable())
    }
}
