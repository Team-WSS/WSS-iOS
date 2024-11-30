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
        let listButtonDidTap: ControlEvent<Void>
        let newestButtonDidTap: ControlEvent<Void>
        let oldestButtonDidTap: ControlEvent<Void>
        let backButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let setUpPageViewController = BehaviorRelay<Int>(value: 0)
        let bindCell = BehaviorRelay<[String]>(value: [])
        let moveToTappedTabBar = BehaviorRelay<Int>(value: 0)
        let showListView = BehaviorRelay<Bool>(value: false)
        let changeListType = BehaviorRelay<StringLiterals.Alignment>(value:.newest)
        let updateChildViewController = BehaviorRelay<StringLiterals.Alignment>(value:.newest)
        let popLastViewController = PublishRelay<Void>()
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
        
        input.listButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                let nowShowListStatus = output.showListView.value
                output.showListView.accept(!nowShowListStatus)
            })
            .disposed(by: disposeBag)
        
        input.newestButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                let lastTappedListType = owner.lastTappedListTypeRelay.value
                if (lastTappedListType != .newest) {
                    output.changeListType.accept(.newest)
                }
                
                let nowShowListStatus = output.showListView.value
                output.showListView.accept(!nowShowListStatus)
                output.updateChildViewController.accept(.newest)
                
            })
            .disposed(by: disposeBag)
        
        input.oldestButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                let lastTappedListType = owner.lastTappedListTypeRelay.value
                if (lastTappedListType != .oldest) {
                    output.changeListType.accept(.oldest)
                }
                
                let nowShowListStatus = output.showListView.value
                output.showListView.accept(!nowShowListStatus)
                output.updateChildViewController.accept(.oldest)
                
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
