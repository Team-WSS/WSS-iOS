//
//  StringLiterals+Home.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/1/25.
//

import Foundation

extension StringLiterals {
    enum Home {
        enum Title {
            static let todayPopular = "+ 오늘의 발견 +"
            static let realtimePopular = "지금 뜨는 글"
            static let interest = "님의 관심글"
            static let notLoggedInInterest = "관심글"
            static let recommend = "이 웹소설은 어때요? (•̀ - •́ )ノ📚"
        }
        
        enum SubTitle {
            static let interest = "관심 등록한 작품의 최신 글이에요"
            static let recommend = "선호 장르를 기반으로 추천해드려요"
        }
        
        enum Login {
            static let induceTitle = "로그인하고 모든 기능을\n자유롭게 사용하세요!"
            static let loginButtonTitle = "로그인 하러가기"
            static let cancelButtonTitle = "닫기"
        }
        
        enum Unregister {
            enum Title {
                static let interest = "관심작품의 최신 소식을 모아서 볼 수 있어요.\n좋아하는 웹소설을 관심 등록 해볼까요?"
                static let recommend = "로맨스, 로판, 판타지, 현판 등\n선호장르를 기반으로 웹소설을 추천해드려요!"
                static let interestEmpty = "관심 등록한 작품과 관련된 글이 없어요"
            }
            
            enum ButtonTItle {
                static let interest = "관심작품 등록하기"
                static let recommend = "선호장르 설정하기"
            }
        }
        
        enum TodayPopular {
            static let feed = "님의 한마디"
            static let introduction = "작품 소개"
        }
        
        enum RealTimePopular {
            static let spoiler = "스포일러가 포함된 글 보기"
        }
        
        enum Interest {
            static let feed = "님의 한마디"
            static let empty = "관심 등록한 작품과 관련된 글이 없어요"
        }
    }
}
