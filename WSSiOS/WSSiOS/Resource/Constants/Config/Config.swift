//
//  Config.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

enum Config {
    enum Keys {
        enum Plist {
            static let baseURL = "BASE_URL"
            static let testToken = "TEST_TOKEN"
            static let bucketURL = "BUCKET_URL"
            static let kakaoAppKey = "KAKAO_APP_KEY"
            static let appStoreID = "APPSTORE_ID"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist cannot found.")
        }
        return dict
    }()
}
