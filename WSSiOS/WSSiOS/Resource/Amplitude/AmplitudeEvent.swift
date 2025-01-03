//
//  AmplitudeEvent.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 12/31/24.
//

import Foundation

enum AmplitudeEvent {
    
    // MARK: - 온보딩
    enum Onboarding: String {
        case nonLogin = "non_login" // 비로그인으로 둘러보기 클릭
    }
    
    // MARK: - 홈
    enum Home: String {
        case home = "home" // 홈 화면 진입
        case homeTodayRanking = "home_today_ranking" // 오늘의 인기작 클릭
        case homeHotFeedlist = "home_hot_feedlist" // 지금 뜨는 수다글 클릭
        case homeToLoveButton = "home_to_love_btn" // 관심 등록 유도 버튼 클릭
        case homeLoveFeedlist = "home_love_feedlist" // 관심글 클릭
        case homeToPreferButton = "home_to_prefer_btn" // 선호 장르 유도 버튼 클릭
        case homePreferNovellist = "home_prefer_novellist" // 선호장르 추천 작품 클릭
    }
    
    // MARK: - 탐색
    enum Search: String {
        case search = "search" // 탐색 (탭바 두번째) 진입
        case generalSearch = "general_search" // 탐색 서치바 클릭
        case clickSearchResult = "click_search_result" // 검색 결과 클릭
        case contactNovelSearch = "contact_novel_search" // 검색 결과 없을 때, 작품 문의하러 가기 클릭
        case seek = "seek" // “내 취향에 맞는 웹소설 찾기” 버튼 클릭
        case contactKeyword = "contact_keyword" // 탐색 > 키워드 > 키워드 문의하러 가기 버튼 클릭
        case seekResult = "seek_result" // 탐색 결과
        case clickSeekResult = "click_seek_result" // 탐색 결과 클릭
        case sosoPick = "soso_pick" // 소소 pick! 에서 작품 클릭
    }
    
    // MARK: - 작품
    enum Novel: String {
        case novelInfo = "novel_info" // 작품 상세 > 정보 진입
        case directNovel = "direct_novel" // 작품 보러가기 클릭
        case contactError = "contact_error" // 작품 > 더보기 > 오류 제보 클릭
        case rateLove = "rate_love" // 작품 > 관심 클릭
        case rate = "rate" // 작품 평가 뷰 진입
        case rateNovel = "rate_novel" // 작품 평가 완료했을 때
        case rateDelete = "rate_delete" // 작품 평가 > 더보기 > 평가 삭제 클릭
        case novelFeed = "novel_feed" // 작품 상세 > 수다 진입 or 수다 탭 클릭
        case novelWriteButton = "novel_write_btn" // 작품 상세 > 나도 한마디 클릭
        case novelWriteFloatingButton = "novel_write_floating_btn" // 작품 상세 > 수다 > 글쓰기 플로팅 버튼 클릭
    }
    
    // MARK: - 수다
    enum Feed: String {
        case feedAll = "feed_all" // 소소한수다 화면 진입
        case feedWriteFloatingButton = "feed_write_floating_btn" // 수다 > 글쓰기 플로팅 버튼 클릭
        case feedLike = "feed_like" // 소소한수다에서 좋아요 클릭
        case feedR = "feed_R" // 소소한수다 > 로맨스 장르탭
        case feedRF = "feed_RF" // 소소한수다 > 로판 장르탭
        case feedF = "feed_F" // 소소한수다 > 판타지 장르탭
        case feedHF = "feed_HF" // 소소한수다 > 현판 장르탭
        case feedMH = "feed_MH" // 소소한수다 > 무협 장르탭
        case feedBL = "feed_BL" // 소소한수다 > BL 장르탭
        case feedD = "feed_D" // 소소한수다 > 드라마 장르탭
        case feedM = "feed_M" // 소소한수다 > 미스터리 장르탭
        case feedLN = "feed_LN" // 소소한수다 > 라노벨 장르탭
        case feedEtc = "feed_etc" // 소소한수다 > 기타 장르탭
        case feedDetail = "feed_detail" // 피드 상세보기 화면 진입
        case feedDetailLike = "feed_detail_like" // 피드 좋아요 클릭
        case write = "write" // 글 작성 뷰 진입 시
        case contactNovelConnect = "contact_novel_connect" // 글 작성 > 작품 연결하기 > 결과 없을 때 작품 문의하기 버튼 클릭
        case writeFeed = "write_feed" // 글 작성 완료했을 때
        case writeComment = "write_comment" // 댓글을 작성했을 때 = 보내기 버튼 클릭
        case alertFeedSpoiler = "alert_feed_spoiler" // 게시글 스포일러 신고했을 때
        case alertFeedAbuse = "alert_feed_abuse" // 게시글 부적절한 표현 신고했을 때
        case alertCommentSpoiler = "alert_comment_spoiler" // 댓글 스포 신고했을 때
        case alertCommentAbuse = "alert_comment_abuse" // 게시글 부적절한 표현 신고했을 때
    }
    
    // MARK: - 마이페이지
    enum MyPage: String {
        case mypage = "mypage" // 마이페이지 화면 진입
        case logout = "logout" // 로그아웃 버튼 클릭
        case otherMypage = "other_mypage" // 타유저 마이페이지 화면 진입
        case otherBlock = "other_block" // 타유저 차단 버튼 클릭
        case withdraw = "withdraw" // 회원탈퇴 버튼 클릭
    }
}
