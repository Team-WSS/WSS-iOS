//
//  FeedTab.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/22/25.
//

enum FeedTab: CaseIterable {
    case my
    case soso
    
    var name: String {
        switch self {
        case .my: "내 피드"
        case .soso: "소소피드"
        }
    }
}

enum SosoFeedTab {
    case all
    case recommended
}

