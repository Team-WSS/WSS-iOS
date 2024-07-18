//
//  DetailSearchViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/18/24.
//

import Foundation

import RxSwift
import RxCocoa

final class DetailSearchViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let cancelButtonEnabled = PublishRelay<Bool>()
    private let genreList = BehaviorRelay<[String]>(value: ["로맨스", "로판", "판타지", "현판", "무협", "미스터리", "드라마", "라노벨", "BL"])
    private let genreCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    
    struct Input {
        let cancelButtonDidTap: ControlEvent<Void>
        let genreCollectionViewContentSize: Observable<CGSize?>
    }
    
    struct Output {
        let cancelButtonEnabled: Observable<Void>
        let genreList: Driver<[String]>
        let genreCollectionViewHeight: Driver<CGFloat>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        let cancelButtonEnabled = input.cancelButtonDidTap.asObservable()
        
        let genreCollectionViewContentSize = input.genreCollectionViewContentSize
            .map { $0?.height ?? 0 }.asDriver(onErrorJustReturn: 0)
        
        return Output(cancelButtonEnabled: cancelButtonEnabled,
                      genreList: genreList.asDriver(),
                      genreCollectionViewHeight: genreCollectionViewContentSize)
    }
    
    //MARK: - Custom Method
    
    func genreNameForItemAt(indexPath: IndexPath) -> String? {
        guard indexPath.item < genreList.value.count else {
            return nil
        }
        
        return genreList.value[indexPath.item]
    }
}
