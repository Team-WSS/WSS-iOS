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

    private let gender = UserDefaults.standard.string(forKey: StringLiterals.UserDefault.userGender)
    
    //MARK: - Life Cycle
    
    struct Input {
        let pageBarTapped: ControlEvent<IndexPath>
        let createFeedButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let categoryList = BehaviorRelay<[NewNovelGenre]>(value: [])
        let selectedTabIndex = PublishSubject<Int>()
        let pushToFeedEditViewController = PublishRelay<Void>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        output.categoryList.accept(gender == "M"
                                   ? NewNovelGenre.feedMaleGenres
                                   : NewNovelGenre.feedFemaleGenres)
        
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
