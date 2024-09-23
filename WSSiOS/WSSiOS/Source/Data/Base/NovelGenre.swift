//
//  NovelGenre.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/29/24.
//

import Foundation

enum OldNovelGenre: String {
    case romanceFantasy, romance, fantasy, modernFantasy, drama, lightNovel, wuxia, mystery, BL, error
    
    var genreText: String {
        switch self {
        case .romanceFantasy: return "로판"
        case .romance: return "로맨스"
        case .fantasy: return "판타지"
        case .modernFantasy: return "현판"
        case .drama: return "드라마"
        case .lightNovel: return "라노벨"
        case .wuxia: return "무협"
        case .mystery: return "미스터리"
        case .BL: return "BL"
        case .error: return "error"
        }
    }
}

enum NovelGenre: String, CaseIterable {
    case romance, romanceFantasy, fantasy, modernFantasy, wuxia, BL, lightNovel, mystery, drama
    
    var toKorean: String {
        switch self {
        case .romanceFantasy:
            return "로판"
        case .romance:
            return "로맨스"
        case .fantasy:
            return "판타지"
        case .modernFantasy:
            return "현판"
        case .drama:
            return "드라마"
        case .lightNovel:
            return "라노벨"
        case .wuxia:
            return "무협"
        case .mystery:
            return "미스터리"
        case .BL:
            return "BL"
        }
    }
}

enum FeedGenre: String, CaseIterable {
    case all = "all"
    case fantasy = "fantasy"
    case modernFantasy = "modernFantasy"
    case wuxia = "wuxia"
    case drama = "drama"
    case mystery = "mystery"
    case lightNovel = "lightNovel"
    case romance = "romance"
    case romanceFantasy = "romanceFantasy"
    case bl = "bl"
    case etc = "etc"
    
    var withKorean: String {
        switch self {
        case .all:
            return "전체"
        case .fantasy:
            return "판타지"
        case .modernFantasy:
            return "현판"
        case .wuxia:
            return "무협"
        case .drama:
            return "드라마"
        case .mystery:
            return "미스터리"
        case .lightNovel:
            return "라노벨"
        case .romance:
            return "로맨스"
        case .romanceFantasy:
            return "로판"
        case .bl:
            return "BL"
        case .etc:
            return "기타"
        }
    }
}

enum NewNovelGenre: String, CaseIterable {
    case all = "all"
    case fantasy = "fantasy"
    case modernFantasy = "modernFantasy"
    case wuxia = "wuxia"
    case drama = "drama"
    case mystery = "mystery"
    case lightNovel = "lightNovel"
    case romance = "romance"
    case romanceFantasy = "romanceFantasy"
    case bl = "BL"
    case etc = "etc"
    case error = "error"
    
    var withKorean: String {
        switch self {
        case .all:
            return "전체"
        case .fantasy:
            return "판타지"
        case .modernFantasy:
            return "현판"
        case .wuxia:
            return "무협"
        case .drama:
            return "드라마"
        case .mystery:
            return "미스터리"
        case .lightNovel:
            return "라노벨"
        case .romance:
            return "로맨스"
        case .romanceFantasy:
            return "로판"
        case .bl:
            return "BL"
        case .etc:
            return "기타"
        case .error:
            return "error"
        }
    }
}

extension NewNovelGenre {
    static let feedEditGenres: [NewNovelGenre] = [.fantasy, .modernFantasy, .romance, .romanceFantasy, .wuxia, .drama, .mystery, .lightNovel, .bl, .etc]
}
