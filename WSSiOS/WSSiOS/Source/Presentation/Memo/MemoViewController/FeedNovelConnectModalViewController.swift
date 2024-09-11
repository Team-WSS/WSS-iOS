//
//  FeedNovelConnectModalViewController.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 8/17/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

final class FeedNovelConnectModalViewController: UIViewController {
    
    //MARK: - Properties
    
    private let searchResultList = BehaviorRelay<[NormalSearchNovel]>(value: [NormalSearchNovel(novelId: 0, novelImage: "", novelTitle: "당신의 이해를 돕기 위해", novelAuthor: "이보라", interestCount: 0, ratingAverage: 0, ratingCount: 0), NormalSearchNovel(novelId: 0, novelImage: "", novelTitle: "당신의 이해를 돕기 위해", novelAuthor: "이보라", interestCount: 0, ratingAverage: 0, ratingCount: 0), NormalSearchNovel(novelId: 0, novelImage: "", novelTitle: "당신의 이해를 돕기 위해", novelAuthor: "이보라", interestCount: 0, ratingAverage: 0, ratingCount: 0), NormalSearchNovel(novelId: 0, novelImage: "", novelTitle: "당신의 이해를 돕기 위해", novelAuthor: "이보라", interestCount: 0, ratingAverage: 0, ratingCount: 0), NormalSearchNovel(novelId: 0, novelImage: "", novelTitle: "당신의 이해를 돕기 위해", novelAuthor: "이보라", interestCount: 0, ratingAverage: 0, ratingCount: 0), NormalSearchNovel(novelId: 0, novelImage: "", novelTitle: "당신의 이해를 돕기 위해", novelAuthor: "이보라", interestCount: 0, ratingAverage: 0, ratingCount: 0)])
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = FeedNovelConnectModalView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
        bindUI()
        bindAction()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - UI
    
    private func register() {
        rootView.feedNovelConnectSearchResultView.searchResultCollectionView.register(FeedNovelConnectCollectionViewCell.self, forCellWithReuseIdentifier: FeedNovelConnectCollectionViewCell.cellIdentifier)
    }
    
    //MARK: - Bind
    
    private func bindUI() {
        searchResultList.bind(to: rootView.feedNovelConnectSearchResultView.searchResultCollectionView.rx.items(cellIdentifier: FeedNovelConnectCollectionViewCell.cellIdentifier, cellType: FeedNovelConnectCollectionViewCell.self)) { item, element, cell in
            cell.bindData(data: element)
        }
        .disposed(by: disposeBag)
    }
    
    private func bindAction() {
        rootView.closeButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                self.dismissModalViewController()
            })
            .disposed(by: disposeBag)
        
        rootView.feedNovelConnectSearchResultView.searchResultCollectionView.rx.itemSelected
            .subscribe(with: self, onNext: { owner, indexpath in
                self.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        rootView.feedNovelConnectSearchResultView.searchResultCollectionView.rx.swipeGesture(.up)
            .when(.recognized)
            .subscribe(with: self, onNext: { owner, _ in
                self.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        rootView.feedNovelConnectSearchResultView.searchResultCollectionView.rx.swipeGesture(.down)
            .when(.recognized)
            .subscribe(with: self, onNext: { owner, _ in
                self.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
}