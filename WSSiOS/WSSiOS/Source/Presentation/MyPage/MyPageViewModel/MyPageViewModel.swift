//
//  MyPageViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 1/10/24.
//

import Foundation

import RxSwift
import RxCocoa

class MyPageViewModel {
    
    static let setting = Observable.just(["계정정보 확인",
                                          "로그아웃",
                                          "웹소소 인스타 보러가기",
                                          "서비스 이용약관"])
}

