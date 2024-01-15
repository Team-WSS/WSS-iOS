//
//  MyPageViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 1/10/24.
//

import Foundation

public struct MyPageViewModel: Decodable {
    public let userNickName: String
    public let userNovelCount, memoCount: Int
    
    public init(userNickName: String, userNovelCount: Int, memoCount: Int) {
        self.userNickName = userNickName
        self.userNovelCount = userNovelCount
        self.memoCount = memoCount
    }
}
