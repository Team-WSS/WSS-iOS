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
    private let profileLibraryViewModel: MyPageProfileLibraryViewModelDelegate
    private let profileFeedViewModel: MyPageProfileFeedViewModelDelegate
    private let disposeBag = DisposeBag()
    
    private var stickyHeaderHeight: CGFloat = 0
    private let isMyPageRelay = BehaviorRelay<Bool>(value: true)
    private let viewWillAppearForChildViewModel = PublishSubject<Void>()
    private let reloadSubject = PublishSubject<Void>()
    private let updateNavigationRelay = BehaviorRelay<(Bool, String)>(value: (false, ""))
    private let updateStickyHeaderRelay = BehaviorRelay<(Bool)>(value: (false))
    private let isProfilePrivateRelay = BehaviorRelay<(Bool, String)>(value: (false, ""))
    private let profileDataRelay = BehaviorRelay<MyProfileEntity>(value: MyProfileEntity(nickname: "",
                                                                                         intro: "",
                                                                                         avatarImage: "",
                                                                                         genrePreferences: []))
    private let profileFeedData = BehaviorRelay<ProfileFeedData>(value: ProfileFeedData(nickname: "",
                                                                                        avatarImage: ""))
    
    private let updateButtonWithLibraryViewRelay = BehaviorRelay<Bool>(value: true)
    
    private let pushToEditViewControllerRelay = PublishRelay<MyProfileEntity>()
    private let pushToSettingViewControllerRelay = PublishRelay<Void>()
    private let pushToLibraryViewControllerRelay = PublishRelay<Int>()
    private let popViewControllerRelay = PublishRelay<Void>()
    
    private let showToastViewRelay = PublishRelay<Void>()
    private let stickyHeaderActionRelay = BehaviorRelay<Bool>(value: true)
    
    // MARK: - Life Cycle
    
    init(profileLibraryViewModel: MyPageProfileLibraryViewModelDelegate,
        profileFeedViewModel: MyPageProfileFeedViewModelDelegate,
         userRepository: UserRepository,
         profileId: Int) {
        
        self.profileLibraryViewModel = profileLibraryViewModel
        self.profileFeedViewModel = profileFeedViewModel
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
        let scrollOffset: Driver<CGPoint>
        
        let settingButtonDidTap: ControlEvent<Void>
        let dropdownButtonDidTap: Observable<String>
        let editButtonDidTap: ControlEvent<Void>
        let backButtonDidTap: ControlEvent<Void>
        let editProfileNotification: Observable<Notification>
        
        //LibraryViewModel
        let resizeKeywordCollectionViewHeight: Observable<CGSize?>
        let genrePreferenceButtonDidTap: Observable<Bool>
        let libraryButtonDidTap: Observable<Bool>
        let feedButtonDidTap: Observable<Bool>
        let inventoryViewDidTap: Observable<UITapGestureRecognizer>
        let inventorySpecificPageViewDidTap: Observable<Int>
        
        //FeedViewModel
        let resizefeedTableViewHeight: Observable<CGSize?>
        let feedDetailButtonDidTap: ControlEvent<Void>
        let feedTableViewItemSelected: Observable<IndexPath>
        let feedConnectedNovelViewDidTap: Observable<Int>
    }
    
    struct Output {
        let isMyPage: BehaviorRelay<Bool>
        let isProfilePrivate: BehaviorRelay<(Bool, String)>
        let profileData: BehaviorRelay<MyProfileEntity>
        let updateNavigationBar: BehaviorRelay<(Bool, String)>
        let updateStickyHeader: BehaviorRelay<(Bool)>
        
        let pushToEditViewController: PublishRelay<MyProfileEntity>
        let pushToSettingViewController: PublishRelay<Void>
        let popViewController: PublishRelay<Void>
        let pushToLibraryViewController: PublishRelay<Int>
        
        let showToastView: PublishRelay<Void>
        let stickyHeaderAction: BehaviorRelay<Bool>
        let updateButtonWithLibraryView: BehaviorRelay<Bool>
        
        //LibraryViewModel
        let bindAttractivePointsData: BehaviorRelay<[String]>
        let bindKeywordCell: BehaviorRelay<[KeywordResponse]>
        let updateKeywordCollectionViewHeight: PublishRelay<CGFloat>
        let bindGenreData: BehaviorRelay<UserGenrePreferences>
        let bindInventoryData: BehaviorRelay<UserNovelStatus>
        let showGenreOtherView: BehaviorRelay<Bool>
        let isExistPreferneces: PublishRelay<Bool>
        let pushToSpecificLibraryViewController: PublishSubject<(Int, Int)>
        
        //FeedViewModel
        let bindFeedData: BehaviorRelay<[MyFeedListItem]>
        let updateFeedTableViewHeight: PublishRelay<CGFloat>
        let isEmptyFeed: PublishRelay<Bool>
        let showFeedDetailButton: BehaviorSubject<Bool>
        let pushToMyPageFeedDetailViewController: Observable<(Int, ProfileFeedData)>
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
        Observable.merge(input.viewWillAppearEvent, reloadSubject)
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self else { return .empty() }
                return self.updateHeaderView(isMyPage: self.isMyPageRelay.value)
            }
            .flatMapLatest { [weak self]  _ -> Observable<Void> in
                guard let self else { return .empty() }
                guard !self.isProfilePrivateRelay.value.0 else { return .empty() }
                self.viewWillAppearForChildViewModel.onNext(())
                if self.profileId == 0 {
                    self.profileId =  UserDefaults.standard.integer(forKey: StringLiterals.UserDefault.userId)
                    reloadSubject.onNext(())
                }
                return .just(())
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
        
        //토스트뷰를 위한 분기처리
        input.editProfileNotification
            .bind(with: self, onNext: { owner, _ in
                self.showToastViewRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        //LibraryViewModel
        profileLibraryViewModel.bindProfileId(profileId: profileId)
        let profileLibraryInput = MyPageProfileLibraryViewModel.Input(
            viewWillAppearEvent: viewWillAppearForChildViewModel,
            resizeKeywordCollectionViewHeight: input.resizeKeywordCollectionViewHeight,
            genrePreferenceButtonDidTap: input.genrePreferenceButtonDidTap,
            inventoryViewDidTap: input.inventoryViewDidTap,
            inventorySpecificPageViewDidTap: input.inventorySpecificPageViewDidTap)
        let profileLibraryOutput = profileLibraryViewModel.transform(from: profileLibraryInput, disposeBag: disposeBag)
        
        //FeedViewModel
        profileDataRelay
            .map { profileData in
                ProfileFeedData(nickname: profileData.nickname, avatarImage: profileData.avatarImage)
            }
            .bind(to: profileFeedData)
            .disposed(by: disposeBag)
        profileFeedViewModel.bindProfileId(profileId: profileId)
        let profileFeedInput = MyPageProfileFeedViewModel.Input(
            profileData: profileFeedData.asObservable(),
            viewWillAppearEvent: viewWillAppearForChildViewModel,
            resizefeedTableViewHeight: input.resizefeedTableViewHeight,
            feedDetailButtonDidTap: input.feedDetailButtonDidTap,
            feedTableViewItemSelected: input.feedTableViewItemSelected,
            feedConnectedNovelViewDidTap: input.feedConnectedNovelViewDidTap
        )
        let profileFeedOutput = profileFeedViewModel.transform(from: profileFeedInput, disposeBag: disposeBag)
        
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
            showToastView: self.showToastViewRelay,
            stickyHeaderAction: self.stickyHeaderActionRelay,
            updateButtonWithLibraryView: self.updateButtonWithLibraryViewRelay,
            
            //LibraryViewModel
            bindAttractivePointsData: profileLibraryOutput.bindAttractivePointsData,
            bindKeywordCell: profileLibraryOutput.bindKeywordCell,
            updateKeywordCollectionViewHeight: profileLibraryOutput.updateKeywordCollectionViewHeight,
            bindGenreData: profileLibraryOutput.bindGenreData,
            bindInventoryData: profileLibraryOutput.bindInventoryData,
            showGenreOtherView: profileLibraryOutput.showGenreOtherView,
            isExistPreferneces: profileLibraryOutput.isExistPreferneces,
            pushToSpecificLibraryViewController: profileLibraryOutput.pushToSpecificLibraryViewController,
            
            //FeedViewModel
            bindFeedData: profileFeedOutput.bindFeedData,
            updateFeedTableViewHeight: profileFeedOutput.updateFeedTableViewHeight,
            isEmptyFeed: profileFeedOutput.isEmptyFeed,
            showFeedDetailButton: profileFeedOutput.showFeedDetailButton,
            pushToMyPageFeedDetailViewController: profileFeedOutput.pushToMyPageFeedDetailViewController,
            pushToFeedDetailViewController: profileFeedOutput.pushToFeedDetailViewController,
            pushToNovelDetailViewController: profileFeedOutput.pushToNovelDetailViewController
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
                    let data = MyProfileEntity(
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
                    
                    //현재 로직상 알 수 없는 유저 프로필을 확인하는 것은 불가능하지만
                    //서버에러에 대응하여 아래처럼 처리
                    if self.isUnknownUserError(error) {
                        let data = MyProfileEntity(
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
    
    // MARK: - API
    
    private func getProfileData() -> Observable<MyProfileEntity> {
        return userRepository.userInfoRepository.getMyProfileData()
            .observe(on: MainScheduler.instance)
    }
    
    private func getOtherProfileData(userId: Int) -> Observable<OtherProfileEntity> {
        return userRepository.userInfoRepository.getOtherProfile(userId: userId)
    }

    private func postBlockUser(userId: Int) -> Observable<Void> {
        return userRepository.userBlockRepository.postBlockUser(userId: userId)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
    }
}
