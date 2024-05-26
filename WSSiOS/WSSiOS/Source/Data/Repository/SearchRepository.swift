//
//  SearchRepository.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/27/24.
//

import Foundation

import RxSwift

protocol SearchRepository {
    func getSosoPickNovels() -> Observable<[SosoPickNovel]>
}

struct TestSearchRepository: SearchRepository {
    func getSosoPickNovels() -> Observable<[SosoPickNovel]> {
        return Observable.just([SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "구리구리스"),
                                SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "구리구리뱅"),
                                SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "상수리 나무 아래"),
                                SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "하수리 나무 위"),
                                SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "하수리수리마수리"),
                                SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "딱대"),
                                SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "토크쇼"),
                                SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "배고파"),
                                SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "닭가슴살꼬치먹고싶다")])
    }
}
