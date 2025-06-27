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
                      sortType: SortType) -> Single<MyLibraryListEntity>
}

struct DefaultMyLibraryRepository: MyLibraryRepository {
    
    private var myLibraryService: MyLibraryService
    
    init(myLibraryService: MyLibraryService) {
        self.myLibraryService = myLibraryService
    }

    func getNovelList(filterOption: LibraryFilterOption,
                      lastUserNovelId: Int,
                      size: Int,
                      sortType: SortType) -> Single<MyLibraryListEntity> {
        let userId = UserDefaults.standard.integer(forKey: StringLiterals.UserDefault.userId)
        var queryItem = MyLibraryNovelListQuery(
            lastUserNovelId: lastUserNovelId,
            size: size,
            sortType: sortType.queryText)
        queryItem.isInterest = filterOption.interestedOption
        queryItem.readStatus = filterOption.readStatusOptions.map { $0.rawValue }
        queryItem.novelRating = filterOption.starRatingOption.map { $0.toFloat }
        queryItem.attractivePoints = filterOption.attractivePointOptions.map { $0.rawValue }
            
        return myLibraryService.getNovelList(userId: userId, queryItem: queryItem).map { $0.toEntity() }
    }
}
