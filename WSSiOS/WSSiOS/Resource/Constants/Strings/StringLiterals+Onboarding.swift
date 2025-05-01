//
//  StringLiterals+Onboarding.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/1/25.
//

import Foundation

extension StringLiterals {
    enum Onboarding {
        static let nextButton = "다음으로"
        
        enum Success {
            static let title = "웹소소와 계약 완료!"
            static func description(name: String) -> String {
                return "\(name)님, 만나서 반가워요!"
            }
            static let completeButton = "웹소소 시작하기"
        }
        
        enum GenrePreference {
            static let title = "평소 즐겨보는 장르를 선택하세요"
            static let description = "선호 장르를 기반으로 웹소설을 추천해드려요"
            static let completeButton = "완료"
            static let skipButton = "건너뛰기"
        }
        
        enum BirthGender {
            static let title = "성별, 출생연도를 선택하세요"
            static let description = "해당 정보는 추천에 활용되며, 언제든 변경할 수 있어요"
            static let genderTitle = "성별"
            static let birthTitle = "출생연도"
            static let birthPlaceholder = "태어난 해를 입력하세요"
        }
        
        enum NickName {
            static let title = "닉네임을 입력하세요"
            static let description = "10자 이내의 닉네임을 입력해주세요"
            static let textFieldPlaceholder = "닉네임"
            static let duplicateCheckButton = "중복확인"
        }
        
        enum Login {
            static let skip = "회원가입 없이 둘러보기"
        }
    }
}
