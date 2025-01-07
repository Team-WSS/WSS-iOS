//
//  MyPageViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 7/9/24.
//

import UIKit

import RxSwift
import RxCocoa

final class MyPageViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let profileId: Int
    private let userRepository: UserRepository
    private var stickyHeaderHeight: CGFloat = 0
    
    private let disposeBag = DisposeBag()
    
    private let isMyPageRelay = BehaviorRelay<Bool>(value: true)
    private let updateNavigationRelay = BehaviorRelay<(Bool, String)>(value: (false, ""))
    private let updateStickyHeaderRelay = BehaviorRelay<(Bool)>(value: (false))
    private let isProfilePrivateRelay = BehaviorRelay<(Bool, String)>(value: (false, ""))
    private let profileDataRelay = BehaviorRelay<MyProfileResult>(value: MyProfileResult(nickname: "", intro: "", avatarImage: "", genrePreferences: []))
    
    private let isExistPrefernecesRelay = PublishRelay<Bool>()
    private let bindInventoryDataRelay = BehaviorRelay<UserNovelStatus>(value: UserNovelStatus(interestNovelCount: 0, watchingNovelCount: 0, watchedNovelCount: 0, quitNovelCount: 0))
    let bindKeywordRelay = BehaviorRelay<[Keyword]>(value: [])
    private let bindAttractivePointsDataRelay = BehaviorRelay<[String]>(value: [])
    private let bindGenreDataRelay = BehaviorRelay<UserGenrePreferences>(value: UserGenrePreferences(genrePreferences: []))
    private let showGenreOtherViewRelay = BehaviorRelay<Bool>(value: false)
    
    private let bindFeedDataRelay = BehaviorRelay<[FeedCellData]>(value: [])
    private let isEmptyFeedRelay = PublishRelay<Void>()
    private let showFeedDetailButtonRelay = PublishRelay<Bool>()
    
    private let updateButtonWithLibraryViewRelay = BehaviorRelay<Bool>(value: true)
    private let updateFeedTableViewHeightRelay = PublishRelay<CGFloat>()
    private let updateKeywordCollectionViewHeightRelay = PublishRelay<CGFloat>()
    
    private let pushToEditViewControllerRelay = PublishRelay<MyProfileResult>()
    private let pushToSettingViewControllerRelay = PublishRelay<Void>()
    private let pushToLibraryViewControllerRelay = PublishRelay<Int>()
    private let pushToMyPageFeedDetailViewControllerRelay = PublishRelay<(Int, MyProfileResult)>()
    private let pushToFeedDetailViewController = PublishRelay<Int>()
    private let pushToNovelDetailViewController = PublishRelay<Int>()
    private let popViewControllerRelay = PublishRelay<Void>()
    
    private let showToastViewRelay = PublishRelay<Void>()
    private let showUnknownUserAlertRelay = PublishRelay<Void>()
    private let stickyHeaderActionRelay = BehaviorRelay<Bool>(value: true)
    
    // MARK: - Life Cycle
    
    init(userRepository: UserRepository, profileId: Int) {
        self.userRepository = userRepository
        if profileId == 0 {
            let userId = UserDefaults.standard.integer(forKey: StringLiterals.UserDefault.userId)
            self.profileId = userId
        } else {
            self.profileId = profileId
        }
    }
    
    struct Input {
        let isEntryTabbar: Observable<Bool>
        let viewWillAppearEvent: PublishRelay<Bool>
        
        let headerViewHeight: Driver<Double>
        let resizefeedTableViewHeight: Observable<CGSize?>
        let resizeKeywordCollectionViewHeight: Observable<CGSize?>
        let scrollOffset: Driver<CGPoint>
        
        let settingButtonDidTap: ControlEvent<Void>
        let dropdownButtonDidTap: Observable<String>
        let editButtonDidTap: ControlEvent<Void>
        let backButtonDidTap: ControlEvent<Void>
        
        let genrePreferenceButtonDidTap: Observable<Bool>
        let libraryButtonDidTap: Observable<Bool>
        let feedButtonDidTap: Observable<Bool>
        let inventoryViewDidTap: Observable<UITapGestureRecognizer>
        let feedDetailButtonDidTap: ControlEvent<Void>
        
        let editProfileNotification: Observable<Notification>
        
        let feedTableViewItemSelected: Observable<IndexPath>
        let feedConnectedNovelViewDidTap: Observable<Int>
    }
    
    struct Output {
        let isMyPage: BehaviorRelay<Bool>
        let isProfilePrivate: BehaviorRelay<(Bool, String)>
        let profileData: BehaviorRelay<MyProfileResult>
        let updateNavigationBar: BehaviorRelay<(Bool, String)>
        let updateStickyHeader: BehaviorRelay<(Bool)>
        
        let pushToEditViewController: PublishRelay<MyProfileResult>
        let pushToSettingViewController: PublishRelay<Void>
        let popViewController: PublishRelay<Void>
        let pushToLibraryViewController: PublishRelay<Int>
        let pushToMyPageFeedDetailViewController: PublishRelay<(Int, MyProfileResult)>
        
        let bindAttractivePointsData: BehaviorRelay<[String]>
        let bindKeywordCell: BehaviorRelay<[Keyword]>
        let updateKeywordCollectionViewHeight: PublishRelay<CGFloat>
        let bindGenreData: BehaviorRelay<UserGenrePreferences>
        let bindInventoryData: BehaviorRelay<UserNovelStatus>
        
        let showGenreOtherView: BehaviorRelay<Bool>
        let isExistPreferneces: PublishRelay<Bool>
        
        let bindFeedData: BehaviorRelay<[FeedCellData]>
        let updateFeedTableViewHeight: PublishRelay<CGFloat>
        let isEmptyFeed: PublishRelay<Void>
        let showFeedDetailButton: PublishRelay<Bool>
        
        let showToastView: PublishRelay<Void>
        let stickyHeaderAction: BehaviorRelay<Bool>
        let updateButtonWithLibraryView: BehaviorRelay<Bool>
        
        let pushToFeedDetailViewController: Observable<Int>
        let pushToNovelDetailViewController: Observable<Int>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        // 진입 경로 분기처리
        // 현재는 탭바로 진입할 때만 마이페이지!
        input.isEntryTabbar
            .subscribe(with: self, onNext: { owner, isMyPage in
                owner.isMyPageRelay.accept(isMyPage)
            })
            .disposed(by: disposeBag)
        
        //본인 프로필/타인 프로필 분기처리 후 headerView 업데이트
        //서재 - 보관함 데이터 업데이트
        //서재 - 나머지뷰 업데이트 후 키워드컬렉션뷰 높이 업데이트
        //피드 - 피드뷰 업데이트 후 피드테이블뷰 높이 업데이트
        input.viewWillAppearEvent
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self else { return .empty() }
                return self.updateHeaderView(isMyPage: self.isMyPageRelay.value)
            }
            .flatMapLatest { [weak self]  _ -> Observable<Void> in
                guard let self else { return .empty() }
                guard !self.isProfilePrivateRelay.value.0 else { return .empty() }
                return Observable.concat([
                    self.updateMyPageLibraryInventoryData()
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
                let navigationText = owner.isMyPageRelay.value ? StringLiterals.Navigation.Title.myPage : owner.profileDataRelay.value.nickname
                
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
        
        input.settingButtonDidTap
            .bind(to: pushToSettingViewControllerRelay)
            .disposed(by: disposeBag)
        
        input.editButtonDidTap
            .map { self.profileDataRelay.value }
            .bind(to: pushToEditViewControllerRelay)
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .bind(to: popViewControllerRelay)
            .disposed(by: disposeBag)
        
        input.libraryButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.stickyHeaderActionRelay.accept(true)
                owner.updateButtonWithLibraryViewRelay.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.feedButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.stickyHeaderActionRelay.accept(false)
                owner.updateButtonWithLibraryViewRelay.accept(false)
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
                NotificationCenter.default.post(name: NSNotification.Name("BlockUser"), object: nickname)
                owner.popViewControllerRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        input.inventoryViewDidTap
            .bind(with: self, onNext: { owner, _ in
                self.pushToLibraryViewControllerRelay.accept(owner.profileId)
            })
            .disposed(by: disposeBag)
        
        input.feedDetailButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                self.pushToMyPageFeedDetailViewControllerRelay.accept((owner.profileId, owner.profileDataRelay.value))
            })
            .disposed(by: disposeBag)
        
        //알 수 없음 유저일 때 분기처리
        self.showUnknownUserAlertRelay
            .subscribe(with: self, onNext: { owner, _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    NotificationCenter.default.post(name: NSNotification.Name("UnknownUser"), object: nil)
                }
                self.popViewControllerRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        //토스트뷰를 위한 분기처리
        input.editProfileNotification
            .bind(with: self, onNext: { owner, _ in
                self.showToastViewRelay.accept(())
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
        
        return Output(
            isMyPage: self.isMyPageRelay,
            isProfilePrivate: self.isProfilePrivateRelay,
            profileData: self.profileDataRelay,
            updateNavigationBar: self.updateNavigationRelay,
            updateStickyHeader: self.updateStickyHeaderRelay,
            
            pushToEditViewController: self.pushToEditViewControllerRelay,
            pushToSettingViewController: self.pushToSettingViewControllerRelay,
            popViewController: self.popViewControllerRelay,
            pushToLibraryViewController: self.pushToLibraryViewControllerRelay,
            pushToMyPageFeedDetailViewController: self.pushToMyPageFeedDetailViewControllerRelay,
            
            bindAttractivePointsData: self.bindAttractivePointsDataRelay,
            bindKeywordCell: self.bindKeywordRelay,
            updateKeywordCollectionViewHeight: self.updateKeywordCollectionViewHeightRelay,
            bindGenreData: self.bindGenreDataRelay,
            bindInventoryData: self.bindInventoryDataRelay,
            showGenreOtherView: self.showGenreOtherViewRelay,
            isExistPreferneces: self.isExistPrefernecesRelay,
            
            bindFeedData: self.bindFeedDataRelay,
            updateFeedTableViewHeight: self.updateFeedTableViewHeightRelay,
            isEmptyFeed: self.isEmptyFeedRelay,
            showFeedDetailButton: self.showFeedDetailButtonRelay,
            
            showToastView: self.showToastViewRelay,
            stickyHeaderAction: self.stickyHeaderActionRelay,
            updateButtonWithLibraryView: self.updateButtonWithLibraryViewRelay,
            pushToFeedDetailViewController: self.pushToFeedDetailViewController.asObservable(),
            pushToNovelDetailViewController: self.pushToNovelDetailViewController.asObservable()
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
    
    //본인프로필과 타인프로필 분기처리
    //본인프로필일 때는 private 상태 false
    //타인프로필일 때 private 상태 분기처리
    //에러일 때 알 수 없음 프로필로 처리
    private func updateHeaderView(isMyPage: Bool) -> Observable<Void> {
        if isMyPage {
            return self.getProfileData()
                .do(onNext: { profileData in
                    self.profileDataRelay.accept(profileData)
                    self.isProfilePrivateRelay.accept((false, profileData.nickname))
                })
                .map { _ in }
        } else {
            return self.getOtherProfileData(userId: self.profileId)
                .do(onNext: { profileData in
                    let data = MyProfileResult(
                        nickname: profileData.nickname,
                        intro: profileData.intro,
                        avatarImage: profileData.avatarImage,
                        genrePreferences: profileData.genrePreferences
                    )
                    self.profileDataRelay.accept(data)
                    self.isProfilePrivateRelay.accept((!profileData.isProfilePublic, profileData.nickname))
                })
                .map { _ in }
                .catch { [weak self] error in
                    guard let self else { return .empty() }
                    
                    if self.isUnknownUserError(error) {
                        self.showUnknownUserAlertRelay.accept(())
                    }
                    return .empty()
                }
        }
    }
    
    //서재 데이터 바인딩
    //보관함-장르취향-작품취향 서버연결
    private func updateMyPageLibraryInventoryData() -> Observable<Void> {
        return getInventoryData(userId: self.profileId)
            .do(onNext: { [weak self] inventory in
                guard let self else { return }
                self.bindInventoryDataRelay.accept(inventory)
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
                let keywords = preference.keywords ?? []
                if preference.attractivePoints == [] && keywords.isEmpty {
                    self.isExistPrefernecesRelay.accept(false)
                    return .just(false)
                } else {
                    self.bindAttractivePointsDataRelay.accept(preference.attractivePoints ?? [])
                    self.bindKeywordRelay.accept(keywords)
                    return .just(true)
                }
            }
        
        //회원가입후 처음 접속시 서버연결 에러가 나서 분기처리가 제대로 안된 에러 발생
        //=> 해결 위하여 서버연결 실패시 emptyView 처리
            .catch { [weak self] error in
                self?.isExistPrefernecesRelay.accept(false)
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
                    self.isEmptyFeedRelay.accept(())
                } else {
                    
                    //5개까지만 활동뷰에 바인딩
                    //5개를 초과할 경우 더보기 버튼 뜨게 함
                    let hasMoreThanFive = feedCellData.count > 5
                    self.showFeedDetailButtonRelay.accept(hasMoreThanFive)
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
    
    private func getProfileData() -> Observable<MyProfileResult> {
        return userRepository.getMyProfileData()
            .observe(on: MainScheduler.instance)
    }
    
    private func getOtherProfileData(userId: Int) -> Observable<OtherProfileResult> {
        return userRepository.getOtherProfile(userId: userId)
            .asObservable()
    }
    
    private func getNovelPreferenceData(userId: Int) -> Observable<UserNovelPreferences> {
        return userRepository.getUserNovelPreferences(userId: userId)
            .asObservable()
    }
    
    private func getGenrePreferenceData(userId: Int) -> Observable<UserGenrePreferences> {
        return userRepository.getUserGenrePreferences(userId: userId)
            .asObservable()
    }
    
    private func getInventoryData(userId: Int) -> Observable<UserNovelStatus> {
        return userRepository.getUserNovelStatus(userId: userId)
            .asObservable()
    }
    
    private func postBlockUser(userId: Int) -> Observable<Void> {
        return userRepository.postBlockUser(userId: userId)
            .asObservable()
    }
    
    private func getUserFeed(userId: Int, lastFeedId: Int, size: Int) -> Observable<MyFeedResult> {
        return userRepository.getUserFeed(userId: userId, lastFeedId: lastFeedId, size: size)
            .asObservable()
    }
}
