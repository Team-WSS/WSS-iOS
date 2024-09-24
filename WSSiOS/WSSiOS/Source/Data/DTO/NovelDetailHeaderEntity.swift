//
//  NovelDetailHeaderEntity.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/22/24.
//

import UIKit
import Kingfisher
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


//extension NovelDetailHeaderResult {
//    func transform() throws -> NovelDetailHeaderEntity {
//        do {
//            let novelImage = try KingFisherErrorManager.kingFisherImage(urlString: novelImage)
//            let novelGenreImage = try KingFisherErrorManager.kingFisherImage(urlString: novelGenreImage)
//            let novelCompletion = isNovelCompleted ? StringLiterals.NovelDetail.Header.complete
//                                                   : StringLiterals.NovelDetail.Header.inSeries
//            let interestCountText = "\(interestCount)"
//            let novelRatingText = "\(novelRating) (\(novelRatingCount))"
//            let feedCountText = "\(feedCount)"
//            
//            let isUserNovelRatingExist = !userNovelRating.isZero
//            let userNovelRatingText = isUserNovelRatingExist ? "\(userNovelRating)"
//                                                             : nil
//            let readStatus = ReadStatus(rawValue: readStatus ?? "")
//            
//            let isReadDateExist = startDate != nil || endDate != nil
//            
//            var readDateText = "~"
//            if let startDate {
//                readDateText = "\(startDate) " + readDateText
//            }
//            if let endDate {
//                readDateText = readDateText + " \(endDate)"
//            }
//            
//            return NovelDetailHeaderEntity(
//                userNovelID: userNovelID,
//                novelTitle: novelTitle,
//                novelImage: novelImage,
//                novelGenre: novelGenres,
//                novelGenreImage: novelGenreImage,
//                novelCompletion: novelCompletion,
//                novelAuthor: author,
//                interestCountText: interestCountText,
//                novelRatingText: novelRatingText,
//                feedCountText: feedCountText,
//                isUserNovelRatingExist: isUserNovelRatingExist,
//                userNovelRatingText: userNovelRatingText,
//                readStatus: readStatus,
//                isReadDateExist: isReadDateExist,
//                readDateText: readDateText,
//                isUserNovelInterest: isUserNovelInterest
//                )
//        } catch {
//            throw error
//        }
//    }
//}
//
//class KingFisherErrorManager {
//    private init() {}
//    private let shared = KingFisherErrorManager()
//    
//    static func kingFisherImage(urlString: String) throws -> UIImage {
//        guard let novelImageUrl = URL(string: urlString) else {
//            throw NetworkServiceError.invalidURLError
//        }
//        
//        var image: UIImage? = nil
//        var kingFisherError: KingfisherError? = nil
//        
//        KingfisherManager.shared.retrieveImage(with: novelImageUrl,
//                                               completionHandler: { result in
//            switch(result) {
//            case .success(let imageResult):
//                image = imageResult.image
//            case .failure(let error):
//                image = nil
//                kingFisherError = error
//            }
//        })
//        
//        guard let image else {
//            throw kingFisherError ?? .requestError(reason: .emptyRequest)
//        }
//        
//        return image
//    }
//}
//
//
//

final class KingFisherErrorManager {
    private init() {}
    static let shared = KingFisherErrorManager()
    
    static func makeBucketImageURL(path: String) -> URL? {
        let bucketURL = Bundle.main.object(forInfoDictionaryKey: Config.Keys.Plist.bucketURL) as? String ?? "Error"
        let scale = Int(UITraitCollection.current.displayScale)
        
        return URL(string: "\(bucketURL)\(path)@\(scale)x.png")
    }
    
    static func makeImageURLString(path: String) -> URL? {
        if path.hasPrefix("http") {
            return URL(string: path)
        } else {
            return makeBucketImageURL(path: path)
        }
    }
    
    static func kingFisherImage(urlString: String) -> Observable<UIImage> {
        return Observable.create { observer in
            
            guard let url = makeImageURLString(path: urlString) else {
                observer.onError(NetworkServiceError.invalidURLError)
                return Disposables.create()
            }
            
            let task = KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let imageResult):
                    observer.onNext(imageResult.image)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                task?.cancel()
            }        }
    }
}

// Usage in transform() method
extension NovelDetailHeaderResult {
    func transform() -> Observable<NovelDetailHeaderEntity> {
        return Observable.zip(
            KingFisherErrorManager
                .kingFisherImage(urlString: novelImage),
            KingFisherErrorManager
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
