//
//  RecommendRepository.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol RecommendRepository {
    func getTodayPopularNovels() -> Observable<TodayPopularNovels>
    func getRealtimePopularFeeds() -> Observable<RealtimePopularFeeds>
    func getInterestFeeds() -> Observable<InterestFeeds>
    func getTasteRecommendNovels() -> Observable<TasteRecommendNovels>
}

struct DefaultRecommendRepository: RecommendRepository {
    
    private let recommendService: RecommendService
    
    init(recommendService: RecommendService) {
        self.recommendService = recommendService
    }
    
    func getTodayPopularNovels() -> Observable<TodayPopularNovels> {
        return recommendService.getTodayPopularNovels().asObservable()
    }
    
    func getRealtimePopularFeeds() -> Observable<RealtimePopularFeeds> {
        return recommendService.getRealtimePopularFeeds().asObservable()
    }
    
    func getInterestFeeds() -> Observable<InterestFeeds> {
        return recommendService.getInterestFeeds().asObservable()
    }
    
    func getTasteRecommendNovels() -> Observable<TasteRecommendNovels> {
        return recommendService.getTasteRecommendNovels().asObservable()
    }
    
}

struct TestRecommendRepository: RecommendRepository {
    func getTodayPopularNovels() -> Observable<TodayPopularNovels> {
        return Observable.just(TodayPopularNovels(popularNovels: [
            TodayPopularNovel(novelId: 1,
                              title: "이상한 나라의 그레이스 GRACE IN WONDERLAND",
                              novelImage: "https://i.pinimg.com/564x/2a/a3/14/2aa3142a78d89235e520ecd516e60204.jpg",
                              avatarImage: "https://i.pinimg.com/736x/1a/7f/f5/1a7ff54970a79f4c3c9f93ec68bc6207.jpg",
                              nickname: "구리스",
                              feedContent: "상수리 나무 아래는 ㄹㅇ 아마 제 인생작이 될꺼 같네요. 소장본도 사려고요 근데 약간 여주가 답답한 스타일인데 그거를 살려버린다 우왕"),
            TodayPopularNovel(novelId: 1,
                              title: "폐하 황후는 이제 없습니다",
                              novelImage: "https://i.pinimg.com/564x/9b/68/87/9b68873692f1d288a4c1178c0827bb69.jpg",
                              avatarImage: "https://i.pinimg.com/474x/b3/17/f3/b317f39796d1974de83f01f4ffeb32c3.jpg",
                              nickname: "구리스",
                              feedContent: "상수리 나무 아래는 ㄹㅇ 아마 제 인생작이 될꺼 같네요. 소장본도 사려고요 근데 약간 여주가 답답한 스타일인데 그거를 살려버린다 우왕"),
            TodayPopularNovel(novelId: 1,
                              title: "상수리 나무 아래라구요오오오오오오오오오오오오오옷",
                              novelImage: "https://i.pinimg.com/736x/0c/22/6c/0c226cd8dfafb1f149502d3c19ccb177.jpg",
                              avatarImage: "https://i.pinimg.com/736x/1a/7f/f5/1a7ff54970a79f4c3c9f93ec68bc6207.jpg",
                              nickname: "구리스",
                              feedContent: "상수리 나무 아래는 ㄹㅇ 아마 제 인생작이 될꺼 같네요. 소장본도 사려고요 근데 약간 여주가 답답한 스타일인데 그거를 살려버린다 우왕"),
            TodayPopularNovel(novelId: 1,
                              title: "상수리 나무 아래라구요오오오오오오오오오오오오오옷",
                              novelImage: "https://i.pinimg.com/736x/a0/cf/3c/a0cf3ce55d4504b8d28e6468f1f490e5.jpg",
                              avatarImage: "https://i.pinimg.com/736x/1a/7f/f5/1a7ff54970a79f4c3c9f93ec68bc6207.jpg",
                              nickname: "구리스",
                              feedContent: "상수리 나무 아래는 ㄹㅇ 아마 제 인생작이 될꺼 같네요. 소장본도 사려고요 근데 약간 여주가 답답한 스타일인데 그거를 살려버린다 우왕"),
            TodayPopularNovel(novelId: 1,
                              title: "상수리 나무 아래라구요오오오오오오오오오오오오오옷",
                              novelImage: "https://i.pinimg.com/736x/57/fe/d9/57fed9b1a9000aedbe9c94f8b55d7001.jpg",
                              avatarImage: "https://i.pinimg.com/474x/b3/17/f3/b317f39796d1974de83f01f4ffeb32c3.jpg",
                              nickname: "구리스",
                              feedContent: "상수리 나무 아래는 ㄹㅇ 아마 제 인생작이 될꺼 같네요. 소장본도 사려고요 근데 약간 여주가 답답한 스타일인데 그거를 살려버린다 우왕"),
            TodayPopularNovel(novelId: 1,
                              title: "상수리 나무 아래라구요오오오오오오오오오오오오오옷",
                              novelImage: "https://i.pinimg.com/736x/b4/26/0b/b4260be5f96a8699ea92b2bad17728f2.jpg",
                              avatarImage: "https://i.pinimg.com/474x/b3/17/f3/b317f39796d1974de83f01f4ffeb32c3.jpg",
                              nickname: "구리스",
                              feedContent: "상수리 나무 아래는 ㄹㅇ 아마 제 인생작이 될꺼 같네요. 소장본도 사려고요 근데 약간 여주가 답답한 스타일인데 그거를 살려버린다 우왕")]))
    }
    
