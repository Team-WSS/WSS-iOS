//
//  StringLiterals.swift
//  WSSiOS
//
//  Created by 신지원 on 1/7/24.
//

import Foundation

enum StringLiterals {
    
    enum Tabbar {
        enum Title {
            static let home = "홈"
            static let library = "서재"
            static let record = "기록"
            static let myPage = "MY"
        }
    }
    
    enum Register {
        enum Normal {
            static let new = "내 서재에 등록"
            static let edit = "수정 완료"
        }
        enum Success {
            static let title = "내 서재에 작품이\n성공적으로 등록되었어요!"
            static let lottie = "animationRegistration"
            static let makeMemo = "작품에 메모 남기기"
            static let returnHome = "홈으로 돌아가기"
        }
    }
}
