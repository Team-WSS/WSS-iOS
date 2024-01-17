//
//  NovelRepository.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/16/24.
//

import Foundation

import RxSwift

protocol NovelRepository {
    func getSearchNovels(searchWord: String) -> Observable<SearchNovels>
    func getNovelInfo(novelId: Int?) -> Observable<NovelResult>
}

struct DefaultNovelRepository: NovelRepository {
    
    private let novelService: NovelService
    
    init(novelService: NovelService) {
        self.novelService = novelService
    }
    
    func getSearchNovels(searchWord: String) -> Observable<SearchNovels> {
        return novelService.getSearchNovelData(searchWord: searchWord)
            .asObservable()
    }
    
    func getNovelInfo(novelId: Int?) -> Observable<NovelResult> {
        return novelService.getNovelInfo(novelId: novelId)
            .asObservable()
    }
}
