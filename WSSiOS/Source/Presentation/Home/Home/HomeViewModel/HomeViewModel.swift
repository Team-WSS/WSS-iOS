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
    private let userRepository: UserInfoRepository
    private let notificationRepository: NotificationRepository
    private let disposeBag = DisposeBag()

    private let isLogined = APIConstants.isLogined

    private let pushToNormalSearchViewController = PublishRelay<Void>()

    // 오늘의 인기작
    private let todayPopularList = BehaviorRelay<[TodayDiscoveryNovel]>(value: [])

    // 지금 뜨는 수다글
    private let realtimePopularList = PublishSubject<[RealtimePopularFeed]>()
    private let realtimePopularDataRelay = BehaviorRelay<[[RealtimePopularFeed]]>(value: [])
    private let updateRealtimePopularView = PublishRelay<(Bool, String?)>()

    // 취향추천
    private let tasteRecommendList = BehaviorRelay<[TasteRecommendNovel]>(value: [])
    private let updateTasteRecommendView = PublishRelay<(Bool, Bool)>()
    private let showTasteRecommendLoading = PublishRelay<Bool>()
    private let pushToMyPageViewController = PublishRelay<Void>()

    private let pushToNovelDetailViewController = PublishRelay<Int>()
    private let pushToAnnouncementViewController = PublishRelay<Void>()
    private let pushToDetailSearchViewController = PublishRelay<Void>()
    let showInduceLoginModalView = PublishRelay<Void>()

    private let showLoadingView = PublishRelay<Bool>()
    private let showUpdateVersionAlertView = PublishRelay<Void>()
    private let isNotificationUnread = PublishRelay<Bool>()
    private let showServiceTermAgreementAlert = PublishRelay<Void>()

    // MARK: - Inputs

    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let viewDidLoadEvent: Observable<Void>
        let todayPopularCellSelected: ControlEvent<IndexPath>
        let tasteRecommendCellSelected: ControlEvent<IndexPath>
        let tasteRecommendCollectionViewContentSize: Observable<CGSize?>
        let announcementButtonDidTap: ControlEvent<Void>
        let setPreferredGenresButtonTapped: ControlEvent<Void>
        let searchBarViewDidTap: Observable<UITapGestureRecognizer>
        let induceDetailSearchViewDidTap: Observable<UITapGestureRecognizer>
    }

    //MARK: - Outputs

    struct Output {
        let pushToNormalSearchViewController: Observable<Void>

        var todayPopularList: Observable<[TodayDiscoveryNovel]>

        var realtimePopularList: Observable<[RealtimePopularFeed]>
        var realtimePopularData: Observable<[[RealtimePopularFeed]]>
        let updateRealtimePopularView: Observable<(Bool, String?)>

        var tasteRecommendList: Observable<[TasteRecommendNovel]>
        let tasteRecommendCollectionViewHeight: Driver<CGFloat>
        let updateTasteRecommendView: Observable<(Bool, Bool)>
        let showTasteRecommendLoading: Observable<Bool>
        let pushToMyPageEditViewController: Observable<Void>

        let pushToNovelDetailViewController: Observable<Int>
        let pushToAnnouncementViewController: Observable<Void>
        let pushToDetailSearchViewController: Observable<Void>
        let showInduceLoginModalView: Observable<Void>
        let showLoadingView: Observable<Bool>
        let showUpdateVersionAlertView: Observable<Void>
        let isNotificationUnread: Observable<Bool>
        let showServiceTermAgreementAlert: Observable<Void>
    }

    //MARK: - init

    init(recommendRepository: RecommendRepository,
         userRepository: UserInfoRepository,
         notificationRepository: NotificationRepository) {
        self.recommendRepository = recommendRepository
        self.userRepository = userRepository
        self.notificationRepository = notificationRepository
    }
}