    func getRealtimePopularFeeds() -> Observable<RealtimePopularFeeds> {
        return Observable.just(RealtimePopularFeeds(popularFeeds: [
            RealtimePopularFeed(feedId: 1, feedContent: "주인공이 당연히 엘로디인 줄 알았는데.... 표지에 두명이 나온 이유가 있구나..... 당연히 주인공이 하나일거라고 생각하면 안 되는 거구나..ㅠㅠㅠ 신데렐라와 멧밭쥐 두 주인공의 넘 아름다운 이야기야 따흑 근데 세라 친어머니 죽고 재혼한 건데 계보에도 안 올릴 수가 있나... 외가가 망해 없어지기라도 했나?", feedLikeCount: 123, feedCommentCount: 234, isSpoiler: false),
            RealtimePopularFeed(feedId: 1, feedContent: "주인공이 당연히 엘로디인 줄 알았는데.... 표지에 두명이 나온 이유가 있구나..... 당연히 주인공이 하나일거라고 생각하면 안 되는 거구나..ㅠㅠㅠ 신데렐라와 멧밭쥐 두 주인공의 넘 아름다운 이야기야 따흑 근데 세라 친어머니 죽고 재혼한 건데 계보에도 안 올릴 수가 있나... 외가가 망해 없어지기라도 했나?", feedLikeCount: 123, feedCommentCount: 234, isSpoiler: false),
            RealtimePopularFeed(feedId: 1, feedContent: "주인공이 당연히 엘로디인 줄 알았는데.... 표지에 두명이 나온 이유가 있구나..... 당연히 주인공이 하나일거라고 생각하면 안 되는 거구나..ㅠㅠㅠ 신데렐라와 멧밭쥐 두 주인공의 넘 아름다운 이야기야 따흑 근데 세라 친어머니 죽고 재혼한 건데 계보에도 안 올릴 수가 있나... 외가가 망해 없어지기라도 했나?", feedLikeCount: 123, feedCommentCount: 234, isSpoiler: false),
            RealtimePopularFeed(feedId: 1, feedContent: "주인공이 당연히 엘로디인 줄 알았는데.... 표지에 두명이 나온 이유가 있구나..... 당연히 주인공이 하나일거라고 생각하면 안 되는 거구나..ㅠㅠㅠ 신데렐라와 멧밭쥐 두 주인공의 넘 아름다운 이야기야 따흑 근데 세라 친어머니 죽고 재혼한 건데 계보에도 안 올릴 수가 있나... 외가가 망해 없어지기라도 했나?", feedLikeCount: 123, feedCommentCount: 234, isSpoiler: false),
            RealtimePopularFeed(feedId: 1, feedContent: "주인공이 당연히 엘로디인 줄 알았는데.... 표지에 두명이 나온 이유가 있구나..... 당연히 주인공이 하나일거라고 생각하면 안 되는 거구나..ㅠㅠㅠ 신데렐라와 멧밭쥐 두 주인공의 넘 아름다운 이야기야 따흑 근데 세라 친어머니 죽고 재혼한 건데 계보에도 안 올릴 수가 있나... 외가가 망해 없어지기라도 했나?", feedLikeCount: 123, feedCommentCount: 234, isSpoiler: false),
            RealtimePopularFeed(feedId: 1, feedContent: "주인공이 당연히 엘로디인 줄 알았는데.... 표지에 두명이 나온 이유가 있구나..... 당연히 주인공이 하나일거라고 생각하면 안 되는 거구나..ㅠㅠㅠ 신데렐라와 멧밭쥐 두 주인공의 넘 아름다운 이야기야 따흑 근데 세라 친어머니 죽고 재혼한 건데 계보에도 안 올릴 수가 있나... 외가가 망해 없어지기라도 했나?", feedLikeCount: 123, feedCommentCount: 234, isSpoiler: false),
            RealtimePopularFeed(feedId: 1, feedContent: "주인공이 당연히 엘로디인 줄 알았는데.... 표지에 두명이 나온 이유가 있구나..... 당연히 주인공이 하나일거라고 생각하면 안 되는 거구나..ㅠㅠㅠ 신데렐라와 멧밭쥐 두 주인공의 넘 아름다운 이야기야 따흑 근데 세라 친어머니 죽고 재혼한 건데 계보에도 안 올릴 수가 있나... 외가가 망해 없어지기라도 했나?", feedLikeCount: 123, feedCommentCount: 234, isSpoiler: false),
            RealtimePopularFeed(feedId: 1, feedContent: "주인공이 당연히 엘로디인 줄 알았는데.... 표지에 두명이 나온 이유가 있구나..... 당연히 주인공이 하나일거라고 생각하면 안 되는 거구나..ㅠㅠㅠ 신데렐라와 멧밭쥐 두 주인공의 넘 아름다운 이야기야 따흑 근데 세라 친어머니 죽고 재혼한 건데 계보에도 안 올릴 수가 있나... 외가가 망해 없어지기라도 했나?", feedLikeCount: 123, feedCommentCount: 234, isSpoiler: false),
            RealtimePopularFeed(feedId: 1, feedContent: "주인공이 당연히 엘로디인 줄 알았는데.... 표지에 두명이 나온 이유가 있구나..... 당연히 주인공이 하나일거라고 생각하면 안 되는 거구나..ㅠㅠㅠ 신데렐라와 멧밭쥐 두 주인공의 넘 아름다운 이야기야 따흑 근데 세라 친어머니 죽고 재혼한 건데 계보에도 안 올릴 수가 있나... 외가가 망해 없어지기라도 했나?", feedLikeCount: 123, feedCommentCount: 234, isSpoiler: false)]))
    }
    
