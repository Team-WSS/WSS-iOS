//
//  NovelKeywordSelectModalViewController.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/17/24.
//

import UIKit

import RxSwift
import RxCocoa

final class NovelKeywordSelectModalViewController: UIViewController {
    
    //MARK: - Properties
    
    private let novelKeywordSelectModalViewModel: NovelKeywordSelectModalViewModel
    private let disposeBag = DisposeBag()
    
    private let viewDidLoadEvent = PublishRelay<Void>()
    
    //MARK: - Components
    
    private let rootView = NovelKeywordSelectModalView()
    
    //MARK: - Life Cycle
    
    init(viewModel: NovelKeywordSelectModalViewModel) {
        self.novelKeywordSelectModalViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
        delegate()
        bindViewModel()
    }
    
    //MARK: - UI
    
    private func register() {
        rootView.novelKeywordSelectSearchResultView.searchResultCollectionView.register(NovelKeywordSelectSearchResultCollectionViewCell.self, forCellWithReuseIdentifier: NovelKeywordSelectSearchResultCollectionViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.novelKeywordSelectSearchResultView.searchResultCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Bind
    
    private func bindViewModel() {
        let input = NovelKeywordSelectModalViewModel.Input(
                closeButtonDidTap: rootView.closeButton.rx.tap,
                searchButtonDidTap: rootView.novelKeywordSelectSearchBarView.searchButton.rx.tap, 
                searchResultCollectionViewContentSize: rootView.novelKeywordSelectSearchResultView.searchResultCollectionView.rx.observe(CGSize.self, "contentSize")
            )
        
        let output = self.novelKeywordSelectModalViewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.dismissModalViewController
            .subscribe(with: self, onNext: { owner, _ in
                owner.dismissModalViewController()
            })
            .disposed(by: disposeBag)
        
        output.keywordSearchResultListData
            .subscribe(with: self, onNext: { owner, searchResultList in
                owner.rootView.showSearchResultView(show: !searchResultList.isEmpty)
            })
            .disposed(by: disposeBag)
        
        output.keywordSearchResultListData.bind(to: rootView.novelKeywordSelectSearchResultView.searchResultCollectionView.rx.items(cellIdentifier: NovelKeywordSelectSearchResultCollectionViewCell.cellIdentifier, cellType: NovelKeywordSelectSearchResultCollectionViewCell.self)) { item, element, cell in
            cell.bindData(keyword: element)
        }
        .disposed(by: disposeBag)
        
        output.searchResultCollectionViewHeight
            .subscribe(with: self, onNext: { owner, height in
                owner.rootView.novelKeywordSelectSearchResultView.updateCollectionViewHeight(height: height)
            })
            .disposed(by: disposeBag)
    }
}

extension NovelKeywordSelectModalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var text: String?
        
        text = self.novelKeywordSelectModalViewModel.keywordSearchResultList[indexPath.item]
        
        guard let unwrappedText = text else {
            return CGSize(width: 0, height: 0)
        }
        
        let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 26
        return CGSize(width: width, height: 35)
    }
}
