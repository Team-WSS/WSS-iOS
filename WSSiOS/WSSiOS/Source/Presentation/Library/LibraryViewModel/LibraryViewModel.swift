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
    }
    
    struct Output {
        let setUpPageViewController = BehaviorRelay<Int>(value: 0)
        let bindCell = BehaviorRelay<[String]>(value: [])
        let moveToTappedTabBar = BehaviorRelay<Int>(value: 0)
        let updateChildViewController = BehaviorRelay<StringLiterals.Alignment>(value:.newest)
        let popLastViewController = PublishRelay<Void>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        output.bindCell.accept(tabBarList)
        
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
        
        return output
    }
}
