//
//  NovelPlatform.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/6/26.
//

import Foundation

enum NovelPlatform: CaseIterable {
    case kakao
    case naver
    case ridi
    case moonpia
    case novelpia

    var title: String {
        switch self {
        case .kakao:    "카카오페이지"
        case .naver:    "네이버시리즈"
        case .ridi:     "리디"
        case .moonpia:  "문피아"
        case .novelpia: "노벨피아"
        }
    }
}

extension NovelPlatform {
    static let detailSearchPlatforms: [NovelPlatform] = [.kakao, .naver, .ridi, .moonpia, .novelpia]
}
