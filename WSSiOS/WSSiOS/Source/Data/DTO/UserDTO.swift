//
//  UserDTO.swift
//  WSSiOS
//
//  Created by 신지원 on 1/15/24.
//

import Foundation

public struct UserDTO: Decodable {
    public let userNickName: String
    public let userNovelCount, memoCount: Int
    
    public init(userNickName: String, userNovelCount: Int, memoCount: Int) {
        self.userNickName = userNickName
        self.userNovelCount = userNovelCount
        self.memoCount = memoCount
    }
}

//extension UserDTO {
//    func toEntity() -> WeatherModel {
//        return WeatherModel(
//            time: name,
//            place: sys.country,
//            weather: self.weather.first!.description,
//            temparature: self.main.temp,
//            maxTem: self.main.tempMax,
//            minTem: self.main.tempMin
//        )
//    }