    func getInterestFeeds() -> Observable<InterestFeeds> {
        return Observable.just(InterestFeeds(recommendFeeds: [
            InterestFeed(novelId: 1, novelTitle: "신데렐라는 이 멧밭쥐가 데려갑니다", novelImage: "https://i.pinimg.com/736x/53/95/06/539506e93756577d5068c9dfca600be5.jpg", novelRating: 4.21, novelRatingCount: 1003, userNickname: "구리스", userAvatarImage: "https://i.pinimg.com/474x/b3/17/f3/b317f39796d1974de83f01f4ffeb32c3.jpg", userFeedContent: "주인공이 당연히 엘로디인 줄 알았는데.... 표지에 두명이 나온 이유가 있구나..... 당연히 주인공이 하나일거라고 생각하면 안 되는 거구나..ㅠㅠㅠ 신데렐라와 멧밭쥐 두 주인공의 넘 아름다운 이야기야 따흑 근데 세라 친어머니 죽고 재혼한 건데 계보에도 안 올릴 수가 있나... 외가가 망해 없어지기라도 했나?"),
            InterestFeed(novelId: 1, novelTitle: "신데렐라는 이 멧밭쥐가 데려갑니다", novelImage: "https://i.pinimg.com/736x/53/95/06/539506e93756577d5068c9dfca600be5.jpg", novelRating: 4.21, novelRatingCount: 1003, userNickname: "구리스", userAvatarImage: "https://i.pinimg.com/474x/b3/17/f3/b317f39796d1974de83f01f4ffeb32c3.jpg", userFeedContent: "주인공이 당연히 엘로디인 줄 알았는데.... 표지에 두명이 나온 이유가 있구나..... 당연히 주인공이 하나일거라고 생각하면 안 되는 거구나..ㅠㅠㅠ 신데렐라와 멧밭쥐 두 주인공의 넘 아름다운 이야기야 따흑 근데 세라 친어머니 죽고 재혼한 건데 계보에도 안 올릴 수가 있나... 외가가 망해 없어지기라도 했나?"),
            InterestFeed(novelId: 1, novelTitle: "신데렐라는 이 멧밭쥐가 데려갑니다", novelImage: "https://i.pinimg.com/736x/53/95/06/539506e93756577d5068c9dfca600be5.jpg", novelRating: 4.21, novelRatingCount: 1003, userNickname: "구리스", userAvatarImage: "https://i.pinimg.com/474x/b3/17/f3/b317f39796d1974de83f01f4ffeb32c3.jpg", userFeedContent: "주인공이 당연히 엘로디인 줄 알았는데.... 표지에 두명이 나온 이유가 있구나..... 당연히 주인공이 하나일거라고 생각하면 안 되는 거구나..ㅠㅠㅠ 신데렐라와 멧밭쥐 두 주인공의 넘 아름다운 이야기야 따흑 근데 세라 친어머니 죽고 재혼한 건데 계보에도 안 올릴 수가 있나... 외가가 망해 없어지기라도 했나?"),
            InterestFeed(novelId: 1, novelTitle: "신데렐라는 이 멧밭쥐가 데려갑니다", novelImage: "https://i.pinimg.com/736x/53/95/06/539506e93756577d5068c9dfca600be5.jpg", novelRating: 4.21, novelRatingCount: 1003, userNickname: "구리스", userAvatarImage: "https://i.pinimg.com/474x/b3/17/f3/b317f39796d1974de83f01f4ffeb32c3.jpg", userFeedContent: "주인공이 당연히 엘로디인 줄 알았는데.... 표지에 두명이 나온 이유가 있구나..... 당연히 주인공이 하나일거라고 생각하면 안 되는 거구나..ㅠㅠㅠ 신데렐라와 멧밭쥐 두 주인공의 넘 아름다운 이야기야 따흑 근데 세라 친어머니 죽고 재혼한 건데 계보에도 안 올릴 수가 있나... 외가가 망해 없어지기라도 했나?"),
            InterestFeed(novelId: 1, novelTitle: "신데렐라는 이 멧밭쥐가 데려갑니다", novelImage: "https://i.pinimg.com/736x/53/95/06/539506e93756577d5068c9dfca600be5.jpg", novelRating: 4.21, novelRatingCount: 1003, userNickname: "구리스", userAvatarImage: "https://i.pinimg.com/474x/b3/17/f3/b317f39796d1974de83f01f4ffeb32c3.jpg", userFeedContent: "주인공이 당연히 엘로디인 줄 알았는데.... 표지에 두명이 나온 이유가 있구나..... 당연히 주인공이 하나일거라고 생각하면 안 되는 거구나..ㅠㅠㅠ 신데렐라와 멧밭쥐 두 주인공의 넘 아름다운 이야기야 따흑 근데 세라 친어머니 죽고 재혼한 건데 계보에도 안 올릴 수가 있나... 외가가 망해 없어지기라도 했나?"),
            InterestFeed(novelId: 1, novelTitle: "신데렐라는 이 멧밭쥐가 데려갑니다", novelImage: "https://i.pinimg.com/736x/53/95/06/539506e93756577d5068c9dfca600be5.jpg", novelRating: 4.21, novelRatingCount: 1003, userNickname: "구리스", userAvatarImage: "https://i.pinimg.com/474x/b3/17/f3/b317f39796d1974de83f01f4ffeb32c3.jpg", userFeedContent: "주인공이 당연히 엘로디인 줄 알았는데.... 표지에 두명이 나온 이유가 있구나..... 당연히 주인공이 하나일거라고 생각하면 안 되는 거구나..ㅠㅠㅠ 신데렐라와 멧밭쥐 두 주인공의 넘 아름다운 이야기야 따흑 근데 세라 친어머니 죽고 재혼한 건데 계보에도 안 올릴 수가 있나... 외가가 망해 없어지기라도 했나?")]))
    }
    
