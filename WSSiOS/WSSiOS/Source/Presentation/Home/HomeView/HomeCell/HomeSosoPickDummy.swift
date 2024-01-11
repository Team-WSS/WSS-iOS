//
//  HomeSosoPickDummy.swift
//  WSSiOS
//
//  Created by 최서연 on 1/12/24.
//

import UIKit

import RxSwift

struct SosoPickNovel {
    let image: String
    let title: String
    let author: String
    let registerUserNumber: Int
}

let sosoPickDummy = Observable.just([
    SosoPickNovel(image: "sosopickSampleImage", title: "아요 화이팅", author: "최서연 영애", registerUserNumber: 31),
    SosoPickNovel(image: "sosopickSampleImage", title: "신지원 할 수 있어", author: "최서연 영애", registerUserNumber: 4),
    SosoPickNovel(image: "sosopickSampleImage", title: "이윤학도 할 수 있어", author: "최서연 영애", registerUserNumber: 10),
    SosoPickNovel(image: "sosopickSampleImage", title: "전효원 아프지망고 건강하자", author: "최서연 영애", registerUserNumber: 2),
    SosoPickNovel(image: "sosopickSampleImage", title: "까르보불닭볶음면에계란추가는못참겠다", author: "최서연 영애", registerUserNumber: 13),
    SosoPickNovel(image: "sosopickSampleImage", title: "아요아요", author: "최서연 영애", registerUserNumber: 2),
    SosoPickNovel(image: "sosopickSampleImage", title: "아요 화이팅", author: "최서연 영애", registerUserNumber: 31),
    SosoPickNovel(image: "sosopickSampleImage", title: "아요 화이팅", author: "최서연 영애", registerUserNumber: 31),
    SosoPickNovel(image: "sosopickSampleImage", title: "아요 화이팅", author: "최서연 영애", registerUserNumber: 31),
    SosoPickNovel(image: "sosopickSampleImage", title: "아요 화이팅", author: "최서연 영애", registerUserNumber: 31)
])
