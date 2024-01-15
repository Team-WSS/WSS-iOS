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
    static let testToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3MDUxOTM1MjcsImV4cCI6MTcwNjA1NzUyNywidXNlcklkIjoyfQ.vsPDHz3oz28DUEq5HsoNsEVp9ISOgHL7W636kT836LA"
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
