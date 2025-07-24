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
    private let disposeBag = DisposeBag()

    private let updateNavigationRelay = BehaviorRelay<(Bool, String)>(value: (false, ""))
    private let profileDataRelay = BehaviorRelay<MyProfileEntity>(value: MyProfileEntity(nickname: "",
                                                                                         introdution: "",
                                                                                         genrePreferences: [],
                                                                                         avatarImageURL: nil))
                                                                  
    private let isPrefernecesEmptyRelay = PublishRelay<(Bool, Bool)>()
    private let bindLibraryStatusDataRelay = BehaviorRelay<UserNovelStatusEntity>(value: UserNovelStatusEntity(interestNovelCount: 0,
                                                                                                           watchingNovelCount: 0,
                                                                                                           watchedNovelCount: 0,
                                                                                                           quitNovelCount: 0))
    let bindKeywordRelay = BehaviorRelay<[KeywordEntity]>(value: [])
    private let bindAttractivePointsDataRelay = BehaviorRelay<[String]>(value: [])
    private let bindGenreDataRelay = BehaviorRelay<UserGenrePreferencesListEntity>(value: UserGenrePreferencesListEntity(genrePreferences: [], genreTotalCount: 0))
    private let bindNovelPreferencesDataRelay = BehaviorRelay<UserNovelPreferencesEntity>(value: UserNovelPreferencesEntity (attractivePoints: [], keywords: []))
    private let showGenreOtherViewRelay = BehaviorRelay<Bool>(value: false)
    
    private let updateKeywordCollectionViewHeightRelay = PublishRelay<CGFloat>()
    
    private let pushToEditViewControllerRelay = PublishRelay<MyProfileEntity>()
    private let pushToSettingViewControllerRelay = PublishRelay<Void>()
    private let pushToSpecificLibraryViewController = PublishSubject<Int>()
    
    private let showToastViewRelay = PublishRelay<Void>()
    private let reloadSubject = PublishSubject<Void>()
    
    // MARK: - Life Cycle
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        let userId = UserDefaults.standard.integer(forKey: StringLiterals.UserDefault.userId)
        self.profileId = userId
    }
    
    struct Input {
        let viewWillAppearEvent: PublishSubject<Void>
        let resizeKeywordCollectionViewHeight: Observable<CGSize?>
        let scrollOffset: Driver<CGPoint>
        let settingButtonDidTap: ControlEvent<Void>
        let editButtonDidTap: Observable<UITapGestureRecognizer>
        let genrePreferenceButtonDidTap: Observable<Bool>
        let libraryStatusSpecificPageViewDidTap: Observable<Int>
        let editProfileNotification: Observable<Notification>
    }
    
    struct Output {
        let profileData: BehaviorRelay<MyProfileEntity>
        let updateNavigationBar: BehaviorRelay<(Bool, String)>
        
        let pushToEditViewController: PublishRelay<MyProfileEntity>
        let pushToSettingViewController: PublishRelay<Void>
        
        let bindAttractivePointsData: BehaviorRelay<[String]>
        let bindKeywordCell: BehaviorRelay<[KeywordEntity]>
        let updateKeywordCollectionViewHeight: PublishRelay<CGFloat>
        let bindGenreData: BehaviorRelay<UserGenrePreferencesListEntity>
        let bindNovelPreferencesData: BehaviorRelay<UserNovelPreferencesEntity>
        let bindLibraryStatusData: BehaviorRelay<UserNovelStatusEntity>
        
        let showGenreOtherView: BehaviorRelay<Bool>
        let isPrefernecesEmpty: PublishRelay<(Bool, Bool)> //장르취향, 작품취향 순으로 체크함
        
        let showToastView: PublishRelay<Void>
        let pushToSpecificLibraryViewController: PublishSubject<Int>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        //서재 - 보관함 데이터 업데이트
        //서재 - 나머지뷰 업데이트 후 키워드컬렉션뷰 높이 업데이트
        Observable.merge(input.viewWillAppearEvent, reloadSubject)
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self else { return .empty() }
                return self.updateHeaderView()
            }
            .flatMapLatest { [weak self]  _ -> Observable<Void> in
                guard let self else { return .empty() }
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
                        .map { _ in Void() }
                ])
            }
            .subscribe()
            .disposed(by: disposeBag)
 
        input.scrollOffset
            .asObservable()
            .map{ $0.y }
            .subscribe(with: self, onNext: { owner, scrollHeight in
                let navigationText = StringLiterals.Navigation.Title.myPage
                owner.updateNavigationRelay.accept((scrollHeight > 0, navigationText))
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
            .map { _ in self.profileDataRelay.value }
            .bind(to: pushToEditViewControllerRelay)
            .disposed(by: disposeBag)
        
        //토스트뷰를 위한 분기처리
        input.editProfileNotification
            .bind(with: self, onNext: { owner, _ in
                self.showToastViewRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        input.libraryStatusSpecificPageViewDidTap
            .bind(with: self, onNext: { owner, pageIndex in
                self.pushToSpecificLibraryViewController.onNext(pageIndex)
            })
            .disposed(by: disposeBag)
        
        return Output(
            profileData: self.profileDataRelay,
            updateNavigationBar: self.updateNavigationRelay,
            
            pushToEditViewController: self.pushToEditViewControllerRelay,
            pushToSettingViewController: self.pushToSettingViewControllerRelay,
            bindAttractivePointsData: self.bindAttractivePointsDataRelay,
            bindKeywordCell: self.bindKeywordRelay,
            updateKeywordCollectionViewHeight: self.updateKeywordCollectionViewHeightRelay,
            bindGenreData: self.bindGenreDataRelay,
            bindNovelPreferencesData: self.bindNovelPreferencesDataRelay,
            bindLibraryStatusData: self.bindLibraryStatusDataRelay,
            
            showGenreOtherView: self.showGenreOtherViewRelay,
            isPrefernecesEmpty: self.isPrefernecesEmptyRelay,
            
            showToastView: self.showToastViewRelay,
            pushToSpecificLibraryViewController: pushToSpecificLibraryViewController
        )
    }
    
    // MARK: - Custom Method
    
    private func updateHeaderView() -> Observable<Void> {
        return self.getProfileData()
            .do(onNext: { profileData in
                self.profileDataRelay.accept(profileData)
            })
            .map { _ in }
    }
    
    //서재 데이터 바인딩
    //보관함-장르취향-작품취향 서버연결
    private func updateMyPageLibraryInventoryData() -> Observable<Void> {
        return getInventoryData(userId: self.profileId)
            .do(onNext: { [weak self] inventory in
                guard let self else { return }
                self.bindLibraryStatusDataRelay.accept(inventory)
            })
            .map { _ in Void() }
    }
    
    //취향분석 데이터 바인딩
    private func updateMyPageLibraryPreferenceData() -> Observable<Void> {
        let genrePreferences = getGenrePreferenceData(userId: self.profileId)
        let novelPreferences = getNovelPreferenceData(userId: self.profileId)
        
        return Observable.zip(genrePreferences, novelPreferences)
            .do(onNext: { [weak self] genre, novel in
                guard let self else { return }
                let isGenreEmpty = genre.genreTotalCount == 0
                let isNovelEmpty = novel.attractivePoints.isEmpty && novel.keywords.isEmpty
                self.isPrefernecesEmptyRelay.accept((isGenreEmpty, isNovelEmpty))
                
                //둘 다 비어있으면 더이상 작업X
                guard !(isGenreEmpty && isNovelEmpty) else { return }
                
                //장르, 작품 취향 개별 데이터 바인딩
                if !isGenreEmpty {
                    self.bindGenreDataRelay.accept(genre)
                }
                if !isNovelEmpty {
                    self.bindAttractivePointsDataRelay.accept(novel.attractivePoints)
                    self.bindKeywordRelay.accept(novel.keywords)
                }
            })
            .map { _ in Void() }
            .catch { [weak self] error in
                self?.isPrefernecesEmptyRelay.accept((true, true))
                return .just(Void())
            }
    }
    
    
    private func handleKeywordCollectionViewHeight(resizeKeywordCollectionViewHeight: Observable<CGSize?>) -> Observable<CGFloat> {
        return resizeKeywordCollectionViewHeight
            .map { $0?.height ?? 0 }
            .do(onNext: { [weak self] height in
                self?.updateKeywordCollectionViewHeightRelay.accept(height)
            })
    }
    
    // MARK: - API
    
    private func getProfileData() -> Observable<MyProfileEntity> {
        return userRepository.userInfoRepository.getMyProfileData()
            .observe(on: MainScheduler.instance)
    }
    
    private func getNovelPreferenceData(userId: Int) -> Observable<UserNovelPreferencesEntity> {
        return userRepository.userInfoRepository.getUserNovelPreferences(userId: userId)
    }
    
    private func getGenrePreferenceData(userId: Int) -> Observable<UserGenrePreferencesListEntity> {
        return userRepository.userInfoRepository.getUserGenrePreferences(userId: userId)
    }
    
    private func getInventoryData(userId: Int) -> Observable<UserNovelStatusEntity> {
        return userRepository.userInfoRepository.getUserNovelStatus(userId: userId)
    }
}
