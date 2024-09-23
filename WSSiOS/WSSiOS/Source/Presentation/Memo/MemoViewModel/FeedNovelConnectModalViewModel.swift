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
    
    private let searchResultList: [NormalSearchNovel] = [NormalSearchNovel(novelId: 0, novelImage: "", novelTitle: "당신의 이해를 돕기 위해", novelAuthor: "이보라", interestCount: 0, novelRating: 0, novelRatingCount: 0), NormalSearchNovel(novelId: 0, novelImage: "", novelTitle: "당신의 이해를 돕기 위해", novelAuthor: "이보라", interestCount: 0, novelRating: 0, novelRatingCount: 0), NormalSearchNovel(novelId: 0, novelImage: "", novelTitle: "당신의 이해를 돕기 위해", novelAuthor: "이보라", interestCount: 0, novelRating: 0, novelRatingCount: 0), NormalSearchNovel(novelId: 0, novelImage: "", novelTitle: "당신의 이해를 돕기 위해", novelAuthor: "이보라", interestCount: 0, novelRating: 0, novelRatingCount: 0), NormalSearchNovel(novelId: 0, novelImage: "", novelTitle: "당신의 이해를 돕기 위해", novelAuthor: "이보라", interestCount: 0, novelRating: 0, novelRatingCount: 0), NormalSearchNovel(novelId: 0, novelImage: "", novelTitle: "당신의 이해를 돕기 위해", novelAuthor: "이보라", interestCount: 0, novelRating: 0, novelRatingCount: 0)]
    private let searchText = BehaviorRelay<String>(value: "")
    private var selectedNovel: NormalSearchNovel?
    
    // Output
    private let dismissModalViewController = PublishRelay<Void>()
    private let endEditing = PublishRelay<Void>()
    private let normalSearchList = PublishRelay<[NormalSearchNovel]>()
    private let showConnectNovelButton = PublishRelay<Void>()
    
    //MARK: - Life Cycle
    
    struct Input {
        let closeButtonDidTap: ControlEvent<Void>
        let searchTextUpdated: Observable<String>
        let searchButtonDidTap: ControlEvent<Void>
        let searchResultCollectionViewItemSelected: Observable<IndexPath>
        let searchResultCollectionViewSwipeGesture: Observable<UISwipeGestureRecognizer>
        let connectNovelButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let dismissModalViewController: Observable<Void>
        let endEditing: Observable<Void>
        let searchResultList: Observable<[NormalSearchNovel]>
        let showConnectNovelButton: Observable<Void>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.closeButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.dismissModalViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.searchTextUpdated
            .subscribe(with: self, onNext: { owner, text in
                print(text)
                owner.searchText.accept(text)
            })
            .disposed(by: disposeBag)
        
        input.searchButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.normalSearchList.accept(owner.searchResultList)
                owner.endEditing.accept(())
            })
            .disposed(by: disposeBag)
        
        input.searchResultCollectionViewItemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.endEditing.accept(())
                owner.showConnectNovelButton.accept(())
                owner.selectedNovel = owner.searchResultList[indexPath.item]
            })
            .disposed(by: disposeBag)
        
        input.searchResultCollectionViewSwipeGesture
            .subscribe(with: self, onNext: { owner, _ in
                owner.endEditing.accept(())
            })
            .disposed(by: disposeBag)
        
        input.connectNovelButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                guard let selectedNovel = owner.selectedNovel else { return }
                NotificationCenter.default.post(name: NSNotification.Name("FeedNovelConnected"), object: selectedNovel)
                owner.dismissModalViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        return Output(dismissModalViewController: dismissModalViewController.asObservable(),
                      endEditing: endEditing.asObservable(),
                      searchResultList: normalSearchList.asObservable(),
                      showConnectNovelButton: showConnectNovelButton.asObservable())
    }
}