extension HomeViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        // 오늘의 인기작 / 지금 뜨는 수다글: 비로그인 사용자에게도 항상 노출되는 상단 콘텐츠.
        // 이 둘만 zip으로 묶어 로딩 스피너를 제어하므로, 취향추천이 느려도(개인화 연산,
        // 토큰 재발급 등) 상단 화면 표시가 지연되지 않는다.
        input.viewWillAppearEvent
            .do(onNext: {
                self.showLoadingView.accept(true)
            })
            .flatMapLatest {
                let todayPopularNovelsObservable = self.getTodayPopularNovels()
                    .catch { error in
                        print("❌ TodayPopular fetch failed: \(error)")
                        return Observable.just(TodayDiscoveryNovels(popularNovels: []))
                    }
                let realtimeFeedsObservable = self.getRealtimePopularFeeds()
                    .catch { error in
                        print("❌ RealtimePopularFeeds fetch failed: \(error)")
                        return Observable.just(RealtimePopularFeeds(popularFeeds: []))
                    }

                return Observable.zip(todayPopularNovelsObservable, realtimeFeedsObservable)
            }
            .subscribe(with: self, onNext: { owner, data in
                let todayPopularNovels = data.0
                let realtimeFeeds = data.1

                owner.todayPopularList.accept(todayPopularNovels.popularNovels)

                owner.realtimePopularList.onNext(realtimeFeeds.popularFeeds)
                let limitedFeeds = Array(realtimeFeeds.popularFeeds.prefix(6))
                let groupedData = stride(from: 0, to: limitedFeeds.count, by: 2)
                    .map { index in
                        Array(limitedFeeds[index..<min(index + 2, limitedFeeds.count)])
                    }
                owner.realtimePopularDataRelay.accept(groupedData)

                owner.showLoadingView.accept(false)
            }, onError: { owner, error in
                print("❌ Home data fetch failed: \(error)")
                owner.showLoadingView.accept(false)
            })
            .disposed(by: disposeBag)

        // 취향추천: 로그인 사용자 대상 개인화 콘텐츠(화면 하단 섹션)라 독립적으로 구독해,
        // 도착하는 대로 해당 섹션만 갱신하고 위 두 섹션의 표시를 막지 않는다.
        // 응답이 오래 걸리므로(개인화 연산) 항상 스켈레톤을 보여주고, 최신 응답이 오면 그때 채운다.
        input.viewWillAppearEvent
            .flatMapLatest { () -> Observable<TasteRecommendNovels> in
                guard self.isLogined else {
                    return Observable.just(TasteRecommendNovels(tasteNovels: []))
                }
                self.showTasteRecommendLoading.accept(true)
                return self.getTasteRecommendNovels()
                    .catch { error in
                        print("❌ TasteRecommend fetch failed: \(error)")
                        return Observable.just(TasteRecommendNovels(tasteNovels: []))
                    }
            }
            .subscribe(with: self, onNext: { owner, tasteRecommendNovels in
                owner.showTasteRecommendLoading.accept(false)
                if owner.isLogined {
                    owner.tasteRecommendList.accept(tasteRecommendNovels.tasteNovels)
                    owner.updateTasteRecommendView.accept((true, tasteRecommendNovels.tasteNovels.isEmpty))
                } else {
                    owner.updateTasteRecommendView.accept((false, true))
                }
            })
            .disposed(by: disposeBag)

        // 알림 미확인 여부는 핵심 콘텐츠 로딩과 무관하므로 별도로 조회해
        // 응답이 느려도 홈 화면 전체 로딩을 지연시키지 않도록 분리
        input.viewWillAppearEvent
            .flatMapLatest { () -> Observable<NotificationUnreadStatusResponse> in
                guard self.isLogined else {
                    return Observable.just(NotificationUnreadStatusResponse(hasUnreadNotifications: false))
                }
                return self.getNotificationUnreadStatus()
                    .catch { error in
                        print("❌ NotificationUnreadStatus fetch failed: \(error)")
                        return Observable.just(NotificationUnreadStatusResponse(hasUnreadNotifications: false))
                    }
            }
            .subscribe(with: self, onNext: { owner, response in
                owner.isNotificationUnread.accept(response.hasUnreadNotifications)
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
            .flatMapLatest { () -> Observable<UserMeEntity?> in
                self.isLogined ? self.getUserMeData().map { $0 } : Observable.just(nil)
            }
            .subscribe(with: self, onNext: { owner, data in
                if let data = data {
                    UserDefaults.standard.setValue(data.userId, forKey: StringLiterals.UserDefault.userId)
                    UserDefaults.standard.setValue(data.nickname, forKey: StringLiterals.UserDefault.userNickname)
                    UserDefaults.standard.setValue(data.gender, forKey: StringLiterals.UserDefault.userGender)
                    owner.getTermSetting(disposeBag: disposeBag)
                }
                owner.updateRealtimePopularView.accept((owner.isLogined, data?.nickname))
            })
            .disposed(by: disposeBag)

        input.searchBarViewDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.pushToNormalSearchViewController.accept(())
            })
            .disposed(by: disposeBag)

        input.induceDetailSearchViewDidTap
            .subscribe(with: self, onNext: { owner, _ in
                if owner.isLogined {
                    owner.pushToDetailSearchViewController.accept(())
                } else {
                    owner.showInduceLoginModalView.accept(())
                }
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

        return Output(pushToNormalSearchViewController: pushToNormalSearchViewController.asObservable(),
                      todayPopularList: todayPopularList.asObservable(),
                      realtimePopularList: realtimePopularList.asObservable(),
                      realtimePopularData: realtimePopularDataRelay.asObservable(),
                      updateRealtimePopularView: updateRealtimePopularView.asObservable(),
                      tasteRecommendList: tasteRecommendList.asObservable(),
                      tasteRecommendCollectionViewHeight: tasteRecommendCollectionViewHeight.asDriver(),
                      updateTasteRecommendView: updateTasteRecommendView.asObservable(),
                      showTasteRecommendLoading: showTasteRecommendLoading.asObservable(),
                      pushToMyPageEditViewController: pushToMyPageViewController.asObservable(),
                      pushToNovelDetailViewController: pushToNovelDetailViewController.asObservable(),
                      pushToAnnouncementViewController: pushToAnnouncementViewController.asObservable(),
                      pushToDetailSearchViewController: pushToDetailSearchViewController.asObservable(),
                      showInduceLoginModalView: showInduceLoginModalView.asObservable(),
                      showLoadingView: showLoadingView.asObservable(),
                      showUpdateVersionAlertView: showUpdateVersionAlertView.asObservable(),
                      isNotificationUnread: isNotificationUnread.asObservable(),
                      showServiceTermAgreementAlert: showServiceTermAgreementAlert.asObservable())
    }

    //MARK: - API

    // 유저 정보 조회
    func getUserMeData() -> Observable<UserMeEntity> {
        return userRepository.getUserMeData()
    }

    // 오늘의 인기작 조회 (스플래시 단계에서 프리페치된 결과가 있으면 그것을 우선 사용)
    func getTodayPopularNovels() -> Observable<TodayDiscoveryNovels> {
        return HomePrefetchService.shared.consumeTodayPopular() ?? recommendRepository.getTodayPopularNovels()
    }

    // 지금 뜨는 수다글 조회 (스플래시 단계에서 프리페치된 결과가 있으면 그것을 우선 사용)
    func getRealtimePopularFeeds() -> Observable<RealtimePopularFeeds> {
        return HomePrefetchService.shared.consumeRealtimeFeeds() ?? recommendRepository.getRealtimePopularFeeds()
    }

    // 관심글 조회 - Deprecated
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

    //유저 비열람 알림 존재 여부 조회
    func getNotificationUnreadStatus() -> Observable<NotificationUnreadStatusResponse> {
        return notificationRepository.getNotificationUnreadStatus()
    }

    func getTermSetting(disposeBag: DisposeBag) {
        userRepository.getTermSetting()
            .subscribe(with: self, onSuccess: { owner, result in
                if !result.isAllRequiredTermsAgreed {
                    owner.showServiceTermAgreementAlert.accept(())
                } else {
                    print("약관동의 완료됨!")
                }
            }, onFailure: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}
