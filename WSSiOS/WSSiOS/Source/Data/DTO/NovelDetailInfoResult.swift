//
//  NovelDetailInfoResult.swift
//  WSSiOS
//
//  Created by 이윤학 on 6/25/24.
//

import Foundation

struct NovelDetailInfoResult: Codable {
    let novelDescription: String
    let platforms: [Platform]
    let attractivePoints: [String]
    let keywords: [Keyword]
    let watchingCount, watchedCount, quitCount: Int
}

struct Keyword: Codable {
    let keywordName: String
    let keywordCount: Int
}

struct Platform: Codable {
    let platformName, platformImage, platformURL: String
    
    enum CodingKeys: String, CodingKey {
        case platformName
        case platformImage
        case platformURL = "platformUrl"
    }
}

extension NovelDetailInfoResult {
    static let dummyFullData = [
        NovelDetailInfoResult(
            novelDescription: "대통령으로 선거될 수 있는 자는 국회의원의 피선거권이 있고 선거일 현재 40세에 달하여야 한다. 군인 또는 군무원이 아닌 국민은 대한민국의 영역안에서는 중대한 군사상 기밀·초병·초소·유독음식물공급·포로·군용물에 관한 죄중 법률이 정한 경우와 비상계엄이 선포된 경우를 제외하고는 군사법원의 재판을 받지 아니한다.\n\n국채를 모집하거나 예산외에 국가의 부담이 될 계약을 체결하려 할 때에는 정부는 미리 국회의 의결을 얻어야 한다. 국무회의는 대통령·국무총리와 15인 이상 30인 이하의 국무위원으로 구성한다. 헌법재판소의 조직과 운영 기타 필요한 사항은 법률로 정한다.\n\n훈장등의 영전은 이를 받은 자에게만 효력이 있고, 어떠한 특권도 이에 따르지 아니한다. 위원은 탄핵 또는 금고 이상의 형의 선고에 의하지 아니하고는 파면되지 아니한다.\n\n국민경제의 발전을 위한 중요정책의 수립에 관하여 대통령의 자문에 응하기 위하여 국민경제자문회의를 둘 수 있다.\n\n대통령은 법률이 정하는 바에 의하여 훈장 기타의 영전을 수여한다. 법률안에 이의가 있을 때에는 대통령은 제1항의 기간내에 이의서를 붙여 국회로 환부하고, 그 재의를 요구할 수 있다. 국회의 폐회중에도 또한 같다.",
            platforms: [Platform(platformName: "네이버시리즈",
                                 platformImage: "/platform/naver-series",
                                 platformURL: "https://namu.wiki/w/당신의%20이해를%20돕기%20위하여"),
                        Platform(platformName: "카카오페이지",
                                 platformImage: "/platform/naver-series",
                                 platformURL: "https://page.kakao.com/content/53706168")],
            attractivePoints: ["캐릭터",
                               "관계",
                               "소재"],
            keywords: [Keyword(keywordName: "서양풍/중세시대",
                               keywordCount: 7),
                       Keyword(keywordName: "웹툰화",
                               keywordCount: 5),
                       Keyword(keywordName: "동양풍/사극",
                               keywordCount: 3),
                       Keyword(keywordName: "실존역사",
                               keywordCount: 2),
                       Keyword(keywordName: "현대",
                               keywordCount: 2)],
            watchingCount: 130,
            watchedCount: 10,
            quitCount: 100)
    ]
    
