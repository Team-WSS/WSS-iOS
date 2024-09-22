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
    
    private let feedDetailRepository: FeedDetailRepository
    private let disposeBag = DisposeBag()
    private let feedId: Int
    
    private let feedData = PublishSubject<Feed>()
    private let commentsData = BehaviorRelay<[FeedComment]>(value: [])
    private let replyCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    
    //MARK: - Life Cycle
    
    init(feedDetailRepository: FeedDetailRepository, feedId: Int) {
        self.feedDetailRepository = feedDetailRepository
        self.feedId = feedId
    }
    
    struct Input {
        let replyCollectionViewContentSize: Observable<CGSize?>
    }
    
    struct Output {
        let feedData: Observable<Feed>
        let commentsData: Driver<[FeedComment]>
        let replyCollectionViewHeight: Driver<CGFloat>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        feedDetailRepository.getSingleFeedData(feedId: feedId)
            .subscribe(with: self, onNext: { owner, data in
                owner.feedData.onNext(data)
            }, onError: { owner, error in
                owner.feedData.onError(error)
            })
            .disposed(by: disposeBag)
        
        feedDetailRepository.getSingleFeedComments(feedId: feedId)
            .subscribe(with: self, onNext: { owner, data in
                owner.commentsData.accept(data.comments)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        let replyCollectionViewContentSize = input.replyCollectionViewContentSize
            .map { $0?.height ?? 0 }.asDriver(onErrorJustReturn: 0)
        
        return Output(feedData: feedData.asObservable(),
                      commentsData: commentsData.asDriver(),
                      replyCollectionViewHeight: replyCollectionViewContentSize)
    }
    
    //MARK: - Custom Method
    
    func replyContentForItemAt(indexPath: IndexPath) -> String? {
        guard indexPath.item < commentsData.value.count else {
            return nil
        }
        
        return commentsData.value[indexPath.item].commentContent
    }
    
    func replyContentNumberOfLines(indexPath: IndexPath) -> Int? {
        guard indexPath.item < commentsData.value.count else {
            return nil
        }
        
        let commentContent = commentsData.value[indexPath.item].commentContent
        
        let label = UILabel()
        label.applyWSSFont(.body2, with: commentContent)
        label.numberOfLines = 0
        
        let maxSize = CGSize(width: UIScreen.main.bounds.width - 128,
                             height: CGFloat.greatestFiniteMagnitude)
        let requiredSize = label.sizeThatFits(maxSize)
        
        let lineHeight = UIFont.Body2.lineHeight
        let numberOfLines = Int(round(requiredSize.height / lineHeight))
        
        return numberOfLines
    }
}
