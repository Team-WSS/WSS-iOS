//
//  FeedViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 5/14/24.
//

import Foundation

import RxSwift
import RxCocoa

final class FeedViewModel: ViewModelType {
    
    //MARK: - Properties

    //로그인 시 성별 정보 받아야 함
    private var gender: String = "F"
    let maleCategory = ["전체","판타지", "현판", "무협", "드라마", "미스터리", "라노벨", "로맨스", "로판", "BL", "기타"]
    let femaleCategory = ["전체", "로맨스", "로판", "BL", "판타지", "현판", "무협", "드라마", "미스터리", "라노벨", "기타"]
    
    //MARK: - Life Cycle
    
    init(gender: String) {
        self.gender = gender
    }
    
    struct Input {
        let pageBarTapped: ControlEvent<IndexPath>
        let createFeedButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let categoryList = BehaviorRelay<[String]>(value: [""])
        let selectedTabIndex = PublishSubject<Int>()
        let pushToFeedEditViewController = PublishRelay<Void>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        if gender == "M" {
            output.categoryList.accept(maleCategory)
        } else if gender == "F" {
            output.categoryList.accept(femaleCategory)
        }
        
        input.pageBarTapped
            .map{$0.row}
            .bind(to: output.selectedTabIndex)
            .disposed(by: disposeBag)
        
        input.createFeedButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                output.pushToFeedEditViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
