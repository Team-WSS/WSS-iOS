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
    
    private let searchRepository: SearchRepository
    
    private let searchText = BehaviorRelay<String>(value: "")
    private var selectedNovel = BehaviorRelay<NormalSearchNovel?>(value: nil)
    
    // 무한스크롤
    private var currentPage: Int = 0
    private var isLoadable: Bool = false
    private var isFetching: Bool = false
    
    // Output
    private let dismissModalViewController = PublishRelay<Void>()
    private let endEditing = PublishRelay<Void>()
    private let scrollToTop = PublishRelay<Void>()
    private let normalSearchList = BehaviorRelay<[NormalSearchNovel]>(value: [])
    private let showConnectNovelButton = PublishRelay<Void>()
    
    //MARK: - Life Cycle
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    struct Input {
        let closeButtonDidTap: ControlEvent<Void>
        let searchTextUpdated: Observable<String>
        let searchButtonDidTap: ControlEvent<Void>
        let searchResultCollectionViewReachedBottom: Observable<Bool>
        let searchResultCollectionViewItemSelected: Observable<IndexPath>
        let searchResultCollectionViewSwipeGesture: Observable<UISwipeGestureRecognizer>
        let connectNovelButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let dismissModalViewController: Observable<Void>
        let endEditing: Observable<Void>
        let scrollToTop: Observable<Void>
        let normalSearchList: Observable<[NormalSearchNovel]>
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
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .do(onNext: { _ in
                self.currentPage = 0
            })
            .flatMapLatest {
                self.getNormalSearchList(query: self.searchText.value, page: self.currentPage)
            }
            .subscribe(with: self, onNext: { owner, data in
                owner.endEditing.accept(())
                owner.normalSearchList.accept(data.novels)
                owner.isLoadable = data.isLoadable
                owner.scrollToTop.accept(())
            })
            .disposed(by: disposeBag)
        
        input.searchResultCollectionViewReachedBottom
            .filter { reachedBottom in
                return reachedBottom && !self.isFetching && self.isLoadable
            }
            .do(onNext: { _ in
                self.isFetching = true
            })
            .flatMapLatest { _ in
                self.getNormalSearchList(query: self.searchText.value, page: self.currentPage + 1)
                    .do(onNext: { _ in
                        self.currentPage += 1
                        self.isFetching = false
                    }, onError: { _ in
                        self.isFetching = false
                    })
            }
            .subscribe(with: self, onNext: { owner, data in
                owner.endEditing.accept(())
                let newData = owner.normalSearchList.value + data.novels
                owner.normalSearchList.accept(newData)
                owner.isLoadable = data.isLoadable
            })
            .disposed(by: disposeBag)
        
        input.searchResultCollectionViewItemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.endEditing.accept(())
                owner.showConnectNovelButton.accept(())
                owner.selectedNovel.accept(owner.normalSearchList.value[indexPath.item])
            })
            .disposed(by: disposeBag)
        
        input.searchResultCollectionViewSwipeGesture
            .subscribe(with: self, onNext: { owner, _ in
                owner.endEditing.accept(())
            })
            .disposed(by: disposeBag)
        
        input.connectNovelButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                guard let selectedNovel = owner.selectedNovel.value else { return }
                NotificationCenter.default.post(name: NSNotification.Name("FeedNovelConnected"), object: selectedNovel)
                owner.dismissModalViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        return Output(dismissModalViewController: dismissModalViewController.asObservable(),
                      endEditing: endEditing.asObservable(),
                      scrollToTop: scrollToTop.asObservable(),
                      normalSearchList: normalSearchList.asObservable(),
                      showConnectNovelButton: showConnectNovelButton.asObservable())
    }
    
    //MARK: - API
    
    private func getNormalSearchList(query: String, page: Int) -> Observable<NormalSearchNovels> {
        searchRepository.getSearchNovels(query: query, page: page)
            .observe(on: MainScheduler.instance)
    }
    
//    private func getNormalSearchList(query: String, page: Int) -> Observable<NormalSearchNovels> {
//        return searchRepository.getSearchNovels(query: query, page: page)
//            .do(onNext: { data in
//                if page == 0 {
//                    self.normalSearchList.accept(data.novels)
//                } else {
//                    let updatedList = self.normalSearchList.value + data.novels
//                    self.normalSearchList.accept(updatedList)
//                }
//                self.isLoadable.accept(data.isLoadable)
//                self.currentPage.accept(page)
//            }, onError: { error in
//                print(error.localizedDescription)
//            })
//    }
}

