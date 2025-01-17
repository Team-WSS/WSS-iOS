//
//  HomeViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/10/24.
//

import UIKit

import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let recommendRepository: RecommendRepository
    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()
    
    private let isLogined = APIConstants.isLogined
    
    // 오늘의 인기작
    private let todayPopularList = BehaviorRelay<[TodayPopularNovel]>(value: [])
    
    // 지금 뜨는 수다글
    private let realtimePopularList = PublishSubject<[RealtimePopularFeed]>()
    private let realtimePopularDataRelay = BehaviorRelay<[[RealtimePopularFeed]]>(value: [])
    
    // 관심글
    private let interestList = BehaviorRelay<[InterestFeed]>(value: [])
    private let updateInterestView = PublishRelay<(Bool, InterestMessage)>()
    private let pushToNormalSearchViewController = PublishRelay<Void>()
    private var interestFeedMessage = BehaviorRelay<InterestMessage>(value: .none)
    
    // 취향추천
    private let tasteRecommendList = BehaviorRelay<[TasteRecommendNovel]>(value: [])
    private let updateTasteRecommendView = PublishRelay<(Bool, Bool)>()
    private let pushToMyPageViewController = PublishRelay<Void>()
    
    private let pushToNovelDetailViewController = PublishRelay<Int>()
    private let pushToAnnouncementViewController = PublishRelay<Void>()
    let showInduceLoginModalView = PublishRelay<Void>()
    
    private let showLoadingView = PublishRelay<Bool>()
    private let showUpdateVersionAlertView = PublishRelay<Void>()
    
    // MARK: - Inputs
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let viewDidLoadEvent: Observable<Void>
        let todayPopularCellSelected: ControlEvent<IndexPath>
        let interestCellSelected: ControlEvent<IndexPath>
        let tasteRecommendCellSelected: ControlEvent<IndexPath>
        let tasteRecommendCollectionViewContentSize: Observable<CGSize?>
        let announcementButtonDidTap: ControlEvent<Void>
        let registerInterestNovelButtonTapped: ControlEvent<Void>
        let setPreferredGenresButtonTapped: ControlEvent<Void>
    }
    
    //MARK: - Outputs
    
    struct Output {
        var todayPopularList: Observable<[TodayPopularNovel]>
        
        var realtimePopularList: Observable<[RealtimePopularFeed]>
        var realtimePopularData: Observable<[[RealtimePopularFeed]]>
        
        var interestList: Observable<[InterestFeed]>
        let updateInterestView: Observable<(Bool, InterestMessage)>
        let pushToNormalSearchViewController: Observable<Void>
        
        var tasteRecommendList: Observable<[TasteRecommendNovel]>
        let tasteRecommendCollectionViewHeight: Driver<CGFloat>
        let updateTasteRecommendView: Observable<(Bool, Bool)>
        let pushToMyPageEditViewController: Observable<Void>
        
        let pushToNovelDetailViewController: Observable<Int>
        let pushToAnnouncementViewController: Observable<Void>
        let showInduceLoginModalView: Observable<Void>
        let showLoadingView: Observable<Bool>
        let showUpdateVersionAlertView: Observable<Void>
    }
    
    //MARK: - init
    
    init(recommendRepository: RecommendRepository, userRepository: UserRepository) {
        self.recommendRepository = recommendRepository
        self.userRepository = userRepository
    }
}

