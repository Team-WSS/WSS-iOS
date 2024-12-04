//
//  LibraryViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 11/30/24.
//

import Foundation

import RxSwift
import RxCocoa

final class LibraryViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let userRepository: UserRepository
    private let userId: Int
    
    private let disposeBag = DisposeBag()
    private let tabBarList = StringLiterals.ReviewerStatus.allCases.map { $0.rawValue }
    private let sortTypeList = StringLiterals.Alignment.self
    
    private let lastTappedListTypeRelay = BehaviorRelay<StringLiterals.Alignment>(value: .newest)
    private let userIdRelay = BehaviorRelay<Int>(value: 0)

    // MARK: - Life Cycle
    
    init(userRepository: UserRepository, userId: Int) {
        self.userRepository = userRepository
        self.userId = userId
        
        userIdRelay.accept(userId)
    }
    
    struct Input {
        let tabBarDidTap: ControlEvent<IndexPath>
        let backButtonDidTap: ControlEvent<Void>
        let novelCount: Observable<Int>
    }
    
    struct Output {
        let setUpPageViewController = BehaviorRelay<Int>(value: 0)
        let bindCell = BehaviorRelay<[String]>(value: [])
        let moveToTappedTabBar = BehaviorRelay<Int>(value: 0)
        let showListView = BehaviorRelay<Bool>(value: false)
        let changeListType = BehaviorRelay<StringLiterals.Alignment>(value:.newest)
        let updateChildViewController = BehaviorRelay<StringLiterals.Alignment>(value:.newest)
        let popLastViewController = PublishRelay<Void>()
        let changeNovelCount = BehaviorRelay<Int>(value: 0)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        output.bindCell.accept(tabBarList)
        output.showListView.accept(false)
        
        userIdRelay
            .bind(with: self, onNext: { owner, _ in
                output.setUpPageViewController.accept(owner.userId)
            })
            .disposed(by: disposeBag)
        
        input.tabBarDidTap
            .bind(with: self, onNext: { owner, indexPath in
                output.moveToTappedTabBar.accept(indexPath.row)
            })
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                output.popLastViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.novelCount
            .bind(with: self, onNext: { owner, count in
                output.changeNovelCount.accept(count)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
