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
    private let userInfoRepository: UserInfoRepository
    private let profileHeaderViewModel: MyPageProfileHeaderViewModelDelegate
    private let profileLibraryViewModel: MyPageProfileLibraryViewModelDelegate
    private let profileFeedViewModel: MyPageProfileFeedViewModelDelegate
    private let disposeBag = DisposeBag()
    
    private let isMyPage = BehaviorRelay<Bool>(value: true)
    private let isProfilePrivate = BehaviorRelay<(Bool)>(value: false)
    private let isProfilePrivateData = PublishSubject<(Bool, String)>()
    private let profileData = BehaviorRelay<MyProfileEntity>(value: MyProfileEntity(nickname: "",
                                                                                    intro: "",
                                                                                    avatarImage: "",
                                                                                    genrePreferences: []))
    private let profileFeedData = BehaviorRelay<ProfileFeedData>(value: ProfileFeedData(nickname: "",
                                                                                        avatarImage: ""))
    private let showToastView = PublishRelay<Void>()
    private let viewWillAppearForChildViewModel = PublishSubject<Void>()
    private let reloadSubject = PublishSubject<Void>()
    
    // MARK: - Life Cycle
    
    init(profileId: Int,
         userInfoRepository: UserInfoRepository,
         profileHeaderViewModel: MyPageProfileHeaderViewModelDelegate,
         profileLibraryViewModel: MyPageProfileLibraryViewModelDelegate,
         profileFeedViewModel: MyPageProfileFeedViewModelDelegate) {
        
        self.profileHeaderViewModel = profileHeaderViewModel
        self.profileLibraryViewModel = profileLibraryViewModel
        self.profileFeedViewModel = profileFeedViewModel
        self.userInfoRepository = userInfoRepository
        
        let userId = UserDefaults.standard.integer(forKey: StringLiterals.UserDefault.userId)
        self.profileId = profileId == 0 ? userId : profileId
    }
    
    struct Input {
        
        //MyPageViewModel
        let isEntryTabbar: Observable<Bool>
        let viewWillAppearEvent: PublishSubject<Void>
        let editProfileNotification: Observable<Notification>
        
        //HeaderViewModel
        let headerViewHeight: Driver<Double>
        let scrollOffset: Driver<CGPoint>
        let libraryButtonDidTap: Observable<Bool>
        let feedButtonDidTap: Observable<Bool>
        let settingButtonDidTap: ControlEvent<Void>
        let dropdownButtonDidTap: Observable<String>
        let editButtonDidTap: ControlEvent<Void>
        let backButtonDidTap: ControlEvent<Void>
        
        //LibraryViewModel
        let resizeKeywordCollectionViewHeight: Observable<CGSize?>
        let genrePreferenceButtonDidTap: Observable<Bool>
        let inventoryViewDidTap: Observable<UITapGestureRecognizer>
        let inventorySpecificPageViewDidTap: Observable<Int>
        
        //FeedViewModel
        let resizefeedTableViewHeight: Observable<CGSize?>
        let feedDetailButtonDidTap: ControlEvent<Void>
        let feedTableViewItemSelected: Observable<IndexPath>
    }
    
    struct Output {
        
        //MyPageViewModel
        let isMyPage: BehaviorRelay<Bool>
        let isProfilePrivate: PublishSubject<(Bool, String)>
        let profileData: BehaviorRelay<MyProfileEntity>
        let showToastView: PublishRelay<Void>
        
        //HeaderViewModel
        let updateNavigationBar: BehaviorRelay<(Bool, String)>
        let updateStickyHeader: BehaviorRelay<(Bool)>
        let pushToEditViewController: PublishRelay<MyProfileEntity>
        let pushToSettingViewController: PublishRelay<Void>
        let popViewController: PublishRelay<Void>
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
        let pushToLibraryViewController: PublishSubject<Int>
        let pushToSpecificLibraryViewController: PublishSubject<(Int, Int)>
        
        //FeedViewModel
        let bindFeedData: BehaviorRelay<[MyFeedListItem]>
        let updateFeedTableViewHeight: PublishRelay<CGFloat>
        let isEmptyFeed: PublishRelay<Bool>
        let showFeedDetailButton: BehaviorSubject<Bool>
        let pushToMyPageFeedDetailViewController: Observable<(Int, ProfileFeedData)>
        let pushToFeedDetailViewController: Observable<Int>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        // 진입 경로 분기처리: 탭바로 진입할 때만 마이페이지
        input.isEntryTabbar
            .subscribe(with: self, onNext: { owner, isMyPage in
                owner.isMyPage.accept(isMyPage)
            })
            .disposed(by: disposeBag)
        
        //본인/타인 프로필 분기처리 후 업데이트
        Observable.merge(input.viewWillAppearEvent, reloadSubject)
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self else { return .empty() }
                return self.updateHeaderView(isMyPage: self.isMyPage.value)
            }
            .flatMapLatest { [weak self]  _ -> Observable<Void> in
                guard let self else { return .empty() }
                
                //공개 계정일 때만 viewWillAppear시 업데이트
                guard !self.isProfilePrivate.value else { return .empty() }
                self.viewWillAppearForChildViewModel.onNext(())
                if self.profileId == 0 {
                    self.profileId =  UserDefaults.standard.integer(forKey: StringLiterals.UserDefault.userId)
                    reloadSubject.onNext(())
                }
                return .just(())
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        input.editProfileNotification
            .bind(with: self, onNext: { owner, _ in
                self.showToastView.accept(())
            })
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(isProfilePrivate.asObservable(), profileData.map { $0.nickname })
            .subscribe(onNext: { [weak self] isPrivate, nickname in
                self?.isProfilePrivateData.onNext((isPrivate, nickname))
            })
            .disposed(by: disposeBag)
        
        //HeaderViewModel
        let profileHeaderInput = MyPageProfileHeaderViewModel.Input(
            profileData: profileData.asObservable(),
            isProfilePrivate: isProfilePrivate.asObservable(),
            isMyPage: isMyPage.asObservable(),
            headerViewHeight: input.headerViewHeight,
            scrollOffset: input.scrollOffset,
            libraryButtonDidTap: input.libraryButtonDidTap,
            feedButtonDidTap: input.feedButtonDidTap,
            settingButtonDidTap: input.settingButtonDidTap,
            dropdownButtonDidTap: input.dropdownButtonDidTap,
            editButtonDidTap: input.editButtonDidTap,
            backButtonDidTap: input.backButtonDidTap)
        let profileHeaderOutput = profileHeaderViewModel.transform(from: profileHeaderInput, disposeBag: disposeBag)
        
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
        profileData
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
            feedTableViewItemSelected: input.feedTableViewItemSelected)
        let profileFeedOutput = profileFeedViewModel.transform(from: profileFeedInput, disposeBag: disposeBag)
        
        return Output(
            
            //MyPageViewModel
            isMyPage: self.isMyPage,
            isProfilePrivate: isProfilePrivateData,
            profileData: self.profileData,
            showToastView: self.showToastView,
            
            //HeaderViewModel
            updateNavigationBar: profileHeaderOutput.updateNavigationBar,
            updateStickyHeader: profileHeaderOutput.updateStickyHeader,
            pushToEditViewController: profileHeaderOutput.pushToEditViewController,
            pushToSettingViewController: profileHeaderOutput.pushToSettingViewController,
            popViewController: profileHeaderOutput.popViewController,
            stickyHeaderAction: profileHeaderOutput.stickyHeaderAction,
            updateButtonWithLibraryView: profileHeaderOutput.updateButtonWithLibraryView,
            
            //LibraryViewModel
            bindAttractivePointsData: profileLibraryOutput.bindAttractivePointsData,
            bindKeywordCell: profileLibraryOutput.bindKeywordCell,
            updateKeywordCollectionViewHeight: profileLibraryOutput.updateKeywordCollectionViewHeight,
            bindGenreData: profileLibraryOutput.bindGenreData,
            bindInventoryData: profileLibraryOutput.bindInventoryData,
            showGenreOtherView: profileLibraryOutput.showGenreOtherView,
            isExistPreferneces: profileLibraryOutput.isExistPreferneces,
            pushToLibraryViewController: profileLibraryOutput.pushToLibraryViewController,
            pushToSpecificLibraryViewController: profileLibraryOutput.pushToSpecificLibraryViewController,
            
            //FeedViewModel
            bindFeedData: profileFeedOutput.bindFeedData,
            updateFeedTableViewHeight: profileFeedOutput.updateFeedTableViewHeight,
            isEmptyFeed: profileFeedOutput.isEmptyFeed,
            showFeedDetailButton: profileFeedOutput.showFeedDetailButton,
            pushToMyPageFeedDetailViewController: profileFeedOutput.pushToMyPageFeedDetailViewController,
            pushToFeedDetailViewController: profileFeedOutput.pushToFeedDetailViewController
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
    
    //타인프로필일 때만 private 상태 분기처리
    //에러일 때 알 수 없음 프로필로 처리
    private func updateHeaderView(isMyPage: Bool) -> Observable<Void> {
        if isMyPage {
            return self.getProfileData()
                .do(onNext: { profileData in
                    self.profileData.accept(profileData)
                    self.isProfilePrivate.accept(false)
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
                    self.profileData.accept(data)
                    self.isProfilePrivate.accept(!profileData.isProfilePublic)
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
                        self.profileData.accept(data)
                        self.isProfilePrivate.accept(false)
                    }
                    return .empty()
                }
        }
    }
    
    // MARK: - API
    
    private func getProfileData() -> Observable<MyProfileEntity> {
        return userInfoRepository.getMyProfileData()
            .observe(on: MainScheduler.instance)
    }
    
    private func getOtherProfileData(userId: Int) -> Observable<OtherProfileEntity> {
        return userInfoRepository.getOtherProfile(userId: userId)
    }
}
