//
//  MyPageFeedViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 1/22/25.
//

import Foundation

import RxSwift
import RxCocoa

final class MyPageFeedViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()
    
    /// 초기값은 내 프로필로 설정
    private let isMyPage = BehaviorRelay<Bool>(value: true)
    private var profileId: Int
    
    private let bindFeedDataRelay = BehaviorRelay<[FeedCellData]>(value: [])
    private let isEmptyFeedRelay = PublishRelay<Bool>()
    private let showFeedDetailButtonRelay = BehaviorSubject<Bool>(value: false)
    
    private let pushToMyPageFeedDetailViewControllerRelay = PublishRelay<(Int, MyProfileResult)>()
    private let pushToFeedDetailViewController = PublishRelay<Int>()
    private let pushToNovelDetailViewController = PublishRelay<Int>()
    
    private let updateFeedTableViewHeightRelay = PublishRelay<CGFloat>()
    
    // MARK: - Life Cycle
    
    init(userRepository: UserRepository, isMyPage: Bool = true, profileId: Int = 0) {
        self.userRepository = userRepository
        if isMyPage {
            let userId = UserDefaults.standard.integer(forKey: StringLiterals.UserDefault.userId)
            self.profileId = userId
        } else {
            self.profileId = profileId
        }
        self.isMyPage.accept(isMyPage)
    }
    
    struct Input {
        let viewWillAppearEvent: PublishSubject<Void>
        
        let feedDetailButtonDidTap: ControlEvent<Void>
        let feedTableViewItemSelected: Observable<IndexPath>
        let feedConnectedNovelViewDidTap: Observable<Int>
        
        let resizefeedTableViewHeight: Observable<CGSize?>
    }
    
    struct Output {
        let bindFeedData: BehaviorRelay<[FeedCellData]>
        let isEmptyFeed: PublishRelay<Bool>
        let showFeedDetailButton: BehaviorSubject<Bool>
        
        let pushToMyPageFeedDetailViewController: PublishRelay<(Int, MyProfileResult)>
        let pushToFeedDetailViewController: Observable<Int>
        let pushToNovelDetailViewController: Observable<Int>
        
        let updateFeedTableViewHeight: PublishRelay<CGFloat>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewWillAppearEvent
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self = self else { return .empty() }
                
                return self.updateMyPageFeedData()
                
                .flatMap { _ -> Observable<Void> in
                    self.handleFeedTableViewHeight(resizeFeedTableViewHeight: input.resizefeedTableViewHeight)
                        .map { _ in () }
                }
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        input.feedDetailButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                self.pushToMyPageFeedDetailViewControllerRelay.accept((owner.profileId, owner.profileDataRelay.value))
            })
            .disposed(by: disposeBag)
        
        input.feedTableViewItemSelected
            .bind(with: self, onNext: { owner, indexPath in
                let feedId = self.bindFeedDataRelay.value[indexPath.row].feed.feedId
                self.pushToFeedDetailViewController.accept(feedId)
            })
            .disposed(by: disposeBag)
        
        input.feedConnectedNovelViewDidTap
            .bind(with: self, onNext: { owner, novelId in
                self.pushToNovelDetailViewController.accept(novelId)
            })
            .disposed(by: disposeBag)
        
        return Output(bindFeedData: bindFeedDataRelay,
                      isEmptyFeed: isEmptyFeedRelay,
                      showFeedDetailButton: showFeedDetailButtonRelay,
                      pushToMyPageFeedDetailViewController: pushToMyPageFeedDetailViewControllerRelay,
                      pushToFeedDetailViewController: pushToFeedDetailViewController,
                      pushToNovelDetailViewController: pushToNovelDetailViewController,
                      updateFeedTableViewHeight: updateFeedTableViewHeightRelay
        )
    }
    
    // MARK: - Custom Method

    private func updateMyPageFeedData() -> Observable<Void> {
        return getUserFeed(userId: self.profileId, lastFeedId: 0, size: 6)
            .map { feedResult -> [FeedCellData] in
                feedResult.feeds.map { feed in
                    FeedCellData(
                        feed: feed,
                        avatarImage: self.profileDataRelay.value.avatarImage,
                        nickname: self.profileDataRelay.value.nickname
                    )
                }
            }
            .do(onNext: { [weak self] feedCellData in
                guard let self else { return }
                
                if feedCellData.isEmpty {
                    self.isEmptyFeedRelay.accept(true)
                } else {
                    
                    /// 5개까지만 활동뷰에 바인딩
                    /// 5개를 초과할 경우 더보기 버튼 뜨게 함
                    self.isEmptyFeedRelay.accept(false)
                    let hasMoreThanFive = feedCellData.count > 5
                    self.showFeedDetailButtonRelay.onNext(hasMoreThanFive)
                    self.bindFeedDataRelay.accept(Array(feedCellData.prefix(5)))
                }
            })
            .catch { [weak self] error in
                self?.isEmptyFeedRelay.accept(true)
                return .just([])
            }
            .map { _ in Void() }
    }
    
    private func handleFeedTableViewHeight(resizeFeedTableViewHeight: Observable<CGSize?>) -> Observable<CGFloat> {
        return resizeFeedTableViewHeight
            .map { $0?.height ?? 0 }
            .do(onNext: { [weak self] height in
                self?.updateFeedTableViewHeightRelay.accept(height)
            })
    }
    
    // MARK: - API
    
    private func getUserFeed(userId: Int, lastFeedId: Int, size: Int) -> Observable<MyFeedResult> {
        return userRepository.getUserFeed(userId: userId, lastFeedId: lastFeedId, size: size)
            .asObservable()
    }
}
