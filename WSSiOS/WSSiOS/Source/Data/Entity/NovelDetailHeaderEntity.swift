//
//  NovelDetailHeaderEntity.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/22/24.
//

import UIKit

import RxSwift

struct NovelDetailHeaderEntity {
    let userNovelID: Int?
    let novelTitle: String
    let novelImage: UIImage
    let novelGenre: String
    let novelGenreImage: UIImage
    let novelCompletion: String
    let novelAuthor: String
    let interestCountText: String
    let novelRatingText: String
    let feedCountText: String
    let isUserNovelRatingExist: Bool
    let userNovelRatingText: String
    let readStatus: ReadStatus?
    let isReadDateExist: Bool
    let readDateText: String
    let isUserNovelInterest: Bool
}

extension NovelDetailHeaderResult {
    func transform() -> Observable<NovelDetailHeaderEntity> {
        return Observable.zip(
            KingFisherRxHelper
                .kingFisherImage(urlString: novelImage),
            KingFisherRxHelper
                .kingFisherImage(urlString: novelGenreImage)
        ).map { novelImage, novelGenreImage in
            let novelCompletion = isNovelCompleted ? StringLiterals.NovelDetail.Header.complete
                                                   : StringLiterals.NovelDetail.Header.inSeries
            let interestCountText = "\(interestCount)"
            let novelRatingText = "\(novelRating) (\(novelRatingCount))"
            let feedCountText = "\(feedCount)"
            let isUserNovelRatingExist = !userNovelRating.isZero
            let userNovelRatingText = "\(userNovelRating)"
            let readStatus = ReadStatus(rawValue: readStatus ?? "")
            let isReadDateExist = startDate != nil || endDate != nil
            let readDateText = [startDate, "~", endDate]
                .compactMap { $0 }
                .joined(separator: " ")
            
            return NovelDetailHeaderEntity(
                userNovelID: userNovelID,
                novelTitle: novelTitle,
                novelImage: novelImage,
                novelGenre: novelGenres,
                novelGenreImage: novelGenreImage,
                novelCompletion: novelCompletion,
                novelAuthor: author,
                interestCountText: interestCountText,
                novelRatingText: novelRatingText,
                feedCountText: feedCountText,
                isUserNovelRatingExist: isUserNovelRatingExist,
                userNovelRatingText: userNovelRatingText,
                readStatus: readStatus,
                isReadDateExist: isReadDateExist,
                readDateText: readDateText,
                isUserNovelInterest: isUserNovelInterest
            )
        }
    }
}
