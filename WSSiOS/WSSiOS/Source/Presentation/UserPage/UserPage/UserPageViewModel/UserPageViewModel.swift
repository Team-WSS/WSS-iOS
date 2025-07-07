//
//  UserPageViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 5/20/25.
//

import UIKit

import RxSwift
import RxCocoa

final class UserPageViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private var profileId: Int
    private let userRepository: UserRepository
    private var stickyHeaderHeight: CGFloat = 0
    
    private let disposeBag = DisposeBag()
    
    private let updateNavigationRelay = BehaviorRelay<(Bool, String)>(value: (false, ""))
    private let updateStickyHeaderRelay = BehaviorRelay<(Bool)>(value: (false))
    private let isProfilePrivateRelay = PublishRelay<String>()
    private let profileDataRelay = BehaviorRelay<UserProfileEntity>(value: UserProfileEntity(nickname: "",
                                                                                             intro: "",
                                                                                             genrePreferences: [],
                                                                                             isProfilePublic: true,
                                                                                             avatarImageURL: nil))
    private let isEmptyPrefernecesRelay = PublishRelay<Void>()
    private let bindLibraryStatusDataRelay = BehaviorRelay<UserNovelStatusEntity>(value: UserNovelStatusEntity(interestNovelCount: 0,
                                                                                                           watchingNovelCount: 0,
                                                                                                           watchedNovelCount: 0,
                                                                                                           quitNovelCount: 0))
    let bindKeywordRelay = BehaviorRelay<[KeywordEntity]>(value: [])
    private let bindAttractivePointsDataRelay = BehaviorRelay<[String]>(value: [])
    private let bindGenreDataRelay = BehaviorRelay<UserGenrePreferencesListEntity>(value: UserGenrePreferencesListEntity(genrePreferences: [], genreTotalCount: 0))
    private let showGenreOtherViewRelay = BehaviorRelay<Bool>(value: false)
    
    private let bindFeedDataRelay = BehaviorRelay<[UserFeedListItem]>(value: [])
    private let isEmptyFeedRelay = PublishRelay<Void>()
    private let showFeedDetailButtonRelay = BehaviorSubject<Bool>(value: false)
    
    private let updateButtonWithOverviewViewRelay = BehaviorRelay<Bool>(value: true)
    private let updateFeedTableViewHeightRelay = PublishRelay<CGFloat>()
    private let updateKeywordCollectionViewHeightRelay = PublishRelay<CGFloat>()
    
    private let pushToLibraryViewControllerRelay = PublishRelay<Int>()
    private let pushToUserPageFeedDetailViewControllerRelay = PublishRelay<(Int, UserProfileEntity)>()
    private let pushToFeedDetailViewController = PublishRelay<Int>()
    private let pushToNovelDetailViewController = PublishRelay<Int>()
    private let popViewControllerRelay = PublishRelay<Void>()
    private let pushToSpecificLibraryViewController = PublishSubject<(Int,Int)>()
    private let stickyHeaderActionRelay = BehaviorRelay<Bool>(value: true)
    
    private let reloadSubject = PublishSubject<Void>()
    
    // MARK: - Life Cycle
    
    init(userRepository: UserRepository, profileId: Int) {
        self.userRepository = userRepository
        self.profileId = profileId
    }
    
    struct Input {
        let viewWillAppearEvent: PublishSubject<Void>
        
        let headerViewHeight: Driver<Double>
        let resizefeedTableViewHeight: Observable<CGSize?>
        let resizeKeywordCollectionViewHeight: Observable<CGSize?>
        let scrollOffset: Driver<CGPoint>
        
        let dropdownButtonDidTap: Observable<String>
        let backButtonDidTap: ControlEvent<Void>
        
        let genrePreferenceButtonDidTap: Observable<Bool>
        let overviewButtonDidTap: Observable<Bool>
        let feedButtonDidTap: Observable<Bool>
        let libraryStatusViewDidTap: Observable<UITapGestureRecognizer>
        let libraryStatusSpecificPageViewDidTap: Observable<Int>
        let feedDetailButtonDidTap: ControlEvent<Void>
        let feedTableViewItemSelected: Observable<IndexPath>
        let feedConnectedNovelViewDidTap: Observable<Int>
    }
    
    struct Output {
        let isProfilePrivate: PublishRelay<String>
        let profileData: BehaviorRelay<UserProfileEntity>
        let updateNavigationBar: BehaviorRelay<(Bool, String)>
        let updateStickyHeader: BehaviorRelay<(Bool)>
        
        let popViewController: PublishRelay<Void>
        let pushToLibraryViewController: PublishRelay<Int>
        let pushToUserPageFeedDetailViewController: PublishRelay<(Int, UserProfileEntity)>
        
        let bindAttractivePointsData: BehaviorRelay<[String]>
        let bindKeywordCell: BehaviorRelay<[KeywordEntity]>
        let updateKeywordCollectionViewHeight: PublishRelay<CGFloat>
        let bindGenreData: BehaviorRelay<UserGenrePreferencesListEntity>
        let bindLibraryStatusData: BehaviorRelay<UserNovelStatusEntity>
        
        let showGenreOtherView: BehaviorRelay<Bool>
        let isEmptyPreferneces: PublishRelay<Void>
        
        let bindFeedData: BehaviorRelay<[UserFeedListItem]>
        let updateFeedTableViewHeight: PublishRelay<CGFloat>
        let isEmptyFeed: PublishRelay<Void>
        let showFeedDetailButton: BehaviorSubject<Bool>
        
        let stickyHeaderAction: BehaviorRelay<Bool>
        let updateButtonWithOverviewView: BehaviorRelay<Bool>
        
        let pushToFeedDetailViewController: Observable<Int>
        let pushToNovelDetailViewController: Observable<Int>
        let pushToSpecificLibraryViewController: PublishSubject<(Int, Int)>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        //서재 - 보관함 데이터 업데이트
        //서재 - 나머지뷰 업데이트 후 키워드컬렉션뷰 높이 업데이트
        //피드 - 피드뷰 업데이트 후 피드테이블뷰 높이 업데이트
        Observable.merge(input.viewWillAppearEvent, reloadSubject)
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self else { return .empty() }
                return self.updateHeaderView()
            }
            .flatMapLatest { [weak self]  _ -> Observable<Void> in
                guard let self else { return .empty() }
                return Observable.concat([
                    self.updateMyPageLibraryStatusData()
                        .map { _ in Void() },
                    self.updateMyPageLibraryPreferenceData()
                        .do(onNext: { [weak self] _ in
                            guard let self else { return }
                            self.handleKeywordCollectionViewHeight(resizeKeywordCollectionViewHeight: input.resizeKeywordCollectionViewHeight)
                                .subscribe()
                                .disposed(by: self.disposeBag)
                        })
                        .map { _ in Void() },
                    self.updateMyPageFeedData()
                        .do(onNext: { [weak self] _ in
                            guard let self else { return }
                            self.handleFeedTableViewHeight(resizeFeedTableViewHeight: input.resizefeedTableViewHeight)
                                .subscribe()
                                .disposed(by: self.disposeBag)
                        })
                        .map { _ in Void() }
                ])
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        // 스티키 헤더 처리
        input.headerViewHeight
            .asObservable()
            .bind(with: self, onNext: { owner, height in
                owner.stickyHeaderHeight = height
            })
            .disposed(by: disposeBag)
        
        input.scrollOffset
            .asObservable()
            .map{ $0.y }
            .subscribe(with: self, onNext: { owner, scrollHeight in
                let navigationText = owner.profileDataRelay.value.nickname
                
                owner.updateNavigationRelay.accept((scrollHeight > 0, navigationText))
                owner.updateStickyHeaderRelay.accept(scrollHeight > owner.stickyHeaderHeight)
            })
            .disposed(by: disposeBag)
        
        // 버튼 클릭 이벤트 처리
        input.genrePreferenceButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                let currentState = owner.showGenreOtherViewRelay.value
                owner.showGenreOtherViewRelay.accept(!currentState)
            })
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .bind(to: popViewControllerRelay)
            .disposed(by: disposeBag)
        
        input.overviewButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.stickyHeaderActionRelay.accept(true)
                owner.updateButtonWithOverviewViewRelay.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.feedButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.stickyHeaderActionRelay.accept(false)
                owner.updateButtonWithOverviewViewRelay.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.dropdownButtonDidTap
            .filter { $0 == StringLiterals.MyPage.BlockUser.toastText }
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self else { return .empty() }
                return self.postBlockUser(userId: self.profileId)
            }
            .subscribe(with: self, onNext: { owner, _ in
                AmplitudeManager.shared.track(AmplitudeEvent.MyPage.otherBlock)
                let nickname = owner.profileDataRelay.value.nickname
                NotificationCenter.default.post(name: NotificationName.blockUser, object: nickname)
                owner.popViewControllerRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        input.libraryStatusViewDidTap
            .bind(with: self, onNext: { owner, _ in
                self.pushToLibraryViewControllerRelay.accept(owner.profileId)
            })
            .disposed(by: disposeBag)
        
        input.feedDetailButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                self.pushToUserPageFeedDetailViewControllerRelay.accept((owner.profileId, owner.profileDataRelay.value))
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
        
        input.libraryStatusSpecificPageViewDidTap
            .bind(with: self, onNext: { owner, pageIndex in
                self.pushToSpecificLibraryViewController.onNext((owner.profileId, pageIndex))
            })
            .disposed(by: disposeBag)
        
        return Output(
            isProfilePrivate: self.isProfilePrivateRelay,
            profileData: self.profileDataRelay,
            updateNavigationBar: self.updateNavigationRelay,
            updateStickyHeader: self.updateStickyHeaderRelay,
            
            popViewController: self.popViewControllerRelay,
            pushToLibraryViewController: self.pushToLibraryViewControllerRelay,
            pushToUserPageFeedDetailViewController: self.pushToUserPageFeedDetailViewControllerRelay,
            
            bindAttractivePointsData: self.bindAttractivePointsDataRelay,
            bindKeywordCell: self.bindKeywordRelay,
            updateKeywordCollectionViewHeight: self.updateKeywordCollectionViewHeightRelay,
            bindGenreData: self.bindGenreDataRelay,
            bindLibraryStatusData: self.bindLibraryStatusDataRelay,
            
            showGenreOtherView: self.showGenreOtherViewRelay,
            isEmptyPreferneces: self.isEmptyPrefernecesRelay,
            
            bindFeedData: self.bindFeedDataRelay,
            updateFeedTableViewHeight: self.updateFeedTableViewHeightRelay,
            isEmptyFeed: self.isEmptyFeedRelay,
            showFeedDetailButton: self.showFeedDetailButtonRelay,
            
            stickyHeaderAction: self.stickyHeaderActionRelay,
            updateButtonWithOverviewView: self.updateButtonWithOverviewViewRelay,
            pushToFeedDetailViewController: self.pushToFeedDetailViewController.asObservable(),
            pushToNovelDetailViewController: self.pushToNovelDetailViewController.asObservable(),
            pushToSpecificLibraryViewController: pushToSpecificLibraryViewController
        )
    }
    
    // MARK: - Custom Method
    
    private func isUnknownUserError(_ error: Error) -> Bool {
        if let networkError = error as? RxCocoaURLError {
            switch networkError {
            case .httpRequestFailed(_, let data):
                if let data = data {
                    do {
                        let errorInfo = try JSONDecoder().decode(ServerErrorResponse.self, from: data)
                        return errorInfo.code == "USER-018"
                    } catch {}
                }
                
            default:
                return false
            }
        }
        return false
    }
    
    private func updateHeaderView() -> Observable<Void> {
        return self.getOtherProfileData(userId: self.profileId)
            .do(onNext: { profileData in
                let data = UserProfileEntity(nickname: profileData.nickname,
                                             intro: profileData.intro,
                                             genrePreferences: profileData.genrePreferences,
                                             isProfilePublic: profileData.isProfilePublic,
                                             avatarImageURL: profileData.avatarImageURL)
                self.profileDataRelay.accept(data)
                if !profileData.isProfilePublic {
                    self.isProfilePrivateRelay.accept(profileData.nickname)
                }
            })
            .map { _ in }
            .catch { [weak self] error in
                guard let self else { return .empty() }
                
                //현재 로직상 알 수 없는 유저 프로필을 확인하는 것은 불가능하지만
                //서버에러에 대응하여 알 수 없음 프로필로 처리
                if self.isUnknownUserError(error) {
                    let data = UserProfileEntity(nickname: "",
                                                 intro: "",
                                                 genrePreferences: [],
                                                 isProfilePublic: true,
                                                 avatarImageURL: nil)
                    self.profileDataRelay.accept(data)
                    self.isProfilePrivateRelay.accept("")
                }
                return .empty()
            }
    }
    
    //서재 데이터 바인딩
    //보관함-장르취향-작품취향 서버연결
    private func updateMyPageLibraryStatusData() -> Observable<Void> {
        return getLibraryStatusData(userId: self.profileId)
            .do(onNext: { [weak self] libraryStatus in
                guard let self else { return }
                self.bindLibraryStatusDataRelay.accept(libraryStatus)
            })
            .map { _ in Void() }
    }
    
    //취향분석 데이터 바인딩
    private func updateMyPageLibraryPreferenceData() -> Observable<Void> {
        return getNovelPreferenceData(userId: self.profileId)
            .flatMap { [weak self] preference -> Observable<Bool> in
                guard let self else { return .just(false) }
                
                //작품취향 분기처리
                //1. 매력포인트, 키워드 둘 다 있을 때
                //2. 매력포인트만 있을 때
                //3. 키워드만 있을 때
                // => 각각의 뷰만 뜨게 함
                
                //4. 둘 다 없을 때
                //=> emptyView 처리
                //=> 이 경우 장르 취향도 데이터가 없기 때문에 false 반환
                let keywords = preference.keywords
                if preference.attractivePoints == [] && keywords.isEmpty {
                    self.isEmptyPrefernecesRelay.accept(())
                    return .just(false)
                } else {
                    self.bindAttractivePointsDataRelay.accept(preference.attractivePoints)
                    self.bindKeywordRelay.accept(keywords)
                    return .just(true)
                }
            }
        
        //회원가입후 처음 접속시 서버연결 에러가 나서 분기처리가 제대로 안된 에러 발생
        //=> 해결 위하여 서버연결 실패시 emptyView 처리
            .catch { [weak self] error in
                self?.isEmptyPrefernecesRelay.accept(())
                return .just(false)
            }
        
        // 장르 취향
            .flatMap { [weak self] isExist -> Observable<Void> in
                guard let self else { return .empty() }
                if isExist {
                    return self.getGenrePreferenceData(userId: self.profileId)
                        .do(onNext: { data in
                            if !data.genrePreferences.isEmpty {
                                self.bindGenreDataRelay.accept(data)
                            }
                        })
                        .map { _ in Void() }
                } else {
                    return .just(Void())
                }
            }
    }
    
    // 활동 데이터 바인딩
    private func updateMyPageFeedData() -> Observable<Void> {
        return getUserFeed(userId: self.profileId, lastFeedId: 0, size: 6)
            .map { feedResult -> [UserFeedListItem] in
                feedResult.feeds.map { feed in
                    UserFeedListItem(
                        feed: feed,
                        avatarImage: self.profileDataRelay.value.avatarImageURL,
                        nickname: self.profileDataRelay.value.nickname
                    )
                }
            }
            .do(onNext: { [weak self] feedCellData in
                guard let self else { return }
                
                if feedCellData.isEmpty {
                    self.isEmptyFeedRelay.accept(())
                } else {
                    
                    //5개까지만 활동뷰에 바인딩
                    //5개를 초과할 경우 더보기 버튼 뜨게 함
                    let hasMoreThanFive = feedCellData.count > 5
                    self.showFeedDetailButtonRelay.onNext(hasMoreThanFive)
                    self.bindFeedDataRelay.accept(Array(feedCellData.prefix(5)))
                }
            })
            .catch { [weak self] error in
                self?.isEmptyFeedRelay.accept(())
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
    
    private func handleKeywordCollectionViewHeight(resizeKeywordCollectionViewHeight: Observable<CGSize?>) -> Observable<CGFloat> {
        return resizeKeywordCollectionViewHeight
            .map { $0?.height ?? 0 }
            .do(onNext: { [weak self] height in
                self?.updateKeywordCollectionViewHeightRelay.accept(height)
            })
    }
    
    // MARK: - API
    
    private func getOtherProfileData(userId: Int) -> Observable<UserProfileEntity> {
        return userRepository.userInfoRepository.getOtherProfile(userId: userId)
    }
    
    private func getNovelPreferenceData(userId: Int) -> Observable<UserNovelPreferencesEntity> {
        return userRepository.userInfoRepository.getUserNovelPreferences(userId: userId)
    }
    
    private func getGenrePreferenceData(userId: Int) -> Observable<UserGenrePreferencesListEntity> {
        return userRepository.userInfoRepository.getUserGenrePreferences(userId: userId)
    }
    
    private func getLibraryStatusData(userId: Int) -> Observable<UserNovelStatusEntity> {
        return userRepository.userInfoRepository.getUserNovelStatus(userId: userId)
    }
    
    private func postBlockUser(userId: Int) -> Observable<Void> {
        return userRepository.userBlockRepository.postBlockUser(userId: userId)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
    }
    
    private func getUserFeed(userId: Int, lastFeedId: Int, size: Int) -> Observable<UserFeedListEntity> {
        return userRepository.userInfoRepository.getUserFeed(userId: userId, lastFeedId: lastFeedId, size: size, filterOption: nil, sortType: nil)
    }
}
