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
    private let viewDidLoadEvent = PublishRelay<Void>()
    private let keywordCategoryListData = BehaviorRelay<[KeywordCategory]>(value: [])
    private let selectedKeywordData = PublishRelay<KeywordData>()
    private let deselectedKeywordData = PublishRelay<KeywordData>()
    
    private var keywordCategoryList: [KeywordCategory] = []
    
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
        
        viewDidLoadEvent.accept(())
    }
    
    private func registerCell() {
        rootView.detailSearchInfoView.genreCollectionView.register(DetailSearchInfoGenreCollectionViewCell.self,
                                                                   forCellWithReuseIdentifier: DetailSearchInfoGenreCollectionViewCell.cellIdentifier)
        
        rootView.detailSearchKeywordView.novelSelectedKeywordListView.selectedKeywordCollectionView.register(NovelSelectedKeywordCollectionViewCell.self, forCellWithReuseIdentifier: NovelSelectedKeywordCollectionViewCell.cellIdentifier)
        rootView.detailSearchKeywordView.novelKeywordSelectSearchResultView.searchResultCollectionView.register(NovelKeywordSelectSearchResultCollectionViewCell.self, forCellWithReuseIdentifier: NovelKeywordSelectSearchResultCollectionViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.detailSearchInfoView.genreCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        rootView.detailSearchKeywordView.novelSelectedKeywordListView.selectedKeywordCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        rootView.detailSearchKeywordView.novelKeywordSelectSearchResultView.searchResultCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Bind
    
    private func bindViewModel() {
        let input = DetailSearchViewModel.Input(
            viewWillAppearEvent: viewWillAppearEvent.asObservable(),
            cancelButtonDidTap: rootView.cancelModalButton.rx.tap,
            genreCollectionViewContentSize: rootView.detailSearchInfoView.genreCollectionView.rx.observe(CGSize.self, "contentSize"),
            infoTabDidTap: rootView.detailSearchHeaderView.infoLabel.rx.tapGesture().when(.recognized).asObservable(),
            keywordTabDidTap: rootView.detailSearchHeaderView.keywordLabel.rx.tapGesture().when(.recognized).asObservable(),
            viewDidLoadEvent: viewDidLoadEvent.asObservable(),
            updatedEnteredText: rootView.detailSearchKeywordView.novelKeywordSelectSearchBarView.keywordTextField.rx.text.orEmpty.distinctUntilChanged().asObservable(),
            keywordTextFieldEditingDidBegin: rootView.detailSearchKeywordView.novelKeywordSelectSearchBarView.keywordTextField.rx.controlEvent(.editingDidBegin).asControlEvent(),
            keywordTextFieldEditingDidEnd: rootView.detailSearchKeywordView.novelKeywordSelectSearchBarView.keywordTextField.rx.controlEvent(.editingDidEnd).asControlEvent(),
            keywordTextFieldEditingDidEndOnExit: rootView.detailSearchKeywordView.novelKeywordSelectSearchBarView.keywordTextField.rx.controlEvent(.editingDidEndOnExit).asControlEvent(),
            searchCancelButtonDidTap: rootView.detailSearchKeywordView.novelKeywordSelectSearchBarView.searchCancelButton.rx.tap,
            closeButtonDidTap: rootView.cancelModalButton.rx.tap,
            searchButtonDidTap: rootView.detailSearchKeywordView.novelKeywordSelectSearchBarView.searchButton.rx.tap,
            selectedKeywordCollectionViewItemSelected: rootView.detailSearchKeywordView.novelSelectedKeywordListView.selectedKeywordCollectionView.rx.itemSelected.asObservable(),
            searchResultCollectionViewItemSelected: rootView.detailSearchKeywordView.novelKeywordSelectSearchResultView.searchResultCollectionView.rx.itemSelected.asObservable(),
            searchResultCollectionViewItemDeselected: rootView.detailSearchKeywordView.novelKeywordSelectSearchResultView.searchResultCollectionView.rx.itemDeselected.asObservable(),
            resetButtonDidTap: rootView.detailSearchKeywordView.novelKeywordSelectModalButtonView.resetButton.rx.tap,
            selectButtonDidTap: rootView.detailSearchKeywordView.novelKeywordSelectModalButtonView.selectButton.rx.tap,
            contactButtonDidTap: rootView.detailSearchKeywordView.novelKeywordSelectEmptyView.contactButton.rx.tap,
            selectedKeywordData: selectedKeywordData.asObservable(),
            deselectedKeywordData: deselectedKeywordData.asObservable()
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
        
        output.dismissModalViewController
            .subscribe(with: self, onNext: { owner, _ in
                owner.dismissModalViewController()
            })
            .disposed(by: disposeBag)
        
        output.enteredText
            .subscribe(with: self, onNext: { owner, text in
                owner.rootView.detailSearchKeywordView.novelKeywordSelectSearchBarView.keywordTextField.text = text
            })
            .disposed(by: disposeBag)
        
        output.isKeywordTextFieldEditing
            .subscribe(with: self, onNext: { owner, isEditing in
                owner.rootView.detailSearchKeywordView.novelKeywordSelectSearchBarView.updateKeywordTextField(isEditing: isEditing)
            })
            .disposed(by: disposeBag)
        
        output.endEditing
            .subscribe(with: self, onNext: { owner, _ in
                owner.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        output.selectedKeywordListData
            .subscribe(with: self, onNext: { owner, selectedKeywordList in
                owner.rootView.detailSearchKeywordView.novelKeywordSelectModalButtonView.updateSelectLabelText(keywordCount: selectedKeywordList.count)
                owner.rootView.detailSearchKeywordView.updateNovelKeywordSelectModalViewLayout(isSelectedKeyword: !selectedKeywordList.isEmpty)
                owner.keywordCategoryListData.accept(owner.keywordCategoryList)
            })
            .disposed(by: disposeBag)
        
        output.selectedKeywordListData
            .bind(to: rootView.detailSearchKeywordView.novelSelectedKeywordListView.selectedKeywordCollectionView.rx.items(cellIdentifier: NovelSelectedKeywordCollectionViewCell.cellIdentifier, cellType: NovelSelectedKeywordCollectionViewCell.self)) { item, element, cell in
                cell.bindData(keyword: element)
            }
            .disposed(by: disposeBag)
        
        output.keywordSearchResultListData
            .subscribe(with: self, onNext: { owner, searchResultList in
                owner.rootView.detailSearchKeywordView.showSearchResultView(show: !searchResultList.isEmpty)
                owner.rootView.detailSearchKeywordView.showEmptyView(show: searchResultList.isEmpty)
            })
            .disposed(by: disposeBag)
        
        output.keywordSearchResultListData
            .bind(to: rootView.detailSearchKeywordView.novelKeywordSelectSearchResultView.searchResultCollectionView.rx.items(cellIdentifier: NovelKeywordSelectSearchResultCollectionViewCell.cellIdentifier, cellType: NovelKeywordSelectSearchResultCollectionViewCell.self)) { item, element, cell in
                let indexPath = IndexPath(item: item, section: 0)
                
                if self.viewModel.selectedKeywordList.contains(where: { $0.keywordId == element.keywordId }) {
                    self.rootView.detailSearchKeywordView.novelKeywordSelectSearchResultView.searchResultCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                } else {
                    self.rootView.detailSearchKeywordView.novelKeywordSelectSearchResultView.searchResultCollectionView.deselectItem(at: indexPath, animated: false)
                }
                cell.bindData(keyword: element)
            }
            .disposed(by: disposeBag)
        
        output.keywordCategoryListData
            .subscribe(with: self, onNext: { owner, keywordCategoryListData in
                owner.keywordCategoryList = keywordCategoryListData
                owner.keywordCategoryListData.accept(owner.keywordCategoryList)
                owner.setupKeywordCategoryStackView()
                owner.rootView.detailSearchKeywordView.showCategoryListView(show: true)
            })
            .disposed(by: disposeBag)
        
        output.isKeywordCountOverLimit
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.rootView.detailSearchKeywordView.novelKeywordSelectSearchResultView.searchResultCollectionView.deselectItem(at: indexPath, animated: false)
                owner.showToast(.selectionOverLimit(count: 20))
            })
            .disposed(by: disposeBag)
        
        output.showEmptyView
            .subscribe(with: self, onNext: { owner, show in
                owner.rootView.detailSearchKeywordView.showEmptyView(show: show)
            })
            .disposed(by: disposeBag)
        
        output.showCategoryListView
            .subscribe(with: self, onNext: { owner, show in
                owner.rootView.detailSearchKeywordView.showCategoryListView(show: show)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Custom Method
    
    private func setupKeywordCategoryStackView() {
        for (index, category) in self.keywordCategoryList.enumerated() {
            let novelKeywordSelectCategoryView = NovelKeywordSelectCategoryView(keywordCategory: category)
            
            self.rootView.detailSearchKeywordView.novelKeywordSelectCategoryListView.stackView.addArrangedSubview(novelKeywordSelectCategoryView)
            
            keywordCategoryListData
                .map { categories in categories[index].keywords }
                .bind(to: novelKeywordSelectCategoryView.categoryCollectionView.rx.items(cellIdentifier: NovelKeywordSelectSearchResultCollectionViewCell.cellIdentifier, cellType: NovelKeywordSelectSearchResultCollectionViewCell.self)) { item, element, cell in
                    let indexPath = IndexPath(item: item, section: 0)
                    
                    if self.viewModel.selectedKeywordList.contains(where: { $0.keywordId == element.keywordId }) {
                        novelKeywordSelectCategoryView.categoryCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                    } else {
                        novelKeywordSelectCategoryView.categoryCollectionView.deselectItem(at: indexPath, animated: false)
                    }
                    cell.bindData(keyword: element)
                }
                .disposed(by: disposeBag)
            
            novelKeywordSelectCategoryView.categoryCollectionView.rx.itemSelected
                .subscribe(with: self, onNext: { owner, indexPath in
                    if owner.viewModel.selectedKeywordList.count >= owner.viewModel.keywordLimit {
                        novelKeywordSelectCategoryView.categoryCollectionView.deselectItem(at: indexPath, animated: false)
                        owner.showToast(.selectionOverLimit(count: 20))
                    } else {
                        owner.selectedKeywordData.accept(category.keywords[indexPath.item])
                    }
                })
                .disposed(by: disposeBag)
            
            novelKeywordSelectCategoryView.categoryCollectionView.rx.itemDeselected
                .subscribe(with: self, onNext: { owner, indexPath in
                    owner.deselectedKeywordData.accept(category.keywords[indexPath.item])
                })
                .disposed(by: disposeBag)
            
            novelKeywordSelectCategoryView.expandButton.rx.tap
                .subscribe(onNext: { _ in
                    novelKeywordSelectCategoryView.expandCategoryCollectionView()
                })
                .disposed(by: disposeBag)
            
            novelKeywordSelectCategoryView.categoryCollectionView.rx.observe(CGSize.self, "contentSize")
                .map { $0?.height ?? 0 }
                .subscribe(onNext: { height in
                    novelKeywordSelectCategoryView.collectionViewHeight = height
                })
                .disposed(by: disposeBag)
        }
    }
}

extension DetailSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == rootView.detailSearchInfoView.genreCollectionView {
            guard let text = viewModel.genreNameForItemAt(indexPath: indexPath) else {
                return CGSize(width: 0, height: 0)
            }
            
            let width = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 26
            return CGSize(width: width, height: 35)
        }
        if collectionView ==  rootView.detailSearchKeywordView.novelSelectedKeywordListView.selectedKeywordCollectionView{
            var text: String?
            
            text = self.viewModel.selectedKeywordList[indexPath.item].keywordName
            
            guard let unwrappedText = text else {
                return CGSize(width: 0, height: 0)
            }
            
            let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 52
            return CGSize(width: width, height: 35)
        } else if collectionView == rootView.detailSearchKeywordView.novelKeywordSelectSearchResultView.searchResultCollectionView {
            var text: String?
            
            text = self.viewModel.keywordSearchResultList[indexPath.item].keywordName
            
            guard let unwrappedText = text else {
                return CGSize(width: 0, height: 0)
            }
            
            let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 26
            return CGSize(width: width, height: 35)
        } else {
            return CGSize()
        }
    }

}
