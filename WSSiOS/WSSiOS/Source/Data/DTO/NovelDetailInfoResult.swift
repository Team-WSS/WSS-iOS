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
}

extension NovelDetailInfoResult {
    static let dummyFullData = [
        NovelDetailInfoResult(novelDescription: "2028년 직경 5km의 소행성이 지구에 다가온다. 전지구적인 대처로 핵미사일을 탑재한 우주선을 보내 파괴하려 했으나 소행성은 네 조각으로 나뉘어져 일부가 지구에 떨어지고 말았다. 지구가 재난에 휩싸이고 80%의 국가가 무정부 상태가 되었고 군벌이 발호하여 해당 지역을 장악하기 시작했다.\n한국은 다행히 피해가 크지 않아 체제가 유지되었는데 바로 그때 북한이 핵공격을 감행하면서 용산의 지휘부는 큰 타격을 받는다. 하지만 전력을 잃지 않은 한국의 군대는 반격에 나서서 북한을 궤멸시키는데 성공한다. 그러나 전쟁이 끝나면서 군벌들이 여러 곳 할거하면서 한반도는 무정부상태에 빠지고 만다.\n물리학자이자 항공우주연구원 선임연구원이던 백준후는 아포칼립소 직전의 상황에서 집에 두 어린 자식들을 위해 식량을 구하러 다니다가 그만 산속에서 포탈에 빨려들어간다.\n고룡 키네시스가 만든 차원 포탈이었고 그로인해 백준후는 이계인 판드리아 대륙으로 떨어진다. 포탈은 20년이 지나야 다시 열 수 있었다. 20년간 그곳에서 마법과 무술을 배운 백준후가 지구로 돌아왔다. 조용하고 범생이였던 백준후는 크게 변했다.\n불의, 부조리를 보면 참지 못하고 바로 응징해주는 성격이 된 것이다. 그래서 준후는 아주 바쁘게 살아가게 된다.",
                              platforms: [Platform(platformName: "네이버시리즈",
                                                   platformImage: "PlatformNaver",
                                                   platformURL: "https://namu.wiki/w/당신의%20이해를%20돕기%20위하여"),
                                          Platform(platformName: "카카오페이지",
                                                   platformImage: "PlatformKakao",
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
        NovelDetailInfoResult(novelDescription: "2028년 직경 5km의 소행성이 지구에 다가온다. 전지구적인 대처로 핵미사일을 탑재한 우주선을 보내 파괴하려 했으나 소행성은 네 조각으로 나뉘어져 일부가 지구에 떨어지고 말았다. 지구가 재난에 휩싸이고 80%의 국가가 무정부 상태가 되었고 군벌이 발호하여 해당 지역을 장악하기 시작했다.\n한국은 다행히 피해가 크지 않아 체제가 유지되었는데 바로 그때 북한이 핵공격을 감행하면서 용산의 지휘부는 큰 타격을 받는다. 하지만 전력을 잃지 않은 한국의 군대는 반격에 나서서 북한을 궤멸시키는데 성공한다. 그러나 전쟁이 끝나면서 군벌들이 여러 곳 할거하면서 한반도는 무정부상태에 빠지고 만다.\n물리학자이자 항공우주연구원 선임연구원이던 백준후는 아포칼립소 직전의 상황에서 집에 두 어린 자식들을 위해 식량을 구하러 다니다가 그만 산속에서 포탈에 빨려들어간다.\n고룡 키네시스가 만든 차원 포탈이었고 그로인해 백준후는 이계인 판드리아 대륙으로 떨어진다. 포탈은 20년이 지나야 다시 열 수 있었다. 20년간 그곳에서 마법과 무술을 배운 백준후가 지구로 돌아왔다. 조용하고 범생이였던 백준후는 크게 변했다.\n불의, 부조리를 보면 참지 못하고 바로 응징해주는 성격이 된 것이다. 그래서 준후는 아주 바쁘게 살아가게 된다.",
                              platforms: [Platform(platformName: "네이버시리즈",
                                                   platformImage: "PlatformNaver",
                                                   platformURL: "https://namu.wiki/w/당신의%20이해를%20돕기%20위하여"),
                                          Platform(platformName: "카카오페이지",
                                                   platformImage: "PlatformKakao",
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
                              watchingCount: 130,
                              watchedCount: 10,
                              quitCount: 100),
        NovelDetailInfoResult(novelDescription: "2028년 직경 5km의 소행성이 지구에 다가온다. 전지구적인 대처로 핵미사일을 탑재한 우주선을 보내 파괴하려 했으나 소행성은 네 조각으로 나뉘어져 일부가 지구에 떨어지고 말았다. 지구가 재난에 휩싸이고 80%의 국가가 무정부 상태가 되었고 군벌이 발호하여 해당 지역을 장악하기 시작했다.\n한국은 다행히 피해가 크지 않아 체제가 유지되었는데 바로 그때 북한이 핵공격을 감행하면서 용산의 지휘부는 큰 타격을 받는다. 하지만 전력을 잃지 않은 한국의 군대는 반격에 나서서 북한을 궤멸시키는데 성공한다. 그러나 전쟁이 끝나면서 군벌들이 여러 곳 할거하면서 한반도는 무정부상태에 빠지고 만다.\n물리학자이자 항공우주연구원 선임연구원이던 백준후는 아포칼립소 직전의 상황에서 집에 두 어린 자식들을 위해 식량을 구하러 다니다가 그만 산속에서 포탈에 빨려들어간다.\n고룡 키네시스가 만든 차원 포탈이었고 그로인해 백준후는 이계인 판드리아 대륙으로 떨어진다. 포탈은 20년이 지나야 다시 열 수 있었다. 20년간 그곳에서 마법과 무술을 배운 백준후가 지구로 돌아왔다. 조용하고 범생이였던 백준후는 크게 변했다.\n불의, 부조리를 보면 참지 못하고 바로 응징해주는 성격이 된 것이다. 그래서 준후는 아주 바쁘게 살아가게 된다.",
                              platforms: [Platform(platformName: "네이버시리즈",
                                                   platformImage: "PlatformNaver",
                                                   platformURL: "https://namu.wiki/w/당신의%20이해를%20돕기%20위하여"),
                                          Platform(platformName: "카카오페이지",
                                                   platformImage: "PlatformKakao",
                                                   platformURL: "https://page.kakao.com/content/53706168")],
                              attractivePoints: ["캐릭터",
                                                 "관계",
                                                 "소재"],
                              keywords: [],
                              watchingCount: 130,
                              watchedCount: 10,
                              quitCount: 100),
        NovelDetailInfoResult(novelDescription: "2028년 직경 5km의 소행성이 지구에 다가온다. 전지구적인 대처로 핵미사일을 탑재한 우주선을 보내 파괴하려 했으나 소행성은 네 조각으로 나뉘어져 일부가 지구에 떨어지고 말았다. 지구가 재난에 휩싸이고 80%의 국가가 무정부 상태가 되었고 군벌이 발호하여 해당 지역을 장악하기 시작했다.\n한국은 다행히 피해가 크지 않아 체제가 유지되었는데 바로 그때 북한이 핵공격을 감행하면서 용산의 지휘부는 큰 타격을 받는다. 하지만 전력을 잃지 않은 한국의 군대는 반격에 나서서 북한을 궤멸시키는데 성공한다. 그러나 전쟁이 끝나면서 군벌들이 여러 곳 할거하면서 한반도는 무정부상태에 빠지고 만다.\n물리학자이자 항공우주연구원 선임연구원이던 백준후는 아포칼립소 직전의 상황에서 집에 두 어린 자식들을 위해 식량을 구하러 다니다가 그만 산속에서 포탈에 빨려들어간다.\n고룡 키네시스가 만든 차원 포탈이었고 그로인해 백준후는 이계인 판드리아 대륙으로 떨어진다. 포탈은 20년이 지나야 다시 열 수 있었다. 20년간 그곳에서 마법과 무술을 배운 백준후가 지구로 돌아왔다. 조용하고 범생이였던 백준후는 크게 변했다.\n불의, 부조리를 보면 참지 못하고 바로 응징해주는 성격이 된 것이다. 그래서 준후는 아주 바쁘게 살아가게 된다.",
                              platforms: [Platform(platformName: "네이버시리즈",
                                                   platformImage: "PlatformNaver",
                                                   platformURL: "https://namu.wiki/w/당신의%20이해를%20돕기%20위하여"),
                                          Platform(platformName: "카카오페이지",
                                                   platformImage: "PlatformKakao",
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
                              quitCount: 0),
        NovelDetailInfoResult(novelDescription: "2028년 직경 5km의 소행성이 지구에 다가온다. 전지구적인 대처로 핵미사일을 탑재한 우주선을 보내 파괴하려 했으나 소행성은 네 조각으로 나뉘어져 일부가 지구에 떨어지고 말았다. 지구가 재난에 휩싸이고 80%의 국가가 무정부 상태가 되었고 군벌이 발호하여 해당 지역을 장악하기 시작했다.\n한국은 다행히 피해가 크지 않아 체제가 유지되었는데 바로 그때 북한이 핵공격을 감행하면서 용산의 지휘부는 큰 타격을 받는다. 하지만 전력을 잃지 않은 한국의 군대는 반격에 나서서 북한을 궤멸시키는데 성공한다. 그러나 전쟁이 끝나면서 군벌들이 여러 곳 할거하면서 한반도는 무정부상태에 빠지고 만다.\n물리학자이자 항공우주연구원 선임연구원이던 백준후는 아포칼립소 직전의 상황에서 집에 두 어린 자식들을 위해 식량을 구하러 다니다가 그만 산속에서 포탈에 빨려들어간다.\n고룡 키네시스가 만든 차원 포탈이었고 그로인해 백준후는 이계인 판드리아 대륙으로 떨어진다. 포탈은 20년이 지나야 다시 열 수 있었다. 20년간 그곳에서 마법과 무술을 배운 백준후가 지구로 돌아왔다. 조용하고 범생이였던 백준후는 크게 변했다.\n불의, 부조리를 보면 참지 못하고 바로 응징해주는 성격이 된 것이다. 그래서 준후는 아주 바쁘게 살아가게 된다.",
                              platforms: [Platform(platformName: "네이버시리즈",
                                                   platformImage: "PlatformNaver",
                                                   platformURL: "https://namu.wiki/w/당신의%20이해를%20돕기%20위하여"),
                                          Platform(platformName: "카카오페이지",
                                                   platformImage: "PlatformKakao",
                                                   platformURL: "https://page.kakao.com/content/53706168")],
                              attractivePoints: [],
                              keywords: [],
                              watchingCount: 130,
                              watchedCount: 10,
                              quitCount: 100)
    ]
    
    static let dummyAllEmptyData = [
        NovelDetailInfoResult(novelDescription: "2028년 직경 5km의 소행성이 지구에 다가온다. 전지구적인 대처로 핵미사일을 탑재한 우주선을 보내 파괴하려 했으나 소행성은 네 조각으로 나뉘어져 일부가 지구에 떨어지고 말았다. 지구가 재난에 휩싸이고 80%의 국가가 무정부 상태가 되었고 군벌이 발호하여 해당 지역을 장악하기 시작했다.\n한국은 다행히 피해가 크지 않아 체제가 유지되었는데 바로 그때 북한이 핵공격을 감행하면서 용산의 지휘부는 큰 타격을 받는다. 하지만 전력을 잃지 않은 한국의 군대는 반격에 나서서 북한을 궤멸시키는데 성공한다. 그러나 전쟁이 끝나면서 군벌들이 여러 곳 할거하면서 한반도는 무정부상태에 빠지고 만다.\n물리학자이자 항공우주연구원 선임연구원이던 백준후는 아포칼립소 직전의 상황에서 집에 두 어린 자식들을 위해 식량을 구하러 다니다가 그만 산속에서 포탈에 빨려들어간다.\n고룡 키네시스가 만든 차원 포탈이었고 그로인해 백준후는 이계인 판드리아 대륙으로 떨어진다. 포탈은 20년이 지나야 다시 열 수 있었다. 20년간 그곳에서 마법과 무술을 배운 백준후가 지구로 돌아왔다. 조용하고 범생이였던 백준후는 크게 변했다.\n불의, 부조리를 보면 참지 못하고 바로 응징해주는 성격이 된 것이다. 그래서 준후는 아주 바쁘게 살아가게 된다.",
                              platforms: [Platform(platformName: "네이버시리즈",
                                                   platformImage: "PlatformNaver",
                                                   platformURL: "https://namu.wiki/w/당신의%20이해를%20돕기%20위하여"),
                                          Platform(platformName: "카카오페이지",
                                                   platformImage: "PlatformKakao",
                                                   platformURL: "https://page.kakao.com/content/53706168")],
                              attractivePoints: [],
                              keywords: [],
                              watchingCount: 0,
                              watchedCount: 0,
                              quitCount: 0)

    ]
}

