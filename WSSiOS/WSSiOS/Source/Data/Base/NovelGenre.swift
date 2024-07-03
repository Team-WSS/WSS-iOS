//
//  NovelGenre.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/29/24.
//

import Foundation

enum NovelGenre: String {
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
