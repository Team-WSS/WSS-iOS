//
//  SearchDummy.swift
//  WSSiOS
//
//  Created by 최서연 on 1/8/24.
//

import UIKit

struct SearchNovel {
    let novelImage: UIImage?
    let novelTitle: String
    let novelAuthor: String
    let novelGenre: String
}

extension SearchNovel {
    static func searchNovelDummy() -> [SearchNovel] {
        return [SearchNovel(novelImage: UIImage(named: "sample1"), novelTitle: "당신의 이해를 돕기 위하여", novelAuthor: "이보라", novelGenre: "로판"),
                SearchNovel(novelImage: UIImage(named: "sample2"), novelTitle: "여자친구로 삼으려고 학생회장을 꼭 닮은 여자아이를 연성했다가 내가 하인이 돼버렸다능", novelAuthor: "이보라이보라이보라이보라이보라이보라이보라돌이뚜비나나뽀오", novelGenre: "판타지"),
                SearchNovel(novelImage: UIImage(named: "sample3"), novelTitle: "당신의 성자에게 투표하세요", novelAuthor: "커피소녀", novelGenre: "로판"),
                SearchNovel(novelImage: UIImage(named: "sample4"), novelTitle: "남궁세가 손녀딸의 귀환", novelAuthor: "백서하", novelGenre: "로판"),
                SearchNovel(novelImage: UIImage(named: "sample5"), novelTitle: "당신이 사랑하는 동안에", novelAuthor: "유수희", novelGenre: "로판"),
                SearchNovel(novelImage: UIImage(named: "sample6"), novelTitle: "당신의 세상에서", novelAuthor: "이보라", novelGenre: "로맨스 판타지"),
                SearchNovel(novelImage: UIImage(named: "sample1"), novelTitle: "당신의 이해를 돕기 위하여", novelAuthor: "이보라", novelGenre: "로판")
        ]
    }
}
