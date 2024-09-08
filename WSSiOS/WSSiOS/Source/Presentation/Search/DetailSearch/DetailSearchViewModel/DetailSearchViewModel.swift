//
//  DetailSearchViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/18/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture
import RxRelay

final class DetailSearchViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let cancelButtonEnabled = PublishRelay<Bool>()
    private let genreList = BehaviorRelay<[String]>(value: NovelGenre.allCases.map { $0.toKorean })
    private let selectedTab = BehaviorRelay<DetailSearchTab>(value: DetailSearchTab.info)
    
    struct Input {
        let cancelButtonDidTap: ControlEvent<Void>
        let infoTabDidTap: Observable<UITapGestureRecognizer>
        let keywordTabDidTap: Observable<UITapGestureRecognizer>
    }
    
    struct Output {
        let cancelButtonEnabled: Observable<Void>
        let genreList: Driver<[String]>
        let selectedTab: Driver<DetailSearchTab>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        let cancelButtonEnabled = input.cancelButtonDidTap.asObservable()

        input.infoTabDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.selectedTab.accept(.info)
            })
            .disposed(by: disposeBag)
        
        input.keywordTabDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.selectedTab.accept(.keyword)
            })
            .disposed(by: disposeBag)
        
        return Output(cancelButtonEnabled: cancelButtonEnabled,
                      genreList: genreList.asDriver(),
                      selectedTab: selectedTab.asDriver())
    }
    
    //MARK: - Custom Method
    
    func genreNameForItemAt(indexPath: IndexPath) -> String? {
        guard indexPath.item < genreList.value.count else {
            return nil
        }
        
        return genreList.value[indexPath.item]
    }
}
