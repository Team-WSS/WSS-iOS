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
        
        rootView.detailSearchKeywordView.categoryView.keywordCollectionView.register(DetailSearchInfoGenreCollectionViewCell.self, forCellWithReuseIdentifier: DetailSearchInfoGenreCollectionViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.detailSearchInfoView.genreCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        rootView.detailSearchKeywordView.categoryView.keywordCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Bind
    
    private func bindViewModel() {
        let input = DetailSearchViewModel.Input(
            cancelButtonDidTap: rootView.cancelModalButton.rx.tap,
            genreCollectionViewContentSize: rootView.detailSearchInfoView.genreCollectionView.rx.observe(CGSize.self, "contentSize"),
            infoTabDidTap: rootView.detailSearchHeaderView.infoLabel.rx.tapGesture().when(.recognized).asObservable(),
            keywordTabDidTap: rootView.detailSearchHeaderView.keywordLabel.rx.tapGesture().when(.recognized).asObservable(),
            keywordCollectionViewContentSize: rootView.detailSearchKeywordView.categoryView.keywordCollectionView.rx.observe(CGSize.self, "contentSize"))
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.cancelButtonEnabled
            .bind(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: false)
            })
            .disposed(by: disposeBag)
        
        output.genreList
            .drive(rootView.detailSearchInfoView.genreCollectionView.rx.items(cellIdentifier: DetailSearchInfoGenreCollectionViewCell.cellIdentifier, cellType: DetailSearchInfoGenreCollectionViewCell.self)) { row, element, cell in
                cell.bindData(genre: element)
            }
            .disposed(by: disposeBag)
        
        output.genreCollectionViewHeight
            .drive(with: self, onNext: { owner, height in
                owner.rootView.detailSearchInfoView.updateCollectionViewHeight(height: height)
            })
            .disposed(by: disposeBag)
        
        output.selectedTab
            .drive(with: self, onNext: { owner, tab in
                owner.rootView.updateTab(selected: tab)
            })
            .disposed(by: disposeBag)
        
        output.worldKeywordList
            .drive(rootView.detailSearchKeywordView.categoryView.keywordCollectionView.rx.items(cellIdentifier: DetailSearchInfoGenreCollectionViewCell.cellIdentifier, cellType: DetailSearchInfoGenreCollectionViewCell.self)) { row, element, cell in
                cell.bindData(genre: element)
            }
            .disposed(by: disposeBag)
        
        output.keywordCollectionViewHeight
            .drive(with: self, onNext: { owner, height in
                owner.rootView.detailSearchKeywordView.categoryView.updateCollectionViewHeight(height: height)
            })
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
        else if collectionView == rootView.detailSearchKeywordView.categoryView.keywordCollectionView {
            guard let text = viewModel.worldNameForItemAt(indexPath: indexPath) else {
                return CGSize(width: 0, height: 0)
            }
            
            let width = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 26
            return CGSize(width: width, height: 37)
        }
        else {
            return CGSize(width: 0, height: 0)
        }
    }
}
