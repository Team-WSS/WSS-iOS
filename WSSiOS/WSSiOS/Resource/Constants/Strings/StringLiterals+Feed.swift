//
//  StringLiterals+Feed.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/1/25.
//

import Foundation

extension StringLiterals {
    enum FeedEdit {
        static let complete = "완료"
        static let edit = "수정"
        static let setPrivate = "나만 보는 기록"
        
        enum Category {
            static let category = "기록 작성"
            static let multipleSelect = "장르는 여러 개 선택할 수 있어요."
        }
        
        enum Content {
            static let writeContent = "작품에 대한 이야기"
            static let spoiler = "스포일러"
            static let placeHolder = "웹소설과 관련된 글을 자유롭게 남겨보세요\n\n • 작품에 대한 한줄평\n • 여운이 남는 명장면, 명대사\n • 수다 떨고 싶은 작품 이야기\n • 다른 독자들과 공유하고 싶은 작품 정보 등"
        }
        
        enum Novel {
            static let novelConnect = "작품 연결"
            static let novelConnectSub = "연결한 작품의 피드에도 함께 등록돼요."
            static let novelSearch = "작품 제목, 작가로 검색하기"
            static let novelSelect = "작성 중인 글과 관련된 웹소설을 선택하세요"
            static let connectSelectedNovel = "해당 작품 연결"
        }
        
        enum Alert {
            static let titleText = "글 작성을 그만하시겠어요?"
            static let writeTitle = "계속 작성"
            static let stopTitle = "그만하기"
        }
    }
    
    enum Feed {
        static let spoilerText = "스포일러가 포함된 글 보기"
        static let modifiedText = "(수정됨)"
        static let isPrivate = "나만 보는 기록이에요."
    }
    
    enum FeedDetail {
        static let title = "게시글"
        static let reply = "댓글"
        static let placeHolder = "댓글을 남겨보세요"
        
        static let edit = "수정하기"
        
        static let delete = "삭제하기"
        static let deleteTitle = "해당 글을 삭제할까요?"
        static let deleteContent = "삭제한 글은 되돌릴 수 없어요"
        
        static let cancel = "취소"
        static let report = "신고"
        static let confirm = "확인"
        
        static let reportSpoiler = "스포일러 신고"
        static let spoilerTitle = "해당 글이 스포일러를\n포함하고 있나요?"
        
        static let reportImpertinence = "부적절한 표현 신고"
        static let impertinentTitle = "해당 글에 부적절한 표현이\n사용되었나요?"
        static let impertinentContent = "해당 글이 커뮤니티 가이드를\n위반했는지 검토할게요"
        
        static let reportResult = "신고가 접수되었어요!"
        
        static let deleteMineTitle = "내 댓글을 삭제할까요?"
        static let deleteMineContent = "삭제한 댓글은 되돌릴 수 없어요"
        
        static let hiddenComment = "숨김 처리된 댓글"
        static let spoilerComment = "스포일러가 포함된 댓글 보기"
        static let blckedUser = "차단한 유저"
        static let blockedComment = "차단한 유저의 댓글"
        
        static let notFoundFeed = "해당 글을 찾을 수 없어요"
        static let totalStarTitle = "전체"
    }
}
