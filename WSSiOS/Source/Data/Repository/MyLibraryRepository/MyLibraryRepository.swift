//
//  MyLibraryRepository.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/27/25.
//

import Foundation

import RxSwift

protocol MyLibraryRepository {
    func getNovelList(filterOption: LibraryFilterOption,
                      lastUserNovelId: Int,
                      size: Int,
                      sortType: LibrarySortType) -> Single<MyLibraryEntity>
}

struct DefaultMyLibraryRepository: MyLibraryRepository {
    
    private var myLibraryService: MyLibraryService
    
    init(myLibraryService: MyLibraryService) {
        self.myLibraryService = myLibraryService
    }

    func getNovelList(filterOption: LibraryFilterOption,
                      lastUserNovelId: Int,
                      size: Int,
                      sortType: LibrarySortType) -> Single<MyLibraryEntity> {
        let userId = UserDefaults.standard.integer(forKey: StringLiterals.UserDefault.userId)
        // TODO: v2(/novels/v2) 연결 시 sortType.queryValue 사용. v1은 RECENT/OLD만 지원하므로
        //       새 정렬 4종(제목순/날짜순/별점순)은 그때까지 최신순(RECENT)으로 떨어진다.
        let sortCriteria = sortType == .createdAsc ? "OLD" : "RECENT"
        var queryItem = MyLibraryNovelListQuery(
            lastUserNovelId: lastUserNovelId,
            size: size,
            sortType: sortCriteria)
        queryItem.isInterest = filterOption.interestedOption ? true : nil
        queryItem.novelRating = filterOption.starRatingOption.map { $0.toFloat }
        if !filterOption.readStatusOptions.isEmpty {
            queryItem.readStatus = filterOption.readStatusOptions.map { $0.rawValue }
        }
        if !filterOption.attractivePointOptions.isEmpty {
            queryItem.attractivePoints = filterOption.attractivePointOptions.map { $0.rawValue }
        }
       
        return myLibraryService.getNovelList(userId: userId, queryItem: queryItem).map { $0.toEntity() }
    }
}
