//
//  NovelGenre.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/29/24.
//

import UIKit

enum NovelGenre: String, CaseIterable {
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
            return "그 외"
        case .error:
            return "error"
        }
    }
    
    static func withKoreanRawValue(from genre: String) -> NovelGenre {
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
    
    var markImage: UIImage {
        switch self {
        case .fantasy:
            return .icGenremarkF
        case .modernFantasy:
            return .icGenremarkHF
        case .wuxia:
            return .icGenremarkMH
        case .drama:
            return .icGenremarkD
        case .mystery:
            return .icGenremarkMT
        case .lightNovel:
            return .icGenremarkLN
        case .romance:
            return .icGenremarkR
        case .romanceFantasy:
            return .icGenremarkRF
        case .bl:
            return .icGenremarkBL
        default :
            return .icGenremarkRF
        }
    }
    
    var linkImage: UIImage {
        switch self {
        case .fantasy:
            return .icGenreLinkF
        case .modernFantasy:
            return .icGenreLinkHF
        case .wuxia:
            return .icGenreLinkMH
        case .drama:
            return .icGenreD
        case .mystery:
            return .icGenreLinkMT
        case .lightNovel:
            return .icGenreLinkLN
        case .romance:
            return .icGenreLinkR
        case .romanceFantasy:
            return .icGenreLinkRF
        case .bl:
            return .icGenreLinkBL
        default :
            return .icGenreLinkR
        }
    }
    
    var linkColor: UIColor {
        switch self {
        case .fantasy:
            return UIColor.genreColorF
        case .modernFantasy:
            return UIColor.genreColorHF
        case .wuxia:
            return UIColor.genreColorMH
        case .drama:
            return UIColor.genreColorD
        case .mystery:
            return UIColor.genreColorMT
        case .lightNovel:
            return UIColor.genreColorLN
        case .romance:
            return UIColor.genreColorR
        case .romanceFantasy:
            return UIColor.genreColorRF
        case .bl:
            return UIColor.genreColorBL
        default :
            return UIColor.genreColorR
        }
    }
    
    var amplitudeEvent: AmplitudeEvent.Feed? {
        switch self {
        case .all:
            return AmplitudeEvent.Feed.feedAll
        case .fantasy:
            return AmplitudeEvent.Feed.feedF
        case .modernFantasy:
            return AmplitudeEvent.Feed.feedHF
        case .wuxia:
            return AmplitudeEvent.Feed.feedMH
        case .drama:
            return AmplitudeEvent.Feed.feedD
        case .mystery:
            return AmplitudeEvent.Feed.feedM
        case .lightNovel:
            return AmplitudeEvent.Feed.feedLN
        case .romance:
            return AmplitudeEvent.Feed.feedR
        case .romanceFantasy:
            return AmplitudeEvent.Feed.feedRF
        case .bl:
            return AmplitudeEvent.Feed.feedBL
        case .etc:
            return AmplitudeEvent.Feed.feedEtc
        default:
            return nil
        }
    }
}

extension NovelGenre {
    static let onboardingGenres: [NovelGenre] = [.romance, .romanceFantasy, .bl, .fantasy, .modernFantasy, .wuxia, .lightNovel, .drama, .mystery]
    static let feedMaleGenres: [NovelGenre] = [.all, .fantasy, .modernFantasy, .wuxia, .drama, .mystery, .lightNovel, .romance, .romanceFantasy, .bl, .etc]
    static let feedFemaleGenres: [NovelGenre] = [.all, .romance, .romanceFantasy, .bl, .fantasy, .modernFantasy, .wuxia, .drama, .mystery, .lightNovel, .etc]
    static let feedFilterGenres: [NovelGenre] = [.fantasy, .modernFantasy, .romance, .romanceFantasy, .wuxia, .mystery, .drama, .lightNovel, .bl, .etc]
    static let detailSearchGenres: [NovelGenre] = [.fantasy, .modernFantasy, .romance, .romanceFantasy, .wuxia, .mystery, .drama, .lightNovel, .bl]
    static let myPageEditGenres: [NovelGenre] = [.romance, .romanceFantasy, .fantasy, .modernFantasy, .wuxia, .bl, .lightNovel, .mystery, .drama]
}
