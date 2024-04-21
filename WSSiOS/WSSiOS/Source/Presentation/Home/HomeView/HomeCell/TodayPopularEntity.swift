//
//  TodayPopularEntity.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 4/21/24.
//

import Foundation

import RxSwift

struct TodayPopularEntity {
    var novelId: Int
    var title: String
    var novelImage: String
    var avatarImage: String
    var nickname: String
    var feedContent: String
}

var dummyData = Observable.just([TodayPopularEntity(novelId: 1,
                                                          title: "1번작품입니다다라마바사아자차카타파하",
                                                          novelImage: "imgTest2",
                                                          avatarImage: "imgTest2",
                                                          nickname: "구리스",
                                                          feedContent: "상수리 나무 아래는 ㄹㅇ 아마 제 인생작이 될꺼 같네요. 소장본도 사려고요 근데 약간 여주가 답답한 스타일인데 그거를 살려버린다 우왕"),
                                       TodayPopularEntity(novelId: 1,
                                                          title: "2번작품입니다다라마바사아자차카타파하",
                                                          novelImage: "imgTest2",
                                                          avatarImage: "imgTest2",
                                                          nickname: "구리스",
                                                          feedContent: "상수리 나무 아래는 ㄹㅇ 아마 제 인생작이 될꺼 같네요. 소장본도 사려고요 근데 약간 여주가 답답한 스타일인데 그거를 살려버린다 우왕"),
                                       TodayPopularEntity(novelId: 1,
                                                          title: "상수리 나무 아래라구요오오오오오오오오오오오오오옷",
                                                          novelImage: "imgTest2",
                                                          avatarImage: "imgTest2",
                                                          nickname: "구리스",
                                                          feedContent: "상수리 나무 아래는 ㄹㅇ 아마 제 인생작이 될꺼 같네요. 소장본도 사려고요 근데 약간 여주가 답답한 스타일인데 그거를 살려버린다 우왕"),
                                       TodayPopularEntity(novelId: 1,
                                                          title: "상수리 나무 아래라구요오오오오오오오오오오오오오옷",
                                                          novelImage: "imgTest2",
                                                          avatarImage: "imgTest2",
                                                          nickname: "구리스",
                                                          feedContent: "상수리 나무 아래는 ㄹㅇ 아마 제 인생작이 될꺼 같네요. 소장본도 사려고요 근데 약간 여주가 답답한 스타일인데 그거를 살려버린다 우왕"),
                                       TodayPopularEntity(novelId: 1,
                                                          title: "상수리 나무 아래라구요오오오오오오오오오오오오오옷",
                                                          novelImage: "imgTest2",
                                                          avatarImage: "imgTest2",
                                                          nickname: "구리스",
                                                          feedContent: "상수리 나무 아래는 ㄹㅇ 아마 제 인생작이 될꺼 같네요. 소장본도 사려고요 근데 약간 여주가 답답한 스타일인데 그거를 살려버린다 우왕"),
                                       TodayPopularEntity(novelId: 1,
                                                          title: "상수리 나무 아래라구요오오오오오오오오오오오오오옷",
                                                          novelImage: "imgTest2",
                                                          avatarImage: "imgTest2",
                                                          nickname: "구리스",
                                                          feedContent: "상수리 나무 아래는 ㄹㅇ 아마 제 인생작이 될꺼 같네요. 소장본도 사려고요 근데 약간 여주가 답답한 스타일인데 그거를 살려버린다 우왕")
])
