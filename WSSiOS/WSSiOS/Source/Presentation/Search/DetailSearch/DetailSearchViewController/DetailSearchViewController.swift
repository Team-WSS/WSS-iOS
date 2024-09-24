//
//  DetailSearchViewController.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/18/24.
//

import UIKit

import RxSwift
import RxCocoa

final class DetailSearchViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    
    private let viewModel: DetailSearchViewModel
    private let disposeBag = DisposeBag()
    
    private let viewWillAppearEvent = BehaviorRelay(value: false)
    
    //MARK: - Components
    
    private let rootView = DetailSearchView()
    
    //MARK: - Life Cycle
    
    init(viewModel: DetailSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewWillAppearEvent.accept(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        delegate()
        bindViewModel()
    }
    
    private func registerCell() {
        rootView.detailSearchInfoView.genreCollectionView.register(DetailSearchInfoGenreCollectionViewCell.self,
                                                                   forCellWithReuseIdentifier: DetailSearchInfoGenreCollectionViewCell.cellIdentifier)
        
        rootView.detailSearchKeywordView.categoryCollectionView.register(DetailSearchKeywordCategoryCollectionViewCell.self,
                                                                         forCellWithReuseIdentifier: DetailSearchKeywordCategoryCollectionViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.detailSearchInfoView.genreCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        rootView.detailSearchKeywordView.categoryCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Bind
    
    private func bindViewModel() {
        let input = DetailSearchViewModel.Input(
            viewWillAppearEvent: viewWillAppearEvent.asObservable(),
            cancelButtonDidTap: rootView.cancelModalButton.rx.tap,
            genreCollectionViewContentSize: rootView.detailSearchInfoView.genreCollectionView.rx.observe(CGSize.self, "contentSize"),
            infoTabDidTap: rootView.detailSearchHeaderView.infoLabel.rx.tapGesture().when(.recognized).asObservable(),
            keywordTabDidTap: rootView.detailSearchHeaderView.keywordLabel.rx.tapGesture().when(.recognized).asObservable()
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.cancelButtonEnabled
            .bind(with: self, onNext: { owner, _ in
                owner.dismissModalViewController()
            })
            .disposed(by: disposeBag)
        
        output.genreList
            .drive(rootView.detailSearchInfoView.genreCollectionView.rx.items(cellIdentifier: DetailSearchInfoGenreCollectionViewCell.cellIdentifier,cellType: DetailSearchInfoGenreCollectionViewCell.self)) { row, element, cell in
                cell.bindData(genre: element)
            }
            .disposed(by: disposeBag)
        
        output.selectedTab
            .drive(with: self, onNext: { owner, tab in
                owner.rootView.updateTab(selected: tab)
            })
            .disposed(by: disposeBag)
        
        output.keywordList
            .bind(to: rootView.detailSearchKeywordView.categoryCollectionView.rx.items(cellIdentifier: DetailSearchKeywordCategoryCollectionViewCell.cellIdentifier, cellType: DetailSearchKeywordCategoryCollectionViewCell.self)) { row, element, cell in
                cell.bindData(data: element)
            }
            .disposed(by: disposeBag)
    }
}

extension DetailSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == rootView.detailSearchInfoView.genreCollectionView {
            guard let text = viewModel.genreNameForItemAt(indexPath: indexPath) else {
                return CGSize(width: 0, height: 0)
            }
            
            let width = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 26
            return CGSize(width: width, height: 37)
        }
        else if collectionView == rootView.detailSearchKeywordView.categoryCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? DetailSearchKeywordCategoryCollectionViewCell else {
                return CGSize(width: 350, height: 228)
            }
            let height = cell.isExpanded ? cell.keywordCollectionView.contentSize.height + 146 : 228
            return CGSize(width: 350, height: height)
        }
        else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == rootView.detailSearchKeywordView.categoryCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? DetailSearchKeywordCategoryCollectionViewCell else {
                return
            }
            cell.toggleCollectionView()
            collectionView.performBatchUpdates(nil, completion: nil)
        }
    }
}
