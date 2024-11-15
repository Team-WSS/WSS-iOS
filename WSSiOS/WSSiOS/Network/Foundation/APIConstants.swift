//
//  APIConstants.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

struct APIConstants {
    static let contentType = "Content-Type"
    static let applicationJSON = "application/json"
    static let multipartFormData = "multipart/form"
    static let auth = "Authorization"
    static let refresh = "RefreshToken"
    static let fcm = "FcmToken"
    
    static let boundary = "Boundary-\(UUID().uuidString)"
    
    static let kakaoAppKey: String = Bundle.main.object(forInfoDictionaryKey: Config.Keys.Plist.kakaoAppKey) as? String ?? ""
    
    // Config의 Test Token을 사용한다면, 이 값을 true로,
    // UserDefaults의 실제 토큰 값을 쓰려면 이 값을 false로 바꿀 것.
    static let isTesting: Bool = false
    
    static var isRegister: Bool {
        UserDefaults.standard.bool(forKey: StringLiterals.UserDefault.isRegister)
    }
    
    static var isLogined: Bool {
        !accessToken.isEmpty
    }
    static var accessToken: String {
        isTesting ? testToken : UserDefaults.standard.value(forKey: StringLiterals.UserDefault.accessToken) as? String ?? ""
    }
    static var testToken: String = Bundle.main.object(forInfoDictionaryKey: Config.Keys.Plist.testToken) as? String ?? ""
}

extension APIConstants {
    static var noTokenHeader: Dictionary<String, String> {
        [contentType: applicationJSON]
    }
    
    static var accessTokenHeader: Dictionary<String, String> {
        [contentType: applicationJSON,
                auth: "Bearer " + accessToken]
    }
    
    static func kakaoLoginHeader(_ kakaoAccessToken: String) -> Dictionary<String, String> {
        [contentType: applicationJSON,
         "Kakao-Access-Token": kakaoAccessToken]
    }
}
