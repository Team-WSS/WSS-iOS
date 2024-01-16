//
//  NovelRepository.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/16/24.
//

import Foundation

import RxSwift

protocol NovelRepository {
    func getNovel(novelId: Int) -> Observable<NovelResult>
}

struct DefaultNovelRepository: NovelRepository {
    private var novelService: NovelService
    
    init(novelService: NovelService) {
        self.novelService = novelService
    }
    
    func getNovel(novelId: Int) -> Observable<NovelResult> {
        return novelService.getNovelInfo(novelId: novelId)
            .asObservable()
    }
}
