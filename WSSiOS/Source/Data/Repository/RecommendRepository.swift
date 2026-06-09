//
//  RecommendRepository.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol RecommendRepository {
    func getTodayPopularNovels() -> Observable<TodayDiscoveryNovels>
    func getRealtimePopularFeeds() -> Observable<RealtimePopularFeeds>
    func getInterestFeeds() -> Observable<InterestFeeds>
    func getTasteRecommendNovels() -> Observable<TasteRecommendNovels>
}

struct DefaultRecommendRepository: RecommendRepository {
    
    private let recommendService: RecommendService
    
    init(recommendService: RecommendService) {
        self.recommendService = recommendService
    }
    
    func getTodayPopularNovels() -> Observable<TodayDiscoveryNovels> {
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
    func getTodayPopularNovels() -> Observable<TodayDiscoveryNovels> {
        let avatarImage = "/character/returner/infinite/profile/profile"
        
        return Observable.just(TodayDiscoveryNovels(popularNovels: [
            TodayDiscoveryNovel(
                novelId: 10702,
                title: "우아한 오브리",
                novelImage: "https://i.pinimg.com/736x/70/54/70/705470563de4ad028c5323fe2ac16628.jpg",
                avatarImage: avatarImage,
                nickname: "호호호호",
                feedContent: """
                애들아 너네 그냥 서로 다른 사람 만나!!!!!!!
                솔체 작가님 다른 작품은 다 끝까지 잘 봤는데 이건 진짜 속 터진다.
                """,
                author: "김캐롤",
                isNovelCompleted: true,
                genreName: "romance",
                keywords: [],
                novelDescription: "노예였던 과거를 숨긴 채 완벽한 레이디가 되려는 오브리의 이야기.",
                novelGenres: []
            ),

            TodayDiscoveryNovel(
                novelId: 10703,
                title: "남주의 첫날밤을 가져버렸다",
                novelImage: "https://i.pinimg.com/736x/c2/b9/35/c2b935b278e1a9c6afb4ac3f44413fb7.jpg",
                avatarImage: avatarImage,
                nickname: "로판덕후",
                feedContent: nil,
                author: "황도톨",
                isNovelCompleted: true,
                genreName: "drama",
                keywords: ["빙의"],
                novelDescription: "소설 속 엑스트라가 된 주인공의 생존기.",
                novelGenres: []
            ),

            TodayDiscoveryNovel(
                novelId: 10704,
                title: "악녀는 두 번 산다",
                novelImage: "https://i.pinimg.com/736x/fb/03/d7/fb03d7d3b195faf1a00dd59e14bca48b.jpg",
                avatarImage: avatarImage,
                nickname: "회귀물중독자",
                feedContent: "정치 싸움이 진짜 재밌음.",
                author: "한민트",
                isNovelCompleted: false,
                genreName: "romanceFantasy",
                keywords: ["회귀", "정치"],
                novelDescription: "과거를 되돌린 악녀의 복수와 성장.",
                novelGenres: []
            ),

            TodayDiscoveryNovel(
                novelId: 10705,
                title: "전지적 독자 시점",
                novelImage: "https://i.pinimg.com/736x/cd/93/2b/cd932be874a7a734cfd5ca1db6d171bb.jpg",
                avatarImage: avatarImage,
                nickname: "김독자",
                feedContent: nil,
                author: "싱숑",
                isNovelCompleted: true,
                genreName: "fantasy",
                keywords: [],
                novelDescription: "소설의 결말을 아는 유일한 독자의 이야기.",
                novelGenres: []
            ),

            TodayDiscoveryNovel(
                novelId: 10706,
                title: "화산귀환",
                novelImage: "https://i.pinimg.com/1200x/05/45/e0/0545e0a8ef0dfdb150c0a64806a1afb2.jpg",
                avatarImage: avatarImage,
                nickname: "청명최고",
                feedContent: "청명이 입만 열면 웃김ㅋㅋ",
                author: "비가",
                isNovelCompleted: false,
                genreName: "wuxia",
                keywords: ["무협"],
                novelDescription: "몰락한 화산파를 다시 일으키는 이야기.",
                novelGenres: []
            ),

            // 작가명 6자 이상
            TodayDiscoveryNovel(
                novelId: 10707,
                title: "데뷔 못 하면 죽는 병 걸림",
                novelImage: "https://i.pinimg.com/736x/e4/24/b7/e424b7e42676272df45471e6e4c4ca44.jpg",
                avatarImage: avatarImage,
                nickname: "아이돌처돌이",
                feedContent: """
                아이돌물 안 좋아하는데도 재밌게 봄.
                캐릭터가 많아도 다 살아있다.
                """,
                author: "DS백프로덕션",
                isNovelCompleted: false,
                genreName: "mystery",
                keywords: ["아이돌", "시스템"],
                novelDescription: "살기 위해 아이돌 데뷔를 해야 하는 주인공.",
                novelGenres: []
            ),

            // 작가명 8자 이상 + feedContent nil
            TodayDiscoveryNovel(
                novelId: 10708,
                title: "괴담에 떨어져도 출근을 해야 하는구나",
                novelImage: "https://i.pinimg.com/736x/c2/26/7c/c2267c99c247ac9c559f0826e95e423a.jpg",
                avatarImage: avatarImage,
                nickname: "맥시사랑해",
                feedContent: nil,
                author: "김수지로맨스작가",
                isNovelCompleted: true,
                genreName: "BL",
                keywords: ["순애", "성장"],
                novelDescription: "말더듬이 귀족 영애와 기사 리프탄의 이야기.",
                novelGenres: []
            ),

            TodayDiscoveryNovel(
                novelId: 10709,
                title: "이번 생에는 사천당가의 몰락을 꿈꾼다",
                novelImage: "https://i.pinimg.com/736x/9f/63/ea/9f63eaf0aad92b0b440fe7d5afd6608f.jpg",
                avatarImage: avatarImage,
                nickname: "성진우팬클럽회장",
                feedContent: "성장형 먼치킨의 정석.",
                author: "추공",
                isNovelCompleted: true,
                genreName: "modernFantasy",
                keywords: [],
                novelDescription: "최약체 헌터가 최강으로 성장하는 이야기.",
                novelGenres: []
            ),

            // 아주 긴 작가명
            TodayDiscoveryNovel(
                novelId: 10710,
                title: "괴물 공작가의 계약 공녀",
                novelImage: "https://i.pinimg.com/736x/be/51/50/be5150c61140c2cf3bf334de3f47907c.jpg",
                avatarImage: avatarImage,
                nickname: "로판수집가123",
                feedContent: """
                가족 서사가 생각보다 훨씬 좋음.
                눈물 버튼 여러 번 눌림.
                """,
                author: "리아란판타지스튜디오",
                isNovelCompleted: true,
                genreName: "lightNovel",
                keywords: ["입양"],
                novelDescription: "괴물 공작가에 입양된 소녀의 성장 이야기.",
                novelGenres: []
            )
        ]))
    }
    
    func getRealtimePopularFeeds() -> Observable<RealtimePopularFeeds> {
        return Observable.just(RealtimePopularFeeds(popularFeeds: [
            RealtimePopularFeed(
                        feedId: 1,
                        feedContent: "결말 스포 안 할게. 그냥 꼭 봐… 마지막 20화 몰아보는데 손에서 폰을 못 내려놓았다. 다 보고 나니까 초반 장면들이 전부 다르게 보이는 작품이었다",
                        likeCount: 124,
                        commentCount: 18,
                        isSpoiler: false,
                        isPublic: true,
                        novelTitle: "짝사랑 상실의 순기능",
                        novelImage: "https://i.pinimg.com/736x/23/69/d1/2369d18fb97c531a041b70c9efbb369a.jpg",
                        novelGenre: "romanceFantasy"
                    ),
                    RealtimePopularFeed(
                        feedId: 2,
                        feedContent: "오늘 올라온 회차 미쳤다...",
                        likeCount: 358,
                        commentCount: 52,
                        isSpoiler: true,
                        isPublic: true,
                        novelTitle: "미국 천재 감정사가 트럭 몰고 보물 주워서 인생역전",
                        novelImage: "https://i.pinimg.com/736x/d2/10/71/d210716c07f6828e724db047a78104a9.jpg",
                        novelGenre: "fantasy"
                    ),
                    RealtimePopularFeed(
                        feedId: 3,
                        feedContent: "작가님 필력 미쳤다. 같은 장면을 다른 인물 시점으로 보여주는데 느낌이 완전히 달라져서 다시 읽게 됨. 대사 하나로 관계 역전시키는 연출이 특히 좋았고, 감정 묘사가 과하지 않은데도 여운이 길게 남는다.",
                        likeCount: 89,
                        commentCount: 7,
                        isSpoiler: false,
                        isPublic: true,
                        novelTitle: "메스가키 성녀님과 여행하는 용사가 되었다",
                        novelImage: "https://img.ridicdn.net/cover/6038052326/xxlarge#1",
                        novelGenre: "drama"
                    ),
                    RealtimePopularFeed(
                        feedId: 4,
                        feedContent: "정주행하다가 새벽 4시 됨. 한 화만 더 보자 하고 넘겼는데 계속 엔딩을 궁금하게 끊어서 멈출 타이밍이 없었다. 로맨스, 사건, 세계관 떡밥 비율이 균형 좋아서 취향 안 타고 추천하기 괜찮은 작품이라고 생각함.",
                        likeCount: 241,
                        commentCount: 21,
                        isSpoiler: false,
                        isPublic: true,
                        novelTitle: "주인공 혼자 다 해 먹는 헌터물에 빙의했다",
                        novelImage: "https://i.pinimg.com/736x/d4/bc/12/d4bc128496f42f4a14dbdb4e4bedaeb3.jpg",
                        novelGenre: "lightNovel"
                    ),
                    RealtimePopularFeed(
                        feedId: 5,
                        feedContent: "무협 안 좋아하는데도 재밌게 읽는 중",
                        likeCount: 77,
                        commentCount: 5,
                        isSpoiler: false,
                        isPublic: true,
                        novelTitle: "몽중인 - 꿈속의 암살자",
                        novelImage: "https://i.pinimg.com/736x/df/8b/fc/df8bfc3d40960397f79fd119b88d35a3.jpg",
                        novelGenre: "wuxia"
                    ),
                    RealtimePopularFeed(
                        feedId: 6,
                        feedContent: "주인공이 개복치임(병약) 소재 사용이 너무 과해서 거북할 정도로 많이 나왔고 주인공이 좀 많이 지능이 모자람(잘 쳐줘도 청소년~유딩 수준의 정신연령같음)\n\n솔직히 설정이나 밀어주는 방식은 괜찮았는데 이 사용이 너무 과하더군요\n뭐 아이돌물 좋아하시면 찍먹은 괜찮을듯\n",
                        likeCount: 512,
                        commentCount: 103,
                        isSpoiler: true,
                        isPublic: true,
                        novelTitle: "캐니언 섬의 부적절한 생존법",
                        novelImage: "https://i.pinimg.com/1200x/78/87/7b/78877b376f8f629f9454a47c0d9e91f7.jpg",
                        novelGenre: "BL"
                    )
        ]))
    }
    
    func getInterestFeeds() -> Observable<InterestFeeds> {
        return Observable.just(InterestFeeds(recommendFeeds: [
            InterestFeed(novelId: 1, novelTitle: "신데렐라는 이 멧밭쥐가 데려갑니다", novelImage: "https://i.pinimg.com/736x/53/95/06/539506e93756577d5068c9dfca600be5.jpg", novelRating: 4.21, novelRatingCount: 1003, userNickname: "구리스", userAvatarImage: "https://i.pinimg.com/474x/b3/17/f3/b317f39796d1974de83f01f4ffeb32c3.jpg", userFeedContent: "주인공이 당연히 엘로디인 줄 알았는데.... 표지에 두명이 나온 이유가 있구나..... 당연히 주인공이 하나일거라고 생각하면 안 되는 거구나..ㅠㅠㅠ 신데렐라와 멧밭쥐 두 주인공의 넘 아름다운 이야기야 따흑 근데 세라 친어머니 죽고 재혼한 건데 계보에도 안 올릴 수가 있나... 외가가 망해 없어지기라도 했나?"),
            InterestFeed(novelId: 1, novelTitle: "신데렐라는 이 멧밭쥐가 데려갑니다", novelImage: "https://i.pinimg.com/736x/53/95/06/539506e93756577d5068c9dfca600be5.jpg", novelRating: 4.21, novelRatingCount: 1003, userNickname: "구리스", userAvatarImage: "https://i.pinimg.com/474x/b3/17/f3/b317f39796d1974de83f01f4ffeb32c3.jpg", userFeedContent: "주인공이 당연히 엘로디인 줄 알았는데.... 표지에 두명이 나온 이유가 있구나..... 당연히 주인공이 하나일거라고 생각하면 안 되는 거구나..ㅠㅠㅠ 신데렐라와 멧밭쥐 두 주인공의 넘 아름다운 이야기야 따흑 근데 세라 친어머니 죽고 재혼한 건데 계보에도 안 올릴 수가 있나... 외가가 망해 없어지기라도 했나?"),
            InterestFeed(novelId: 1, novelTitle: "신데렐라는 이 멧밭쥐가 데려갑니다", novelImage: "https://i.pinimg.com/736x/53/95/06/539506e93756577d5068c9dfca600be5.jpg", novelRating: 4.21, novelRatingCount: 1003, userNickname: "구리스", userAvatarImage: "https://i.pinimg.com/474x/b3/17/f3/b317f39796d1974de83f01f4ffeb32c3.jpg", userFeedContent: "주인공이 당연히 엘로디인 줄 알았는데.... 표지에 두명이 나온 이유가 있구나..... 당연히 주인공이 하나일거라고 생각하면 안 되는 거구나..ㅠㅠㅠ 신데렐라와 멧밭쥐 두 주인공의 넘 아름다운 이야기야 따흑 근데 세라 친어머니 죽고 재혼한 건데 계보에도 안 올릴 수가 있나... 외가가 망해 없어지기라도 했나?"),
            InterestFeed(novelId: 1, novelTitle: "신데렐라는 이 멧밭쥐가 데려갑니다", novelImage: "https://i.pinimg.com/736x/53/95/06/539506e93756577d5068c9dfca600be5.jpg", novelRating: 4.21, novelRatingCount: 1003, userNickname: "구리스", userAvatarImage: "https://i.pinimg.com/474x/b3/17/f3/b317f39796d1974de83f01f4ffeb32c3.jpg", userFeedContent: "주인공이 당연히 엘로디인 줄 알았는데.... 표지에 두명이 나온 이유가 있구나..... 당연히 주인공이 하나일거라고 생각하면 안 되는 거구나..ㅠㅠㅠ 신데렐라와 멧밭쥐 두 주인공의 넘 아름다운 이야기야 따흑 근데 세라 친어머니 죽고 재혼한 건데 계보에도 안 올릴 수가 있나... 외가가 망해 없어지기라도 했나?"),
            InterestFeed(novelId: 1, novelTitle: "신데렐라는 이 멧밭쥐가 데려갑니다", novelImage: "https://i.pinimg.com/736x/53/95/06/539506e93756577d5068c9dfca600be5.jpg", novelRating: 4.21, novelRatingCount: 1003, userNickname: "구리스", userAvatarImage: "https://i.pinimg.com/474x/b3/17/f3/b317f39796d1974de83f01f4ffeb32c3.jpg", userFeedContent: "주인공이 당연히 엘로디인 줄 알았는데.... 표지에 두명이 나온 이유가 있구나..... 당연히 주인공이 하나일거라고 생각하면 안 되는 거구나..ㅠㅠㅠ 신데렐라와 멧밭쥐 두 주인공의 넘 아름다운 이야기야 따흑 근데 세라 친어머니 죽고 재혼한 건데 계보에도 안 올릴 수가 있나... 외가가 망해 없어지기라도 했나?"),
            InterestFeed(novelId: 1, novelTitle: "신데렐라는 이 멧밭쥐가 데려갑니다", novelImage: "https://i.pinimg.com/736x/53/95/06/539506e93756577d5068c9dfca600be5.jpg", novelRating: 4.21, novelRatingCount: 1003, userNickname: "구리스", userAvatarImage: "https://i.pinimg.com/474x/b3/17/f3/b317f39796d1974de83f01f4ffeb32c3.jpg", userFeedContent: "주인공이 당연히 엘로디인 줄 알았는데.... 표지에 두명이 나온 이유가 있구나..... 당연히 주인공이 하나일거라고 생각하면 안 되는 거구나..ㅠㅠㅠ 신데렐라와 멧밭쥐 두 주인공의 넘 아름다운 이야기야 따흑 근데 세라 친어머니 죽고 재혼한 건데 계보에도 안 올릴 수가 있나... 외가가 망해 없어지기라도 했나?")],
                                             message: ""))
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
