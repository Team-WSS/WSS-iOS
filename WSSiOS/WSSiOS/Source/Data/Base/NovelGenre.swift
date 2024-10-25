//
//  NovelGenre.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/29/24.
//

import UIKit

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
    
    static func withKoreanRawValue(from genre: String) -> NewNovelGenre {
        switch genre {
        case "전체":
            return .all
        case "판타지":
            return .fantasy
        case "현판":
            return .modernFantasy
        case "무협":
            return .wuxia
        case  "드라마":
            return .drama
        case "미스터리":
            return .mystery
        case "라노벨":
            return .lightNovel
        case "로맨스":
            return .romance
        case "로판":
            return .romanceFantasy
        case  "BL":
            return .bl
        case "기타":
            return .etc
        default :
            return .error
        }
    }
    
    var image: UIImage {
        switch self {
        case .fantasy:
            return .icGenreF
        case .modernFantasy:
            return .icGenreHF
        case .wuxia:
            return .icGenreMH
        case .drama:
            return .icGenreD
        case .mystery:
            return .icGenreMT
        case .lightNovel:
            return .icGenreLN
        case .romance:
            return .icGenreR
        case .romanceFantasy:
            return .icGenreRF
        case .bl:
            return .icGenreBL
        default :
            return .icGenreRF
        }
    }
}

extension NewNovelGenre {
    static let feedEditGenres: [NewNovelGenre] = [.fantasy, .modernFantasy, .romance, .romanceFantasy, .wuxia, .drama, .mystery, .lightNovel, .bl, .etc]
    static let onboardingGenres: [NewNovelGenre] = [.romance, .romanceFantasy, .bl, .fantasy, .modernFantasy, .wuxia, .lightNovel, .drama, .mystery]
}
