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
    static let testToken = Bundle.main.object(forInfoDictionaryKey: Config.Keys.Plist.testToken) as? String ?? ""
}

extension APIConstants {
    static var noTokenHeader: Dictionary<String, String> {
        [contentType: applicationJSON]
    }
    
    static var testTokenHeader: Dictionary<String, String> {
        [contentType: applicationJSON,
                auth: "Bearer " + testToken]
    }
}
