//
//  FeedRepository.swift
//  WSSiOS
//
//  Created by 신지원 on 5/15/24.
//

import Foundation

import RxSwift

protocol FeedRepository {
    func getFeedData(category: String,
                     lastFeedId: Int,
                     size: Int) -> Observable<TotalFeed>
    func getSingleFeedData(feedId: Int) -> Observable<Feed>
    func getSingleFeedComments(feedId: Int) -> Observable<FeedComment>
}

struct TestFeedRepository: FeedRepository {
    func getFeedData(category: String, lastFeedId: Int, size: Int) -> Observable<TotalFeed> {
        return Observable.just(TotalFeed(category: "drama", isLoadable: true, feeds: [TotalFeeds(userId: 123,
                                                                                                 nickname: "지원입니둥",
                                                                                                 avatarImage: dummyFeedImage,
                                                                                                 feedId: 846,
                                                                                                 createdDate: "3월 21일",
                                                                                                 feedContent: "판소추천해요!",
                                                                                                 likeCount: 333,
                                                                                                 isLiked: false,
                                                                                                 commentCount: 7,
                                                                                                 novelId: 123,
                                                                                                 title: "안녕하세요전안안녕한데요?안녕하세요?안녕하신지요?",
                                                                                                 novelRatingCount: 523,
                                                                                                 novelRating: 4.0,
                                                                                                 relevantCategories: ["wuxia", "romance", "wuxia", "romance"],
                                                                                                 isSpolier: false,
                                                                                                 isModified: true,
                                                                                                 isMyFeed: false)]))
    }
    
    func getSingleFeedData(feedId: Int) -> Observable<Feed> {
        return Observable.just(Feed(userId: 1003,
                                    userNickName: "구리스",
                                    userProfileImage: "https://i.pinimg.com/564x/d6/01/72/d60172b19b2a70f0e64282ac769cbe00.jpg",
                                    createdDate: "10월 3일",
                                    feedContent: "여름 햇살이 뜨겁게 내리쬐던 어느 오후, 작은 마을의 공원에서 아이들의 웃음소리가 가득했다. 그들은 공놀이를 하며 즐거운 시간을 보내고 있었다. 나무 그늘 아래에는 노부부가 벤치에 앉아 이야기를 나누고 있었다. 그들은 서로의 손을 꼭 잡고 오랜 추억을 이야기하며 미소를 지었다. 공원의 풍경은 평화롭고 아름다웠다. 바람에 흔들리는 나뭇잎 소리와 함께 새들의 지저귐이 어우러져 한 폭의 그림 같았다. 시간이 천천히 흐르는 듯한 그곳에서, 사람들은 일상의 소소한 행복을 만끽하고 있었다.",
                                    likeCount: 123,
                                    isLiked: false,
                                    novelId: 1116,
                                    novelTitle: "결혼 다음날 남편이 사라졌다",
                                    novelRatingCount: 234,
                                    novelRating: 2.23,
                                    genres: [.drama, .modernFantasy, .romanceFantasy],
                                    isSpoiler: false,
                                    isModified: true,
                                    isMyFeed: false)
        )
    }
    
    func getSingleFeedComments(feedId: Int) -> Observable<FeedComment> {
        return Observable.just(FeedComment(commentCount: 619,
                                           comments: [Comment(userId: 1,
                                                              userNickname: "구리스",
                                                              userProfileImage: "https://i.pinimg.com/564x/d6/01/72/d60172b19b2a70f0e64282ac769cbe00.jpg",
                                                              commentId: 1,
                                                              createdDate: "10월 3일",
                                                              commentContent: "진짜 재미있다 ㄷㄷ",
                                                              isModified: true,
                                                              isMyComment: true),
                                                      Comment(userId: 1,
                                                              userNickname: "진토",
                                                              userProfileImage: "https://i.pinimg.com/564x/1e/a8/30/1ea83070ec8c2618b0626c8955592c46.jpg",
                                                              commentId: 1,
                                                              createdDate: "11월 16일",
                                                              commentContent: "진짜 더 재미있다 ㄷㄷ",
                                                              isModified: false,
                                                              isMyComment: false),
                                                      Comment(userId: 1,
                                                              userNickname: "이안",
                                                              userProfileImage: "https://i.pinimg.com/736x/b8/56/31/b8563131f893fe4979a9d1b9d978e5a0.jpg",
                                                              commentId: 1,
                                                              createdDate: "7월 11일",
                                                              commentContent: "오늘 우연히 본 영화가 너무 재미있어서 시간 가는 줄 몰랐어요! 이야기도 탄탄하고 배우들의 연기도 훌륭해서 몰입할 수밖에 없었죠. 특히 결말 부분에서는 반전이 있어서 정말 놀랐어요. 영화가 끝난 후에도 여운이 남아 계속 생각하게 되더라고요. 다음에 친구들과 다시 한 번 보고 싶어요. 이런 영화를 더 자주 봤으면 좋겠어요. 여러분도 꼭 한 번 보세요!",
                                                              isModified: true,
                                                              isMyComment: false)
                                           ]))
    }
}

