//
//  LibraryDummy.swift
//  WSSiOS
//
//  Created by 신지원 on 1/14/24.
//

import UIKit

import RxSwift

struct libraryDummyStruct {
    var Image : UIImage
    var title : String
    var author : String
    var rating : Float
}

let libraryDummyData = Observable.just([
    libraryDummyStruct(Image: UIImage(named: "sample1")!, title: "여자친구로 삼으려고 학생회를 하였다", author: "이보라이보라이보라이보라", rating: 4.5),
    libraryDummyStruct(Image: UIImage(named: "sample1")!, title: "전효원을 사랑하지 않는 법을 알려주세요", author: "신지원", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample3")!, title: "SUN, 그게 뭔데", author: "신지원", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample3")!, title: "나에게는 전효원이라는 별이 빛나", author: "신지원", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample3")!, title: "전 효원인데요?", author: "서여닝둥둥둥둥", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample4")!, title: "성이 뭐져?", author: "낙낙낙낙낙낙낙낙낙낙", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample1")!, title: "전 효원이요", author: "이보라이보라이보라이보라", rating: 4.5),
    libraryDummyStruct(Image: UIImage(named: "sample1")!, title: "나는 신지원", author: "신지원", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample3")!, title: "나는 이윤학", author: "낙낙", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample3")!, title: "나는 최서연", author: "서여닝둥둥둥둥", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample4")!, title: "ㅎㅇ나 낙낙인디", author: "낙낙낙낙낙낙낙낙낙낙", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample1")!, title: "여자친구로 삼으려고 학생회를 하였다", author: "이보라이보라이보라이보라", rating: 4.5),
    libraryDummyStruct(Image: UIImage(named: "sample1")!, title: "나는 신지원", author: "신지원", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample3")!, title: "나는 이윤학", author: "낙낙", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample3")!, title: "나는 최서연", author: "서여닝둥둥둥둥", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample4")!, title: "ㅎㅇ나 낙낙인디", author: "낙낙낙낙낙낙낙낙낙낙", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample1")!, title: "여자친구로 삼으려고 학생회를 하였다", author: "이보라이보라이보라이보라", rating: 4.5),
    libraryDummyStruct(Image: UIImage(named: "sample1")!, title: "나는 신지원", author: "신지원", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample3")!, title: "나는 이윤학", author: "낙낙", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample3")!, title: "나는 최서연", author: "서여닝둥둥둥둥", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample4")!, title: "ㅎㅇ나 낙낙인디", author: "낙낙낙낙낙낙낙낙낙낙", rating: 5.0)])

let dummyLibraryTabTitle = Observable.just(["전체", "읽음", "읽는 중", "하차", "읽고 싶음"])
