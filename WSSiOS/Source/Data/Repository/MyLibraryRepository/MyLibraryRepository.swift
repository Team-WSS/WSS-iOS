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
                      cursor: String?,
                      size: Int,
                      sortType: LibrarySortType) -> Single<MyLibraryEntity>
}

struct DefaultMyLibraryRepository: MyLibraryRepository {

    private var myLibraryService: MyLibraryService

    init(myLibraryService: MyLibraryService) {
        self.myLibraryService = myLibraryService
    }

    func getNovelList(filterOption: LibraryFilterOption,
                      cursor: String?,
                      size: Int,
                      sortType: LibrarySortType) -> Single<MyLibraryEntity> {
        let userId = UserDefaults.standard.integer(forKey: StringLiterals.UserDefault.userId)
        var queryItem = MyLibraryNovelListQuery(
            size: size,
            sortType: sortType.queryValue,
            cursor: cursor)

        queryItem.isInterest = filterOption.interestedOption ? true : nil

        if !filterOption.readStatusOptions.isEmpty {
            queryItem.readStatuses = filterOption.readStatusOptions.map { $0.rawValue }
        }
        if !filterOption.genreOptions.isEmpty {
            queryItem.genres = filterOption.genreOptions.map { $0.rawValue }
        }
        // 연재상태는 단일 Bool. 정확히 1개 선택일 때만 전송(0·2개면 필터 없음)
        if filterOption.publicationStatusOptions.count == 1 {
            queryItem.isComplete = filterOption.publicationStatusOptions.first?.isCompleted
        }
        // 별점: 미등록만 보기 우선, 아니면 기본범위(0.0~5.0)가 아닐 때만 범위 전송
        if filterOption.notStarRatedOption {
            queryItem.unratedOnly = true
        } else if filterOption.minimumStarRateOption != 0.0 || filterOption.maximumStarRateOption != 5.0 {
            queryItem.ratingMin = Float(filterOption.minimumStarRateOption)
            queryItem.ratingMax = Float(filterOption.maximumStarRateOption)
        }
        if !filterOption.attractivePointOptions.isEmpty {
            queryItem.attractivePoints = filterOption.attractivePointOptions.map { $0.rawValue }
        }
        if !filterOption.keywordOptions.isEmpty {
            queryItem.keywords = filterOption.keywordOptions.map { $0.keywordName }
        }

        return myLibraryService.getNovelList(userId: userId, queryItem: queryItem).map { $0.toEntity() }
    }
}