    static let dummyOneEmptyData = [
        NovelDetailInfoResult(
            novelDescription:"대통령으로 선거될 수 있는 자는 국회의원의 피선거권이 있고 선거일 현재 40세에 달하여야 한다. 군인 또는 군무원이 아닌 국민은 대한민국의 영역안에서는 중대한 군사상 기밀·초병·초소·유독음식물공급·포로·군용물에 관한 죄중 법률이 정한 경우와 비상계엄이 선포된 경우를 제외하고는 군사법원의 재판을 받지 아니한다.\n\n국채를 모집하거나 예산외에 국가의 부담이 될 계약을 체결하려 할 때에는 정부는 미리 국회의 의결을 얻어야 한다. 국무회의는 대통령·국무총리와 15인 이상 30인 이하의 국무위원으로 구성한다. 헌법재판소의 조직과 운영 기타 필요한 사항은 법률로 정한다.\n\n훈장등의 영전은 이를 받은 자에게만 효력이 있고, 어떠한 특권도 이에 따르지 아니한다. 위원은 탄핵 또는 금고 이상의 형의 선고에 의하지 아니하고는 파면되지 아니한다.\n\n국민경제의 발전을 위한 중요정책의 수립에 관하여 대통령의 자문에 응하기 위하여 국민경제자문회의를 둘 수 있다.\n\n대통령은 법률이 정하는 바에 의하여 훈장 기타의 영전을 수여한다. 법률안에 이의가 있을 때에는 대통령은 제1항의 기간내에 이의서를 붙여 국회로 환부하고, 그 재의를 요구할 수 있다. 국회의 폐회중에도 또한 같다.",
            platforms: [Platform(platformName: "네이버시리즈",
                                 platformImage: "/platform/naver-series",
                                 platformURL: "https://namu.wiki/w/당신의%20이해를%20돕기%20위하여"),
                        Platform(platformName: "카카오페이지",
                                 platformImage: "/platform/naver-series",
                                 platformURL: "https://page.kakao.com/content/53706168")],
            attractivePoints: [],
            keywords: [Keyword(keywordName: "서양풍/중세시대",
                               keywordCount: 7),
                       Keyword(keywordName: "웹툰화",
                               keywordCount: 5),
                       Keyword(keywordName: "동양풍/사극",
                               keywordCount: 3),
                       Keyword(keywordName: "실존역사",
                               keywordCount: 2),
                       Keyword(keywordName: "현대",
                               keywordCount: 2)],
            watchingCount: 10,
            watchedCount: 130,
            quitCount: 100),
        NovelDetailInfoResult(
            novelDescription: "대통령으로 선거될 수 있는 자는 국회의원의 피선거권이 있고 선거일 현재 40세에 달하여야 한다. 군인 또는 군무원이 아닌 국민은 대한민국의 영역안에서는 중대한 군사상 기밀·초병·초소·유독음식물공급·포로·군용물에 관한 죄중 법률이 정한 경우와 비상계엄이 선포된 경우를 제외하고는 군사법원의 재판을 받지 아니한다.\n\n국채를 모집하거나 예산외에 국가의 부담이 될 계약을 체결하려 할 때에는 정부는 미리 국회의 의결을 얻어야 한다. 국무회의는 대통령·국무총리와 15인 이상 30인 이하의 국무위원으로 구성한다. 헌법재판소의 조직과 운영 기타 필요한 사항은 법률로 정한다.\n\n훈장등의 영전은 이를 받은 자에게만 효력이 있고, 어떠한 특권도 이에 따르지 아니한다. 위원은 탄핵 또는 금고 이상의 형의 선고에 의하지 아니하고는 파면되지 아니한다.\n\n국민경제의 발전을 위한 중요정책의 수립에 관하여 대통령의 자문에 응하기 위하여 국민경제자문회의를 둘 수 있다.\n\n대통령은 법률이 정하는 바에 의하여 훈장 기타의 영전을 수여한다. 법률안에 이의가 있을 때에는 대통령은 제1항의 기간내에 이의서를 붙여 국회로 환부하고, 그 재의를 요구할 수 있다. 국회의 폐회중에도 또한 같다.",
            platforms: [Platform(platformName: "네이버시리즈",
                                 platformImage: "/platform/naver-series",
                                 platformURL: "https://namu.wiki/w/당신의%20이해를%20돕기%20위하여"),
                        Platform(platformName: "카카오페이지",
                                 platformImage: "/platform/naver-series",
                                 platformURL: "https://page.kakao.com/content/53706168")],
            attractivePoints: ["캐릭터",
                               "관계",
                               "소재"],
            keywords: [],
            watchingCount: 10,
            watchedCount: 100,
            quitCount: 130),
        NovelDetailInfoResult(
            novelDescription: "대통령으로 선거될 수 있는 자는 국회의원의 피선거권이 있고 선거일 현재 40세에 달하여야 한다. 군인 또는 군무원이 아닌 국민은 대한민국의 영역안에서는 중대한 군사상 기밀·초병·초소·유독음식물공급·포로·군용물에 관한 죄중 법률이 정한 경우와 비상계엄이 선포된 경우를 제외하고는 군사법원의 재판을 받지 아니한다.\n\n국채를 모집하거나 예산외에 국가의 부담이 될 계약을 체결하려 할 때에는 정부는 미리 국회의 의결을 얻어야 한다. 국무회의는 대통령·국무총리와 15인 이상 30인 이하의 국무위원으로 구성한다. 헌법재판소의 조직과 운영 기타 필요한 사항은 법률로 정한다.\n\n훈장등의 영전은 이를 받은 자에게만 효력이 있고, 어떠한 특권도 이에 따르지 아니한다. 위원은 탄핵 또는 금고 이상의 형의 선고에 의하지 아니하고는 파면되지 아니한다.\n\n국민경제의 발전을 위한 중요정책의 수립에 관하여 대통령의 자문에 응하기 위하여 국민경제자문회의를 둘 수 있다.\n\n대통령은 법률이 정하는 바에 의하여 훈장 기타의 영전을 수여한다. 법률안에 이의가 있을 때에는 대통령은 제1항의 기간내에 이의서를 붙여 국회로 환부하고, 그 재의를 요구할 수 있다. 국회의 폐회중에도 또한 같다.",
            platforms: [Platform(platformName: "네이버시리즈",
                                 platformImage: "/platform/naver-series",
                                 platformURL: "https://namu.wiki/w/당신의%20이해를%20돕기%20위하여"),
                        Platform(platformName: "카카오페이지",
                                 platformImage: "/platform/naver-series",
                                 platformURL: "https://page.kakao.com/content/53706168")],
            attractivePoints: ["캐릭터",
                               "관계",
                               "소재"],
            keywords: [Keyword(keywordName: "서양풍/중세시대",
                               keywordCount: 7),
                       Keyword(keywordName: "웹툰화",
                               keywordCount: 5),
                       Keyword(keywordName: "동양풍/사극",
                               keywordCount: 3),
                       Keyword(keywordName: "실존역사",
                               keywordCount: 2),
                       Keyword(keywordName: "현대",
                               keywordCount: 2)],
            watchingCount: 0,
            watchedCount: 0,
            quitCount: 0)
    ]
    
