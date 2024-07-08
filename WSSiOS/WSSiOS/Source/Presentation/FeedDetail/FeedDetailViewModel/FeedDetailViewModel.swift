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
     
    //MARK: - Life Cycle
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
    
    struct Input {
        
    }
    
    struct Output {
        let feedProfileData = BehaviorRelay<Feed>(value: Feed(userProfileImage: "", userNickName: "", createdDate: "", content: "", novelTitle: "", novelRating: 0, novelRatingCount: 0, genres: [.all], likeCount: 0, commentCount: 0, isLiked: false))
        let feedDetailData =  BehaviorRelay<Feed>(value: Feed(userProfileImage: "", userNickName: "", createdDate: "", content: "", novelTitle: "", novelRating: 0, novelRatingCount: 0, genres: [.all], likeCount: 0, commentCount: 0, isLiked: false))
        let commentCountLabel = BehaviorRelay<Int>(value: 0)
        let commentsData = BehaviorRelay<[Comment]>(value: [Comment(userId: 0, userNickname: "", userProfileImage: "", commentId: 0, createdDate: "", commentContent: "", isModified: false, isMyComment: false)])
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
                output.commentsData.accept(data)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
