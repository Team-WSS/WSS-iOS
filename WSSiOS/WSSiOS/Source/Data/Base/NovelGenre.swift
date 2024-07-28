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
    case romance, romanceFantasy, fantasy, modernFantasy, wuxia, BL, lightNovel, mystery, drama, error
    
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
        case .error:
            return "error"
        }
    }
}

enum NovelKoreanGenre: String {
    case 로맨스, 로판, 판타지, 현판, 드라마, 라노벨, 무협, 미스터리, BL
    
    var toEnglish: String {
        switch self {
        case .로맨스:
            return "romance"
        case .로판:
            return "romanceFantasy"
        case .판타지:
            return "fantasy"
        case .현판:
            return "modernFantasy"
        case .드라마:
            return "drama"
        case .라노벨:
            return "lightNovel"
        case .무협:
            return "wuxia"
        case .미스터리:
            return "mystery"
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

enum FeedDetailGenre: String {
    case romance = "romance"
    case romanceFantasy = "romanceFantasy"
    case bl = "bl"
    case fantasy = "fantasy"
    case modernFantasy = "modernFantasy"
    case wuxia = "wuxia"
    case drama = "drama"
    case mystery = "mystery"
    case lightNovel = "lightNovel"
    case etc = "etc"
    
    var withKorean: String {
        switch self {
        case .romance:
            return "로맨스"
        case .romanceFantasy:
            return "로판"
        case .bl:
            return "BL"
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
        case .etc:
            return "기타"
        }
    }
}

enum FeedDetailWomanKoreanGenre: String, CaseIterable {
    case 로맨스 = "로맨스"
    case 로판 = "로판"
    case BL = "BL"
    case 판타지 = "판타지"
    case 현판 = "현판"
    case 무협 = "무협"
    case 드라마 = "드라마"
    case 미스터리 = "미스터리"
    case 라노벨 = "라노벨"
    case 기타 = "기타"
    
    var toEnglish: String {
        switch self {
        case .로맨스:
            return "romance"
        case .로판:
            return "romanceFantasy"
        case .BL:
            return "BL"
        case .판타지:
            return "fantasy"
        case .현판:
            return "modernFantasy"
        case .무협:
            return "wuxia"
        case .미스터리:
            return "mystery"
        case .드라마:
            return "drama"
        case .라노벨:
            return "lightNovel"
        case .기타:
            return "etc"
        }
    }
}

enum FeedDetailManKoreanGenre: String, CaseIterable {
    case 판타지 = "판타지"
    case 현판 = "현판"
    case 무협 = "무협"
    case 드라마 = "드라마"
    case 미스터리 = "미스터리"
    case 라노벨 = "라노벨"
    case 로맨스 = "로맨스"
    case 로판 = "로판"
    case BL = "BL"
    case 기타 = "기타"
    
    var toEnglish: String {
        switch self {
        case .판타지:
            return "fantasy"
        case .현판:
            return "modernFantasy"
        case .무협:
            return "wuxia"
        case .드라마:
            return "drama"
        case .미스터리:
            return "mystery"
        case .라노벨:
            return "lightNovel"
        case .로맨스:
            return "romance"
        case .로판:
            return "romanceFantasy"
        case .BL:
            return "BL"
        case .기타:
            return "etc"
        }
    }
}
