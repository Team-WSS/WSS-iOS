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
    
    /// 버킷 이미지 URL 생성
    static func makeBucketImageURL(path: String) -> URL? {
        let bucketURL = Bundle.main.object(forInfoDictionaryKey: Config.Keys.Plist.bucketURL) as? String ?? "Error"
        let scale = Int(UITraitCollection.current.displayScale)
        
        return URL(string: "\(bucketURL)\(path)@\(scale)x.png")
    }
    
    /// http로 시작하는, 실제 이미지 URL인 경우 바로 반환, 그 외에는 버킷 이미지 URL 형태로 반환
    static func makeImageURLString(path: String) -> URL? {
        if path.hasPrefix("http") {
            return URL(string: path)
        } else {
            return makeBucketImageURL(path: path)
        }
    }
    
    /// 킹피셔 에러를 Observable에 담아 반환하기 위한 메서드
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
