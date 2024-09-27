//
//  FeedViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 5/14/24.
//

import Foundation

import RxSwift
import RxRelay

final class FeedViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let feedRepository: FeedRepository
    
    //로그인 시 성별 정보 받아야 함
    private var gender: String = "F"
    let maleCategory = ["전체","판타지", "현판", "무협", "드라마", "미스터리", "라노벨", "로맨스", "로판", "BL", "기타"]
    let femaleCategory = ["전체", "로맨스", "로판", "BL", "판타지", "현판", "무협", "드라마", "미스터리", "라노벨", "기타"]
    
    //MARK: - Life Cycle
    
    init(feedRepository: FeedRepository, gender: String) {
        self.feedRepository = feedRepository
        self.gender = gender
    }
    
    struct Input {
        
    }
    
    struct Output {
        let categoryList = BehaviorRelay<[String]>(value: [""])
        let feedList = PublishRelay<[TotalFeeds]>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        if gender == "M" {
            output.categoryList.accept(maleCategory)
        } else if gender == "F" {
            output.categoryList.accept(femaleCategory)
        }

        feedRepository.getFeedData(category: "all",
                                   lastFeedId: 1)
        .subscribe(with: self, onNext: { owner, data in
            output.feedList.accept(data.feeds)
        }, onError: { owner, error in
            print(error)
        })
        .disposed(by: disposeBag)
        
        return output
    }
    
    //MARK: - Custom Method
    
    
    //MARK: - API
    
    private func getFeedData(category: String, lastFeedId: Int) -> Observable<TotalFeed> {
        return self.feedRepository.getFeedData(category: category, lastFeedId: lastFeedId)
    }
}
