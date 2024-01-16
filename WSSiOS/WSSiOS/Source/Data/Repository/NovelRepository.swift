//
//  NovelRepository.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol NovelRepository {
    func getSearchNovels() -> Observable<SearchNovels>
}

struct DefaultNovelRepository: NovelRepository {
    
    private let novelService: NovelService
    
    init(novelService: NovelService) {
        self.novelService = novelService
    }
    
    func getSearchNovels() -> Observable<SearchNovels> {
        return novelService.getSearchNovelData()
            .asObservable()
    }
}