extension HomeViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewWillAppearEvent
            .do(onNext: {
                self.showLoadingView.accept(true)
            })
            .flatMapLatest {
                let todayPopularNovelsObservable = self.getTodayPopularNovels()
                let realtimeFeedsObservable = self.getRealtimePopularFeeds()
                let interestFeedsObservable = self.isLogined ? self.getInterestFeeds() : Observable.just(InterestFeeds(recommendFeeds: [], message: ""))
                let tasteRecommendNovelsObservable = self.isLogined ? self.getTasteRecommendNovels() : Observable.just(TasteRecommendNovels(tasteNovels: []))
                
                return Observable.zip(todayPopularNovelsObservable,
                                      realtimeFeedsObservable,
                                      interestFeedsObservable,
                                      tasteRecommendNovelsObservable)
            }
            .subscribe(with: self, onNext: { owner, data in
                let todayPopularNovels = data.0
                let realtimeFeeds = data.1
                let interestFeeds = data.2
                let tasteRecommendNovels = data.3
                
                owner.todayPopularList.accept(todayPopularNovels.popularNovels)
                owner.realtimePopularList.onNext(realtimeFeeds.popularFeeds)
                let groupedData = stride(from: 0, to: realtimeFeeds.popularFeeds.count, by: 3)
                    .map { index in
                        Array(realtimeFeeds.popularFeeds[index..<min(index + 3, realtimeFeeds.popularFeeds.count)])
                    }
                owner.realtimePopularDataRelay.accept(groupedData)
                let message = InterestMessage(rawValue: interestFeeds.message)
                
                if owner.isLogined {
                    owner.interestList.accept(interestFeeds.recommendFeeds)
                    owner.updateInterestView.accept((true, message ?? .none))
                    owner.interestFeedMessage.accept(message ?? .none)
                    
                    owner.tasteRecommendList.accept(tasteRecommendNovels.tasteNovels)
                    owner.updateTasteRecommendView.accept((true, tasteRecommendNovels.tasteNovels.isEmpty))
                } else {
                    owner.updateInterestView.accept((false, message ?? .none))
                    owner.interestFeedMessage.accept(.none)
                    
                    owner.updateTasteRecommendView.accept((false, true))
                }
                
                owner.showLoadingView.accept(false)
            }, onError: { owner, error in
                owner.realtimePopularList.onError(error)
                owner.showLoadingView.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.viewWillAppearEvent
            .flatMapLatest { self.getAppMinimumVersion() }
            .subscribe(with: self, onNext: { owner, versionInfo in
                let currentVersion = StringLiterals.AppMinimumVersion.bundleVersion
                if currentVersion < versionInfo.minimumVersion {
                    owner.showUpdateVersionAlertView.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        input.viewDidLoadEvent
            .filter { self.isLogined }
            .flatMapLatest {
                return self.getUserMeData()
            }
            .subscribe(with: self, onNext: { owner, data in
                UserDefaults.standard.setValue(data.userId, forKey: StringLiterals.UserDefault.userId)
                UserDefaults.standard.setValue(data.nickname, forKey: StringLiterals.UserDefault.userNickname)
                UserDefaults.standard.setValue(data.gender, forKey: StringLiterals.UserDefault.userGender)
                
                owner.updateInterestView.accept((self.isLogined, self.interestFeedMessage.value))
            })
            .disposed(by: disposeBag)
        
        input.viewWillAppearEvent
            .filter { self.isLogined && UserDefaults.standard.integer(forKey: StringLiterals.UserDefault.userId) == 0}
            .flatMapLatest {
                return self.getUserMeData()
            }
            .subscribe(with: self, onNext: { owner, data in
                let existUserId = UserDefaults.standard.integer(forKey: StringLiterals.UserDefault.userId)
                print(existUserId, "🔫")
                
                UserDefaults.standard.setValue(data.userId, forKey: StringLiterals.UserDefault.userId)
                UserDefaults.standard.setValue(data.nickname, forKey: StringLiterals.UserDefault.userNickname)
                UserDefaults.standard.setValue(data.gender, forKey: StringLiterals.UserDefault.userGender)
            })
            .disposed(by: disposeBag)
        
        input.todayPopularCellSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                AmplitudeManager.shared.track(AmplitudeEvent.Home.homeTodayRanking)
                if owner.isLogined {
                    let novelId = owner.todayPopularList.value[indexPath.row].novelId
                    owner.pushToNovelDetailViewController.accept(novelId)
                } else {
                    owner.showInduceLoginModalView.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        input.interestCellSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                AmplitudeManager.shared.track(AmplitudeEvent.Home.homeLoveFeedlist)
                let novelId = owner.interestList.value[indexPath.row].novelId
                owner.pushToNovelDetailViewController.accept(novelId)
            })
            .disposed(by: disposeBag)
        
        input.tasteRecommendCellSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                AmplitudeManager.shared.track(AmplitudeEvent.Home.homePreferNovellist)
                let novelId = owner.tasteRecommendList.value[indexPath.row].novelId
                owner.pushToNovelDetailViewController.accept(novelId)
            })
            .disposed(by: disposeBag)
        
        let tasteRecommendCollectionViewHeight = input.tasteRecommendCollectionViewContentSize
            .map { $0?.height ?? 0 }
            .asDriver(onErrorJustReturn: 0)

        input.announcementButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                if owner.isLogined {
                    owner.pushToAnnouncementViewController.accept(())
                } else {
                    owner.showInduceLoginModalView.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        input.registerInterestNovelButtonTapped
            .subscribe(with: self, onNext: { owner, _ in
                AmplitudeManager.shared.track(AmplitudeEvent.Home.homeToLoveButton)
                if owner.isLogined {
                    owner.pushToNormalSearchViewController.accept(())
                } else {
                    owner.showInduceLoginModalView.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        input.setPreferredGenresButtonTapped
            .subscribe(with: self, onNext: { owner, _ in
                AmplitudeManager.shared.track(AmplitudeEvent.Home.homeToPreferButton)
                if owner.isLogined {
                    owner.pushToMyPageViewController.accept(())
                } else {
                    owner.showInduceLoginModalView.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        return Output(todayPopularList: todayPopularList.asObservable(),
                      realtimePopularList: realtimePopularList.asObservable(),
                      realtimePopularData: realtimePopularDataRelay.asObservable(),
                      interestList: interestList.asObservable(),
                      updateInterestView: updateInterestView.asObservable(),
                      pushToNormalSearchViewController: pushToNormalSearchViewController.asObservable(),
                      tasteRecommendList: tasteRecommendList.asObservable(),
                      tasteRecommendCollectionViewHeight: tasteRecommendCollectionViewHeight.asDriver(),
                      updateTasteRecommendView: updateTasteRecommendView.asObservable(),
                      pushToMyPageEditViewController: pushToMyPageViewController.asObservable(),
                      pushToNovelDetailViewController: pushToNovelDetailViewController.asObservable(),
                      pushToAnnouncementViewController: pushToAnnouncementViewController.asObservable(),
                      showInduceLoginModalView: showInduceLoginModalView.asObservable(),
                      showLoadingView: showLoadingView.asObservable(),
                      showUpdateVersionAlertView: showUpdateVersionAlertView.asObservable())
    }
    
    //MARK: - API
    
    // 유저 정보 조회
    func getUserMeData() -> Observable<UserMeResult> {
        return userRepository.getUserMeData()
    }
    
    // 오늘의 인기작 조회
    func getTodayPopularNovels() -> Observable<TodayPopularNovels> {
        return recommendRepository.getTodayPopularNovels()
    }
    
    // 지금 뜨는 수다글 조회
    func getRealtimePopularFeeds() -> Observable<RealtimePopularFeeds> {
        return recommendRepository.getRealtimePopularFeeds()
    }
    
    // 관심글 조회
    func getInterestFeeds() -> Observable<InterestFeeds> {
        return recommendRepository.getInterestFeeds()
    }
    
    // 취향추천 작품 조회
    func getTasteRecommendNovels() -> Observable<TasteRecommendNovels> {
        return recommendRepository.getTasteRecommendNovels()
    }
    
    // 앱 최소 버전 조회
    func getAppMinimumVersion() -> Observable<AppMinimumVersion> {
        return userRepository.getAppMinimumVersion()
    }
}
