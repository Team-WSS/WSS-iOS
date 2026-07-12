//
//  LibrarySortType.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/22/26.
//

import Foundation

/// 마이라이브러리 서재 목록 전용 정렬.
/// 공유 타입 `SortType`(RECENT/OLD)과 별개로 분리해, 서재에서만 쓰는 6종 정렬을 다룬다.
enum LibrarySortType: Int, CaseIterable {
    case createdDesc
    case createdAsc
    case title
    case date
    case ratingDesc
    case ratingAsc

    /// 사용자 노출 텍스트 (정렬 버튼 라벨 / 바텀시트 행)
    var text: String {
        switch self {
        case .createdDesc: return "등록 최신순"
        case .createdAsc: return "등록 오래된순"
        case .title: return "제목순"
        case .date: return "날짜순"
        case .ratingDesc: return "별점 높은순"
        case .ratingAsc: return "별점 낮은순"
        }
    }

    /// 서버 v2 sortType 쿼리 토큰 (v2 API 연결 단계에서 사용)
    var queryValue: String {
        switch self {
        case .createdDesc: return "created_desc"
        case .createdAsc: return "created_asc"
        case .title: return "title" // TODO: 백엔드 토큰 확정 필요 (v2 스펙 미정의)
        case .date: return "read_date"
        case .ratingDesc: return "rating_desc"
        case .ratingAsc: return "rating_asc"
        }
    }

    static func fromText(_ text: String) -> LibrarySortType? {
        return LibrarySortType.allCases.first { $0.text == text }
    }
}
