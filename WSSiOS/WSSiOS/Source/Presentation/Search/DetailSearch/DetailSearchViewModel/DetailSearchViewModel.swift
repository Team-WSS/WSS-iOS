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

final class DetailSearchViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let cancelButtonEnabled = PublishRelay<Bool>()
    private let genreList = BehaviorRelay<[String]>(value: DetailSearchGenre.allCases.map { $0.withKorean })
    private let genreCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    private let selectedTab = BehaviorRelay<DetailSearchTab>(value: DetailSearchTab.info)
    
    struct Input {
        let cancelButtonDidTap: ControlEvent<Void>
        let genreCollectionViewContentSize: Observable<CGSize?>
        let infoTabDidTap: Observable<UITapGestureRecognizer>
        let keywordTabDidTap: Observable<UITapGestureRecognizer>
    }
    
    struct Output {
        let cancelButtonEnabled: Observable<Void>
        let genreList: Driver<[String]>
        let genreCollectionViewHeight: Driver<CGFloat>
        let selectedTab: Driver<DetailSearchTab>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        let cancelButtonEnabled = input.cancelButtonDidTap.asObservable()
        
        let genreCollectionViewContentSize = input.genreCollectionViewContentSize
            .map { $0?.height ?? 0 }.asDriver(onErrorJustReturn: 0)

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
                      genreCollectionViewHeight: genreCollectionViewContentSize,
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

enum DetailSearchGenre: CaseIterable {
    case romance, romanceFantasy, fantasy
    case modernFantasy, wuxia, mystery, drama
    case lightNovel, bl
    
    var withKorean: String {
        switch self {
        case .romance:
            return "로맨스"
        case .romanceFantasy:
            return "로판"
        case .fantasy:
            return "판타지"
        case .modernFantasy:
            return "현판"
        case .wuxia:
            return "무협"
        case .mystery:
            return "미스터리"
        case .drama:
            return "드라마"
        case .lightNovel:
            return "라노벨"
        case .bl:
            return "BL"
        }
    }
}