    static let dummyTwoEmptyData = [
        NovelDetailInfoResult(
            novelDescription:"대통령으로 선거될 수 있는 자는 국회의원의 피선거권이 있고 선거일 현재 40세에 달하여야 한다. 군인 또는 군무원이 아닌 국민은 대한민국의 영역안에서는 중대한 군사상 기밀·초병·초소·유독음식물공급·포로·군용물에 관한 죄중 법률이 정한 경우와 비상계엄이 선포된 경우를 제외하고는 군사법원의 재판을 받지 아니한다.\n\n국채를 모집하거나 예산외에 국가의 부담이 될 계약을 체결하려 할 때에는 정부는 미리 국회의 의결을 얻어야 한다. 국무회의는 대통령·국무총리와 15인 이상 30인 이하의 국무위원으로 구성한다. 헌법재판소의 조직과 운영 기타 필요한 사항은 법률로 정한다.\n\n훈장등의 영전은 이를 받은 자에게만 효력이 있고, 어떠한 특권도 이에 따르지 아니한다. 위원은 탄핵 또는 금고 이상의 형의 선고에 의하지 아니하고는 파면되지 아니한다.\n\n국민경제의 발전을 위한 중요정책의 수립에 관하여 대통령의 자문에 응하기 위하여 국민경제자문회의를 둘 수 있다.\n\n대통령은 법률이 정하는 바에 의하여 훈장 기타의 영전을 수여한다. 법률안에 이의가 있을 때에는 대통령은 제1항의 기간내에 이의서를 붙여 국회로 환부하고, 그 재의를 요구할 수 있다. 국회의 폐회중에도 또한 같다.",
            platforms: [Platform(platformName: "네이버시리즈",
                                 platformImage: "/platform/naver-series",
                                 platformURL: "https://namu.wiki/w/당신의%20이해를%20돕기%20위하여"),
                        Platform(platformName: "카카오페이지",
                                 platformImage: "/platform/naver-series",
                                 platformURL: "https://page.kakao.com/content/53706168")],
            attractivePoints: [],
            keywords: [],
            watchingCount: 10,
            watchedCount: 130,
            quitCount: 100),
        NovelDetailInfoResult(
            novelDescription: "대통령으로 선거될 수 있는 자는 국회의원의 피선거권이 있고 선거일 현재 40세에 달하여야 한다. 군인 또는 군무원이 아닌 국민은 대한민국의 영역안에서는 중대한 군사상 기밀·초병·초소·유독음식물공급·포로·군용물에 관한 죄중 법률이 정한 경우와 비상계엄이 선포된 경우를 제외하고는 군사법원의 재판을 받지 아니한다.\n\n국채를 모집하거나 예산외에 국가의 부담이 될 계약을 체결하려 할 때에는 정부는 미리 국회의 의결을 얻어야 한다. 국무회의는 대통령·국무총리와 15인 이상 30인 이하의 국무위원으로 구성한다. 헌법재판소의 조직과 운영 기타 필요한 사항은 법률로 정한다.\n\n훈장등의 영전은 이를 받은 자에게만 효력이 있고, 어떠한 특권도 이에 따르지 아니한다. 위원은 탄핵 또는 금고 이상의 형의 선고에 의하지 아니하고는 파면되지 아니한다.\n\n국민경제의 발전을 위한 중요정책의 수립에 관하여 대통령의 자문에 응하기 위하여 국민경제자문회의를 둘 수 있다.\n\n대통령은 법률이 정하는 바에 의하여 훈장 기타의 영전을 수여한다. 법률안에 이의가 있을 때에는 대통령은 제1항의 기간내에 이의서를 붙여 국회로 환부하고, 그 재의를 요구할 수 있다. 국회의 폐회중에도 또한 같다.",
            platforms: [Platform(platformName: "네이버시리즈",
                                 platformImage: "/platform/naver-series",
                                 platformURL: "https://namu.wiki/w/당신의%20이해를%20돕기%20위하여"),
                        Platform(platformName: "카카오페이지",
                                 platformImage: "/platform/naver-series",
                                 platformURL: "https://page.kakao.com/content/53706168")],
            attractivePoints: ["캐릭터",
                               "관계",
                               "소재"],
            keywords: [],
            watchingCount: 0,
            watchedCount: 0,
            quitCount: 0),
        NovelDetailInfoResult(
            novelDescription: "대통령으로 선거될 수 있는 자는 국회의원의 피선거권이 있고 선거일 현재 40세에 달하여야 한다. 군인 또는 군무원이 아닌 국민은 대한민국의 영역안에서는 중대한 군사상 기밀·초병·초소·유독음식물공급·포로·군용물에 관한 죄중 법률이 정한 경우와 비상계엄이 선포된 경우를 제외하고는 군사법원의 재판을 받지 아니한다.\n\n국채를 모집하거나 예산외에 국가의 부담이 될 계약을 체결하려 할 때에는 정부는 미리 국회의 의결을 얻어야 한다. 국무회의는 대통령·국무총리와 15인 이상 30인 이하의 국무위원으로 구성한다. 헌법재판소의 조직과 운영 기타 필요한 사항은 법률로 정한다.\n\n훈장등의 영전은 이를 받은 자에게만 효력이 있고, 어떠한 특권도 이에 따르지 아니한다. 위원은 탄핵 또는 금고 이상의 형의 선고에 의하지 아니하고는 파면되지 아니한다.\n\n국민경제의 발전을 위한 중요정책의 수립에 관하여 대통령의 자문에 응하기 위하여 국민경제자문회의를 둘 수 있다.\n\n대통령은 법률이 정하는 바에 의하여 훈장 기타의 영전을 수여한다. 법률안에 이의가 있을 때에는 대통령은 제1항의 기간내에 이의서를 붙여 국회로 환부하고, 그 재의를 요구할 수 있다. 국회의 폐회중에도 또한 같다.",
            platforms: [Platform(platformName: "네이버시리즈",
                                 platformImage: "/platform/naver-series",
                                 platformURL: "https://namu.wiki/w/당신의%20이해를%20돕기%20위하여"),
                        Platform(platformName: "카카오페이지",
                                 platformImage: "/platform/naver-series",
                                 platformURL: "https://page.kakao.com/content/53706168")],
            attractivePoints: [],
            keywords: [Keyword(keywordName: "서양풍/중세시대",
                               keywordCount: 7),
                       Keyword(keywordName: "웹툰화",
                               keywordCount: 5),
                       Keyword(keywordName: "동양풍/사극",
                               keywordCount: 3),
                       Keyword(keywordName: "실존역사",
                               keywordCount: 2),
                       Keyword(keywordName: "현대",
                               keywordCount: 2)],
            watchingCount: 0,
            watchedCount: 0,
            quitCount: 0)
    ]
    
