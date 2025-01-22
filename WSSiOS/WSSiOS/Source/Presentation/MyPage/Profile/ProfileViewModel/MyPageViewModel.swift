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
    
    private var profileId: Int
    private let userRepository: UserRepository
    private var stickyHeaderHeight: CGFloat = 0
    
    private let disposeBag = DisposeBag()
    
    private let isMyPageRelay = BehaviorRelay<Bool>(value: true)
    private let updateNavigationRelay = BehaviorRelay<(Bool, String)>(value: (false, ""))
    private let updateStickyHeaderRelay = BehaviorRelay<(Bool)>(value: (false))
    private let isProfilePrivateRelay = BehaviorRelay<(Bool, String)>(value: (false, ""))
    private let profileDataRelay = BehaviorRelay<MyProfileResult>(value: MyProfileResult(nickname: "", intro: "", avatarImage: "", genrePreferences: []))
    
    private let isExistPrefernecesRelay = PublishRelay<Bool>()
    
    private let bindFeedDataRelay = BehaviorRelay<[FeedCellData]>(value: [])
    private let isEmptyFeedRelay = PublishRelay<Bool>()
    private let showFeedDetailButtonRelay = BehaviorSubject<Bool>(value: false)

    private let updateFeedTableViewHeightRelay = PublishRelay<CGFloat>()
    
    private let pushToEditViewControllerRelay = PublishRelay<MyProfileResult>()
    private let pushToMyPageFeedDetailViewControllerRelay = PublishRelay<(Int, MyProfileResult)>()
    private let pushToFeedDetailViewController = PublishRelay<Int>()
    private let pushToNovelDetailViewController = PublishRelay<Int>()
    private let popViewControllerRelay = PublishRelay<Void>()
    
    private let stickyHeaderActionRelay = BehaviorRelay<Bool>(value: true)
    
    private let reloadSubject = PublishSubject<Void>()
    
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
        let viewWillAppearEvent: PublishSubject<Void>
        
        let headerViewHeight: Driver<Double>
        let resizefeedTableViewHeight: Observable<CGSize?>
        let scrollOffset: Driver<CGPoint>

        let dropdownButtonDidTap: Observable<String>
        let editButtonDidTap: ControlEvent<Void>
        
        let libraryButtonDidTap: Observable<Bool>
        let feedButtonDidTap: Observable<Bool>
        let feedDetailButtonDidTap: ControlEvent<Void>
        
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
        let popViewController: PublishRelay<Void>
        let pushToMyPageFeedDetailViewController: PublishRelay<(Int, MyProfileResult)>
        
        let bindFeedData: BehaviorRelay<[FeedCellData]>
        let updateFeedTableViewHeight: PublishRelay<CGFloat>
        let isEmptyFeed: PublishRelay<Bool>
        let showFeedDetailButton: BehaviorSubject<Bool>
        
        let stickyHeaderAction: BehaviorRelay<Bool>
//        let updateButtonWithLibraryView: BehaviorRelay<Bool>
        
        let pushToFeedDetailViewController: Observable<Int>
        let pushToNovelDetailViewController: Observable<Int>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        /// 진입 경로 분기처리
        /// 현재는 탭바로 진입할 때만 마이페이지!
        input.isEntryTabbar
            .subscribe(with: self, onNext: { owner, isMyPage in
                owner.isMyPageRelay.accept(isMyPage)
            })
            .disposed(by: disposeBag)
        
        /// 본인 프로필/타인 프로필 분기처리 후 headerView 업데이트
        /// 서재 - 보관함 데이터 업데이트
        /// 서재 - 나머지뷰 업데이트 후 키워드컬렉션뷰 높이 업데이트
        /// 피드 - 피드뷰 업데이트 후 피드테이블뷰 높이 업데이트
        Observable.merge(input.viewWillAppearEvent, reloadSubject)
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self else { return .empty() }
                return self.updateHeaderView(isMyPage: self.isMyPageRelay.value)
            }
            .flatMapLatest { [weak self]  _ -> Observable<Void> in
                guard let self else { return .empty() }
                guard !self.isProfilePrivateRelay.value.0 else { return .empty() }
                if self.profileId == 0 {
                    self.profileId =  UserDefaults.standard.integer(forKey: StringLiterals.UserDefault.userId)
                    reloadSubject.onNext(())
                    return .just(())
                }
                return Observable.concat([
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
        
        /// 스티키 헤더 처리
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
        
        input.editButtonDidTap
            .map { self.profileDataRelay.value }
            .bind(to: pushToEditViewControllerRelay)
            .disposed(by: disposeBag)
//        
//        input.libraryButtonDidTap
//            .subscribe(with: self, onNext: { owner, _ in
//                owner.stickyHeaderActionRelay.accept(true)
//                owner.updateButtonWithLibraryViewRelay.accept(true)
//            })
//            .disposed(by: disposeBag)
//        
//        input.feedButtonDidTap
//            .subscribe(with: self, onNext: { owner, _ in
//                owner.stickyHeaderActionRelay.accept(false)
//                owner.updateButtonWithLibraryViewRelay.accept(false)
//            })
//            .disposed(by: disposeBag)
        
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
        
        return Output(
            isMyPage: self.isMyPageRelay,
            isProfilePrivate: self.isProfilePrivateRelay,
            profileData: self.profileDataRelay,
            updateNavigationBar: self.updateNavigationRelay,
            updateStickyHeader: self.updateStickyHeaderRelay,
            
            pushToEditViewController: self.pushToEditViewControllerRelay,
            popViewController: self.popViewControllerRelay,
            pushToMyPageFeedDetailViewController: self.pushToMyPageFeedDetailViewControllerRelay,
            bindFeedData: self.bindFeedDataRelay,
            updateFeedTableViewHeight: self.updateFeedTableViewHeightRelay,
            isEmptyFeed: self.isEmptyFeedRelay,
            showFeedDetailButton: self.showFeedDetailButtonRelay,
            
            stickyHeaderAction: self.stickyHeaderActionRelay,
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
    
    /// 본인프로필과 타인프로필 분기처리
    /// 본인프로필일 때는 private 상태 false
    /// 타인프로필일 때 private 상태 분기처리
    /// 에러일 때 알 수 없음 프로필로 처리
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
                    
                    /// 현재 로직상 알 수 없는 유저 프로필을 확인하는 것은 불가능하지만
                    /// 서버에러에 대응하여 아래처럼 처리
                    if self.isUnknownUserError(error) {
                        let data = MyProfileResult(
                            nickname: "",
                            intro: "",
                            avatarImage: "",
                            genrePreferences: []
                        )
                        self.profileDataRelay.accept(data)
                        self.isProfilePrivateRelay.accept((false, ""))
                    }
                    return .empty()
                }
        }
    }
    
    /// 활동 데이터 바인딩
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
    
    private func getProfileData() -> Observable<MyProfileResult> {
        return userRepository.getMyProfileData()
            .observe(on: MainScheduler.instance)
    }
    
    private func getOtherProfileData(userId: Int) -> Observable<OtherProfileResult> {
        return userRepository.getOtherProfile(userId: userId)
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
