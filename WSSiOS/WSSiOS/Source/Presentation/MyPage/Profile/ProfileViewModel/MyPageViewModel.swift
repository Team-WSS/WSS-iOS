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
    private let profileDataRelay = BehaviorRelay<MyProfileEntity>(value: MyProfileEntity(nickname: "",
                                                                                         introdution: "",
                                                                                         genrePreferences: [],
                                                                                         avatarImageURL: nil))
                                                                  
    private let isExistPrefernecesRelay = PublishRelay<Bool>()
    private let bindInventoryDataRelay = BehaviorRelay<UserNovelStatusEntity>(value: UserNovelStatusEntity(interestNovelCount: 0,
                                                                                                           watchingNovelCount: 0,
                                                                                                           watchedNovelCount: 0,
                                                                                                           quitNovelCount: 0))
    let bindKeywordRelay = BehaviorRelay<[KeywordEntity]>(value: [])
    private let bindAttractivePointsDataRelay = BehaviorRelay<[String]>(value: [])
    private let bindGenreDataRelay = BehaviorRelay<UserGenrePreferencesListEntity>(value: UserGenrePreferencesListEntity(genrePreferences: []))
    private let showGenreOtherViewRelay = BehaviorRelay<Bool>(value: false)
    
    private let updateKeywordCollectionViewHeightRelay = PublishRelay<CGFloat>()
    
    private let pushToEditViewControllerRelay = PublishRelay<MyProfileEntity>()
    private let pushToSettingViewControllerRelay = PublishRelay<Void>()
    private let pushToLibraryViewControllerRelay = PublishRelay<Int>()
    private let pushToSpecificLibraryViewController = PublishSubject<Int>()
    
    private let showToastViewRelay = PublishRelay<Void>()
    private let stickyHeaderActionRelay = BehaviorRelay<Bool>(value: true)
    
    private let reloadSubject = PublishSubject<Void>()
    
    // MARK: - Life Cycle
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        let userId = UserDefaults.standard.integer(forKey: StringLiterals.UserDefault.userId)
        self.profileId = userId
    }
    
    struct Input {
        let viewWillAppearEvent: PublishSubject<Void>
        
        let headerViewHeight: Driver<Double>
        let resizeKeywordCollectionViewHeight: Observable<CGSize?>
        let scrollOffset: Driver<CGPoint>
        let settingButtonDidTap: ControlEvent<Void>
        let editButtonDidTap: Observable<UITapGestureRecognizer>
        let genrePreferenceButtonDidTap: Observable<Bool>
        let inventoryViewDidTap: Observable<UITapGestureRecognizer>
        let inventorySpecificPageViewDidTap: Observable<Int>
        let editProfileNotification: Observable<Notification>
    }
    
    struct Output {
        let profileData: BehaviorRelay<MyProfileEntity>
        let updateNavigationBar: BehaviorRelay<(Bool, String)>
        
        let pushToEditViewController: PublishRelay<MyProfileEntity>
        let pushToSettingViewController: PublishRelay<Void>
        let pushToLibraryViewController: PublishRelay<Int>
        
        let bindAttractivePointsData: BehaviorRelay<[String]>
        let bindKeywordCell: BehaviorRelay<[KeywordEntity]>
        let updateKeywordCollectionViewHeight: PublishRelay<CGFloat>
        let bindGenreData: BehaviorRelay<UserGenrePreferencesListEntity>
        let bindInventoryData: BehaviorRelay<UserNovelStatusEntity>
        
        let showGenreOtherView: BehaviorRelay<Bool>
        let isExistPreferneces: PublishRelay<Bool>
        
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
        
        input.inventorySpecificPageViewDidTap
            .bind(with: self, onNext: { owner, pageIndex in
                self.pushToSpecificLibraryViewController.onNext(pageIndex)
            })
            .disposed(by: disposeBag)
        
        return Output(
            profileData: self.profileDataRelay,
            updateNavigationBar: self.updateNavigationRelay,
            
            pushToEditViewController: self.pushToEditViewControllerRelay,
            pushToSettingViewController: self.pushToSettingViewControllerRelay,
            pushToLibraryViewController: self.pushToLibraryViewControllerRelay,
            
            bindAttractivePointsData: self.bindAttractivePointsDataRelay,
            bindKeywordCell: self.bindKeywordRelay,
            updateKeywordCollectionViewHeight: self.updateKeywordCollectionViewHeightRelay,
            bindGenreData: self.bindGenreDataRelay,
            bindInventoryData: self.bindInventoryDataRelay,
            showGenreOtherView: self.showGenreOtherViewRelay,
            isExistPreferneces: self.isExistPrefernecesRelay,
            
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
                let keywords = preference.keywords
                if preference.attractivePoints == [] && keywords.isEmpty {
                    self.isExistPrefernecesRelay.accept(false)
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
