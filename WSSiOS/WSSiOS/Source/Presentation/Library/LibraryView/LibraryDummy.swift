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
    libraryDummyStruct(Image: UIImage(named: "sample1")!, title: "나는 신지원", author: "신지원", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample2")!, title: "나는 이윤학", author: "낙낙", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample3")!, title: "나는 최서연", author: "서여닝둥둥둥둥", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample4")!, title: "ㅎㅇ나 낙낙인디", author: "낙낙낙낙낙낙낙낙낙낙", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample1")!, title: "여자친구로 삼으려고 학생회를 하였다", author: "이보라이보라이보라이보라", rating: 4.5),
    libraryDummyStruct(Image: UIImage(named: "sample1")!, title: "나는 신지원", author: "신지원", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample2")!, title: "나는 이윤학", author: "낙낙", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample3")!, title: "나는 최서연", author: "서여닝둥둥둥둥", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample4")!, title: "ㅎㅇ나 낙낙인디", author: "낙낙낙낙낙낙낙낙낙낙", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample1")!, title: "여자친구로 삼으려고 학생회를 하였다", author: "이보라이보라이보라이보라", rating: 4.5),
    libraryDummyStruct(Image: UIImage(named: "sample1")!, title: "나는 신지원", author: "신지원", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample2")!, title: "나는 이윤학", author: "낙낙", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample3")!, title: "나는 최서연", author: "서여닝둥둥둥둥", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample4")!, title: "ㅎㅇ나 낙낙인디", author: "낙낙낙낙낙낙낙낙낙낙", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample1")!, title: "여자친구로 삼으려고 학생회를 하였다", author: "이보라이보라이보라이보라", rating: 4.5),
    libraryDummyStruct(Image: UIImage(named: "sample1")!, title: "나는 신지원", author: "신지원", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample2")!, title: "나는 이윤학", author: "낙낙", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample3")!, title: "나는 최서연", author: "서여닝둥둥둥둥", rating: 5.0),
    libraryDummyStruct(Image: UIImage(named: "sample4")!, title: "ㅎㅇ나 낙낙인디", author: "낙낙낙낙낙낙낙낙낙낙", rating: 5.0)])
