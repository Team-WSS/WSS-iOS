//
//  MyPageProfileFeedViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 3/19/25.
//

import UIKit

import RxSwift
import RxCocoa

protocol MyPageProfileFeedViewModelDelegate: AnyObject {
    func bindProfileId(profileId: Int)
    func transform(from input: MyPageProfileFeedViewModel.Input, disposeBag: DisposeBag) -> MyPageProfileFeedViewModel.Output
}

final class MyPageProfileFeedViewModel: ViewModelType, MyPageProfileFeedViewModelDelegate {
    
    // MARK: - Properties
    
    private let userInfoRepository: UserInfoRepository
    private var profileId = BehaviorRelay<Int>(value: 0)
    private let disposeBag = DisposeBag()
    
    private let profileData = BehaviorRelay<ProfileFeedData>(value: ProfileFeedData(nickname: "",
                                                                                    avatarImage: ""))
    private let bindFeedData = BehaviorRelay<[MyFeedListItem]>(value: [])
    private let updateFeedTableViewHeight = PublishRelay<CGFloat>()
    private let isEmptyFeed = PublishRelay<Bool>()
    private let showFeedDetailButton = BehaviorSubject<Bool>(value: false)
    private let pushToMyPageFeedDetailViewController = PublishRelay<(Int, ProfileFeedData)>()
    private let pushToFeedDetailViewController = PublishRelay<Int>()
    private let pushToNovelDetailViewController = PublishRelay<Int>()
    
    // MARK: - Life Cycle
    
    init(userInfoRepository: UserInfoRepository) {
        self.userInfoRepository = userInfoRepository
    }
    
    struct Input {
        let profileData: Observable<ProfileFeedData>
        let viewWillAppearEvent: PublishSubject<Void>
        let resizefeedTableViewHeight: Observable<CGSize?>
        let feedDetailButtonDidTap: ControlEvent<Void>
        let feedTableViewItemSelected: Observable<IndexPath>
        let feedConnectedNovelViewDidTap: Observable<Int>
    }
    
    struct Output {
        let bindFeedData: BehaviorRelay<[MyFeedListItem]>
        let updateFeedTableViewHeight: PublishRelay<CGFloat>
        let isEmptyFeed: PublishRelay<Bool>
        let showFeedDetailButton: BehaviorSubject<Bool>
        let pushToMyPageFeedDetailViewController: Observable<(Int, ProfileFeedData)>
        let pushToFeedDetailViewController: Observable<Int>
        let pushToNovelDetailViewController: Observable<Int>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewWillAppearEvent
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self else { return .empty() }
                return self.updateMyPageFeedData()
            }
            .flatMapLatest { [weak self] _ -> Observable<CGFloat> in
                guard let self else { return .empty() }
                return self.handleFeedTableViewHeight(resizeFeedTableViewHeight: input.resizefeedTableViewHeight)
            }
            .bind(to: self.updateFeedTableViewHeight)
            .disposed(by: self.disposeBag)
        
        input.profileData
            .bind(to: self.profileData)
            .disposed(by: disposeBag)
        
        input.feedDetailButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                self.pushToMyPageFeedDetailViewController.accept((owner.profileId.value, owner.profileData.value))
            })
            .disposed(by: disposeBag)
        
        input.feedTableViewItemSelected
            .bind(with: self, onNext: { owner, indexPath in
                let feedId = self.bindFeedData.value[indexPath.row].feed.feedId
                self.pushToFeedDetailViewController.accept(feedId)
            })
            .disposed(by: disposeBag)
        
        input.feedConnectedNovelViewDidTap
            .bind(with: self, onNext: { owner, novelId in
                self.pushToNovelDetailViewController.accept(novelId)
            })
            .disposed(by: disposeBag)
        
        return Output(bindFeedData: self.bindFeedData,
                      updateFeedTableViewHeight: self.updateFeedTableViewHeight,
                      isEmptyFeed: self.isEmptyFeed,
                      showFeedDetailButton: self.showFeedDetailButton,
                      pushToMyPageFeedDetailViewController: self.pushToMyPageFeedDetailViewController.asObservable(),
                      pushToFeedDetailViewController: self.pushToFeedDetailViewController.asObservable(),
                      pushToNovelDetailViewController: self.pushToNovelDetailViewController.asObservable())
    }
    
    // MARK: - Bind Data
    
    func bindProfileId(profileId: Int) {
        self.profileId.accept(profileId)
    }
    
    // MARK: - Custom Method
    
    private func handleFeedTableViewHeight(resizeFeedTableViewHeight: Observable<CGSize?>) -> Observable<CGFloat> {
        return resizeFeedTableViewHeight
            .map { $0?.height ?? 0 }
            .do(onNext: { [weak self] height in
                self?.updateFeedTableViewHeight.accept(height)
            })
    }
    
    private func updateMyPageFeedData() -> Observable<Void> {
        return getUserFeed(userId: self.profileId.value, lastFeedId: 0, size: 6)
            .map { feedResult -> [MyFeedListItem] in
                feedResult.feeds.map { feed in
                    MyFeedListItem(
                        feed: feed,
                        avatarImage: self.profileData.value.avatarImage,
                        nickname: self.profileData.value.nickname
                    )
                }
            }
            .do(onNext: { [weak self] feedCellData in
                guard let self else { return }
                
                if feedCellData.isEmpty {
                    self.isEmptyFeed.accept(true)
                } else {
                    
                    //5개까지만 활동뷰에 바인딩
                    //5개를 초과할 경우 더보기 버튼 뜨게 함
                    self.isEmptyFeed.accept(false)
                    let hasMoreThanFive = feedCellData.count > 5
                    self.showFeedDetailButton.onNext(hasMoreThanFive)
                    self.bindFeedData.accept(Array(feedCellData.prefix(5)))
                }
            })
            .catch { [weak self] error in
                self?.isEmptyFeed.accept(true)
                return .just([])
            }
            .map { _ in Void() }
    }
    
    // MARK: - API
    
    private func getUserFeed(userId: Int, lastFeedId: Int, size: Int) -> Observable<MyFeedListEntity> {
        return userInfoRepository.getUserFeed(userId: userId, lastFeedId: lastFeedId, size: size)
    }
}
