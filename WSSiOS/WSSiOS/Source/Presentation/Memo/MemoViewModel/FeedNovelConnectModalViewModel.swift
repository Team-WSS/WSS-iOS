//
//  FeedNovelConnectModalViewModel.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/15/24.
//

import UIKit

import RxSwift
import RxCocoa

final class FeedNovelConnectModalViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let searchResultList: [NormalSearchNovel] = [NormalSearchNovel(novelId: 0, novelImage: "", novelTitle: "당신의 이해를 돕기 위해", novelAuthor: "이보라", interestCount: 0, ratingAverage: 0, ratingCount: 0), NormalSearchNovel(novelId: 0, novelImage: "", novelTitle: "당신의 이해를 돕기 위해", novelAuthor: "이보라", interestCount: 0, ratingAverage: 0, ratingCount: 0), NormalSearchNovel(novelId: 0, novelImage: "", novelTitle: "당신의 이해를 돕기 위해", novelAuthor: "이보라", interestCount: 0, ratingAverage: 0, ratingCount: 0), NormalSearchNovel(novelId: 0, novelImage: "", novelTitle: "당신의 이해를 돕기 위해", novelAuthor: "이보라", interestCount: 0, ratingAverage: 0, ratingCount: 0), NormalSearchNovel(novelId: 0, novelImage: "", novelTitle: "당신의 이해를 돕기 위해", novelAuthor: "이보라", interestCount: 0, ratingAverage: 0, ratingCount: 0), NormalSearchNovel(novelId: 0, novelImage: "", novelTitle: "당신의 이해를 돕기 위해", novelAuthor: "이보라", interestCount: 0, ratingAverage: 0, ratingCount: 0)]
    
    //MARK: - Life Cycle
    
    struct Input {
        let closeButtonDidTap: ControlEvent<Void>
        let searchButtonDidTap: ControlEvent<Void>
        let searchResultCollectionViewItemSelected: Observable<IndexPath>
        let searchResultCollectionViewSwipeGesture: Observable<UISwipeGestureRecognizer>
    }
    
    struct Output {
        let dismissModalViewController = PublishRelay<Void>()
        let endEditing = PublishRelay<Void>()
        let searchResultList = PublishRelay<[NormalSearchNovel]>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.closeButtonDidTap
            .subscribe(onNext: { _ in
                output.dismissModalViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.searchButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                output.searchResultList.accept(owner.searchResultList)
            })
            .disposed(by: disposeBag)
        
        input.searchResultCollectionViewItemSelected
            .subscribe(onNext: { _ in
                output.endEditing.accept(())
            })
            .disposed(by: disposeBag)
        
        input.searchResultCollectionViewSwipeGesture
            .subscribe(onNext: { _ in
                output.endEditing.accept(())
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