struct DefaultFeedRepository: FeedRepository {
    private var feedService: FeedService
    
    init(feedService: FeedService) {
        self.feedService = feedService
    }
    
    func getFeedData(category: String, lastFeedId: Int, size: Int) -> RxSwift.Observable<TotalFeed> {
        return feedService.getFeedList(category: category, lastFeedId: lastFeedId, size: size)
            .asObservable()
    }
    
    func getSingleFeedData(feedId: Int) -> Observable<Feed> {
        return Observable.just(Feed(userId: 1003,
                                    userNickName: "구리스",
                                    userProfileImage: "https://i.pinimg.com/564x/d6/01/72/d60172b19b2a70f0e64282ac769cbe00.jpg",
                                    createdDate: "10월 3일",
                                    feedContent: "여름 햇살이 뜨겁게 내리쬐던 어느 오후, 작은 마을의 공원에서 아이들의 웃음소리가 가득했다. 그들은 공놀이를 하며 즐거운 시간을 보내고 있었다. 나무 그늘 아래에는 노부부가 벤치에 앉아 이야기를 나누고 있었다. 그들은 서로의 손을 꼭 잡고 오랜 추억을 이야기하며 미소를 지었다. 공원의 풍경은 평화롭고 아름다웠다. 바람에 흔들리는 나뭇잎 소리와 함께 새들의 지저귐이 어우러져 한 폭의 그림 같았다. 시간이 천천히 흐르는 듯한 그곳에서, 사람들은 일상의 소소한 행복을 만끽하고 있었다.",
                                    likeCount: 123,
                                    isLiked: false,
                                    novelId: 1116,
                                    novelTitle: "결혼 다음날 남편이 사라졌다",
                                    novelRatingCount: 234,
                                    novelRating: 2.23,
                                    genres: [.drama, .modernFantasy, .romanceFantasy],
                                    isSpoiler: false,
                                    isModified: true,
                                    isMyFeed: false))
    }
    
    func getSingleFeedComments(feedId: Int) -> Observable<FeedComment> {
        return Observable.just(FeedComment(commentCount: 619,
                                           comments: [Comment(userId: 1,
                                                              userNickname: "구리스",
                                                              userProfileImage: "https://i.pinimg.com/564x/d6/01/72/d60172b19b2a70f0e64282ac769cbe00.jpg",
                                                              commentId: 1,
                                                              createdDate: "10월 3일",
                                                              commentContent: "진짜 재미있다 ㄷㄷ",
                                                              isModified: true,
                                                              isMyComment: true),
                                                      Comment(userId: 1,
                                                              userNickname: "진토",
                                                              userProfileImage: "https://i.pinimg.com/564x/1e/a8/30/1ea83070ec8c2618b0626c8955592c46.jpg",
                                                              commentId: 1,
                                                              createdDate: "11월 16일",
                                                              commentContent: "진짜 더 재미있다 ㄷㄷ",
                                                              isModified: false,
                                                              isMyComment: false),
                                                      Comment(userId: 1,
                                                              userNickname: "이안",
                                                              userProfileImage: "https://i.pinimg.com/736x/b8/56/31/b8563131f893fe4979a9d1b9d978e5a0.jpg",
                                                              commentId: 1,
                                                              createdDate: "7월 11일",
                                                              commentContent: "오늘 우연히 본 영화가 너무 재미있어서 시간 가는 줄 몰랐어요! 이야기도 탄탄하고 배우들의 연기도 훌륭해서 몰입할 수밖에 없었죠. 특히 결말 부분에서는 반전이 있어서 정말 놀랐어요. 영화가 끝난 후에도 여운이 남아 계속 생각하게 되더라고요. 다음에 친구들과 다시 한 번 보고 싶어요. 이런 영화를 더 자주 봤으면 좋겠어요. 여러분도 꼭 한 번 보세요!",
                                                              isModified: true,
                                                              isMyComment: false)
                                           ]))
    }
}
