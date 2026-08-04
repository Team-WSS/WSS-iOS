//
//  HomePrefetchService.swift
//  WSSiOS
//
//  Created by Claude on 8/4/26.
//

import Foundation

import RxSwift

// 스플래시가 떠 있는 동안(로그인 여부 체크 등으로 어차피 대기하는 시간) 홈 상단 콘텐츠를
// 미리 요청해두어, 홈 화면 진입 시 로딩 스피너 노출 빈도를 줄인다.
// 앱 콜드 스타트 직후 첫 홈 진입에서만 소비되며, 소비되는 즉시 초기화되어
// 이후 홈 재진입(탭 전환 등)은 항상 새로 요청한다.
final class HomePrefetchService {
    static let shared = HomePrefetchService()
    private init() {}

    private let disposeBag = DisposeBag()
    private var todayPopular: Observable<TodayDiscoveryNovels>?
    private var realtimeFeeds: Observable<RealtimePopularFeeds>?

    func prefetchTopSections() {
        let repository = DefaultRecommendRepository(recommendService: DefaultRecommendService())

        // scope는 반드시 .forever여야 한다: .whileConnected는 최초 구독(prime)이 완료되어
        // 구독자 수가 0으로 떨어지는 순간 리플레이 버퍼를 버리고, 이후 소비 시점에 재구독하며
        // 네트워크 요청을 한 번 더 발생시킨다(프리페치 무력화).
        let today = repository.getTodayPopularNovels()
            .share(replay: 1, scope: .forever)
        let realtime = repository.getRealtimePopularFeeds()
            .share(replay: 1, scope: .forever)

        todayPopular = today
        realtimeFeeds = realtime

        today.subscribe().disposed(by: disposeBag)
        realtime.subscribe().disposed(by: disposeBag)
    }

    func consumeTodayPopular() -> Observable<TodayDiscoveryNovels>? {
        defer { todayPopular = nil }
        return todayPopular
    }

    func consumeRealtimeFeeds() -> Observable<RealtimePopularFeeds>? {
        defer { realtimeFeeds = nil }
        return realtimeFeeds
    }
}
