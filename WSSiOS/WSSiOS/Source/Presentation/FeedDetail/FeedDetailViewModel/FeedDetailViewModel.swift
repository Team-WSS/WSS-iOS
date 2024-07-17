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
    
    private let feedProfileData = BehaviorRelay<Feed?>(value: nil)
    private let feedDetailData =  BehaviorRelay<Feed?>(value: nil)
    private let commentCountLabel = BehaviorRelay<Int>(value: 0)
    private let commentsData = BehaviorRelay<[Comment]>(value: [])
    private let replyCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    
    //MARK: - Life Cycle
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
    
    struct Input {
        let replyCollectionViewContentSize: Observable<CGSize?>
    }
    
    struct Output {
        let feedProfileData: Driver<Feed?>
        let feedDetailData : Driver<Feed?>
        let commentCountLabel: Driver<Int>
        let commentsData: Driver<[Comment]>
        let replyCollectionViewHeight: Driver<CGFloat>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        feedRepository.getSingleFeedData()
            .subscribe(with: self, onNext: { owner, data in
                owner.feedProfileData.accept(data)
                owner.feedDetailData.accept(data)
                owner.commentCountLabel.accept(data.commentCount)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        feedRepository.getSingleFeedComments()
            .subscribe(with: self, onNext: { owner, data in
                owner.commentsData.accept(data)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        let replyCollectionViewContentSize = input.replyCollectionViewContentSize
            .map { $0?.height ?? 0 }.asDriver(onErrorJustReturn: 0)
        
        return Output(feedProfileData: feedProfileData.asDriver(),
                      feedDetailData: feedDetailData.asDriver(),
                      commentCountLabel: commentCountLabel.asDriver(),
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
