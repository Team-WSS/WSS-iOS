//
//  RecordDummy.swift
//  WSSiOS
//
//  Created by 최서연 on 1/13/24.
//

import UIKit

import RxSwift

struct Record {
    var recordDate: String
    var novelTitle: String
    var recordContent: String
}

let recordDummy = Observable.just([
    Record(recordDate: "2023-12-23 오전 10:12", 
           novelTitle: "당신의 이해를 돕기 위하여",
           recordContent: "일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십"),
    Record(recordDate: "2023-12-23 오전 10:12", 
           novelTitle: "어두운 바다의 등불이 되어",
           recordContent: "3,000m 아래 해저기지에 입사한 지 닷새 만에 물이 샌다고? 정말 재밌다 이 웹소설은 절대 죽지 않는닼!"),
    Record(recordDate: "2023-12-23 오전 10:12", 
           novelTitle: "세상만 구하고 은퇴하겠습니다",
           recordContent: "멸망 직전, 정신을 차리니 20년 전 과거로 돌아왔다. 안온한 정년퇴직을 위해서는 반드시 멸망을 막아야 한다. 오직 권력만을 위해 살아온 권력주의자 우희재! 졸지에 혈기왕성환 학생들의 선생이 되어 멸망을 막게 된 그의 앞날은?"),
    Record(recordDate: "2023-12-23 오전 10:12", 
           novelTitle: "명문고 EX급 조연의 리플레이",
           recordContent: "읽으면... 후회 안 해요. 왜 다음편이 없지? 하면서 다시 보게 만드는 그 소설ㅠ 볼때마다 이런 떡밥이! 하게 되는 소설! 진짜 추천합니다!"),
    Record(recordDate: "2023-12-23 오전 10:12", 
           novelTitle: "흑막이지만 세계 평화가 소원입니다",
           recordContent: "남들 보기에는 사람을 고문하고, 테러를 저질러서 수만명을 살해하는 극악무도한 빌런집단이지만... 사실은 우당탕탕 어리둥절 빙글뱅글 돌아가는 가좍들입니다..... 우리 애들이 사람을 죽이기는 하는데 나쁜놈만 죽여요. 억울하게 누명 쓴 거예요.."),
    Record(recordDate: "2023-12-23 오전 10:12",
           novelTitle: "회귀도 13번이면 지랄맞다",
           recordContent: "오래된 작품이라 초반부가 엄청 옛날냄새나서 버티기 힘들 수 있고, 포텐이 터지는 중반부 이후도 호불호가 강하게 갈리므로 입문작으로 적합한지는 조금 의문"),
    Record(recordDate: "2023-12-23 오전 10:12",
           novelTitle: "백작가의 망나니가 되었다",
           recordContent: "대충 이분야 원조맛집. 착각물 속성도 갖고있고, BL드리프트는 아니지만 여초 인기가 아주 많이 대단히 상당하게 많은 작품이다. 트X터에서 전독시 내스급 백망되가 3대 입문작으로 뽑힐 정도이니 어느 플랫폼이든 댓글은 조심."),
])
