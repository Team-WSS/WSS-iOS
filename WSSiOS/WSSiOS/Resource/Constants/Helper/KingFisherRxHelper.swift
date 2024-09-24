//
//  KingFisherRxHelper.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/24/24.
//


import UIKit

import Kingfisher
import RxSwift

final class KingFisherRxHelper {
    private init() {}
    static let shared = KingFisherRxHelper()
    
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