    func getTasteRecommendNovels() -> Observable<TasteRecommendNovels> {
        return Observable.just(TasteRecommendNovels(tasteNovels: [
            TasteRecommendNovel(novelId: 1, novelTitle: "마스터피스", novelAuthor: "최서연, 구리스, 최서연, 구리스, 최서연, 구리스, 최서연, 구리스", novelImage: "https://i.pinimg.com/564x/10/f9/18/10f918f589ce4bf8826611da6c32804d.jpg", novelLikeCount: 123, novelRating: 4.21, novelRatingCount: 456),
            TasteRecommendNovel(novelId: 1, novelTitle: "요괴극의 왕후는 말이 없다", novelAuthor: "최서연, 구리스, 최서연, 구리스, 최서연, 구리스, 최서연, 구리스, 최서연, 구리스, 최서연, 구리스", novelImage: "https://i.pinimg.com/564x/a3/93/dc/a393dcea6beb521e7c9fa7414cc5df86.jpg", novelLikeCount: 123, novelRating: 4.21, novelRatingCount: 456),
            TasteRecommendNovel(novelId: 1, novelTitle: "련주부인", novelAuthor: "최서연, 구리스", novelImage: "https://i.pinimg.com/736x/89/60/20/896020bfde20d1b3f3617968f5446797.jpg", novelLikeCount: 123, novelRating: 4.21, novelRatingCount: 456),
            TasteRecommendNovel(novelId: 1, novelTitle: "후회가 병이라면 너희는 죽음이다", novelAuthor: "최서연, 구리스", novelImage: "https://i.pinimg.com/736x/3d/3f/11/3d3f118ed6d29b62cd5a6ed9f9631263.jpg", novelLikeCount: 123, novelRating: 4.21, novelRatingCount: 456),
            TasteRecommendNovel(novelId: 1, novelTitle: "흑막 영주의 애착인형이 되었다", novelAuthor: "최서연, 구리스", novelImage: "https://i.pinimg.com/736x/09/f3/26/09f326e085c88609f85958fe5411e3e6.jpg", novelLikeCount: 123, novelRating: 4.21, novelRatingCount: 456),
            TasteRecommendNovel(novelId: 1, novelTitle: "그 배드 엔딩이 끝이 아니라고요?", novelAuthor: "최서연, 구리스", novelImage: "https://i.pinimg.com/564x/e2/5a/ab/e25aab9e2e6a5fea586f3eead0533eee.jpg", novelLikeCount: 123, novelRating: 4.21, novelRatingCount: 456),
            TasteRecommendNovel(novelId: 1, novelTitle: "위대한 미친개", novelAuthor: "최서연, 구리스", novelImage: "https://i.pinimg.com/736x/15/f3/a2/15f3a20b1f5b6c0f0946d9add2e5c0ac.jpg", novelLikeCount: 123, novelRating: 4.21, novelRatingCount: 456),
            TasteRecommendNovel(novelId: 1, novelTitle: "전남편이 재결합을 요구합니다", novelAuthor: "최서연, 구리스", novelImage: "https://i.pinimg.com/736x/12/6b/dd/126bddbd6bbca67ac0e61129517d96d6.jpg", novelLikeCount: 123, novelRating: 4.21, novelRatingCount: 456),
            TasteRecommendNovel(novelId: 1, novelTitle: "신라의 공주로 살아남는 법", novelAuthor: "최서연, 구리스", novelImage: "https://i.pinimg.com/564x/2d/49/21/2d49212b3719f15ac473e2f58a721444.jpg", novelLikeCount: 123, novelRating: 4.21, novelRatingCount: 456),
            TasteRecommendNovel(novelId: 1, novelTitle: "수요일, 쥬리는 추리 소설을 빌린다", novelAuthor: "최서연, 구리스", novelImage: "https://i.pinimg.com/564x/9e/09/42/9e0942e2f798e6f88dab8a1a87e556f8.jpg", novelLikeCount: 123, novelRating: 4.21, novelRatingCount: 456)]))
    }
}