    static let dummyAllEmptyData = [
        NovelDetailInfoResult(
            novelDescription: "대통령으로 선거될 수 있는 자는 국회의원의 피선거권이 있고 선거일 현재 40세에 달하여야 한다. 군인 또는 군무원이 아닌 국민은 대한민국의 영역안에서는 중대한 군사상 기밀·초병·초소·유독음식물공급·포로·군용물에 관한 죄중 법률이 정한 경우와 비상계엄이 선포된 경우를 제외하고는 군사법원의 재판을 받지 아니한다.\n\n국채를 모집하거나 예산외에 국가의 부담이 될 계약을 체결하려 할 때에는 정부는 미리 국회의 의결을 얻어야 한다. 국무회의는 대통령·국무총리와 15인 이상 30인 이하의 국무위원으로 구성한다. 헌법재판소의 조직과 운영 기타 필요한 사항은 법률로 정한다.\n\n훈장등의 영전은 이를 받은 자에게만 효력이 있고, 어떠한 특권도 이에 따르지 아니한다. 위원은 탄핵 또는 금고 이상의 형의 선고에 의하지 아니하고는 파면되지 아니한다.\n\n국민경제의 발전을 위한 중요정책의 수립에 관하여 대통령의 자문에 응하기 위하여 국민경제자문회의를 둘 수 있다.\n\n대통령은 법률이 정하는 바에 의하여 훈장 기타의 영전을 수여한다. 법률안에 이의가 있을 때에는 대통령은 제1항의 기간내에 이의서를 붙여 국회로 환부하고, 그 재의를 요구할 수 있다. 국회의 폐회중에도 또한 같다.",
            platforms: [Platform(platformName: "네이버시리즈",
                                 platformImage: "/platform/naver-series",
                                 platformURL: "https://namu.wiki/w/당신의%20이해를%20돕기%20위하여"),
                        Platform(platformName: "카카오페이지",
                                 platformImage: "/platform/naver-series",
                                 platformURL: "https://page.kakao.com/content/53706168")],
            attractivePoints: [],
            keywords: [],
            watchingCount: 0,
            watchedCount: 0,
            quitCount: 0)
    ]
}

