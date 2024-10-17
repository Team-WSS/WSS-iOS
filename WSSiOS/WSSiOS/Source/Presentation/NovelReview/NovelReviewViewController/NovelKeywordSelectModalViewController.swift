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
    private let keywordCategoryListData = BehaviorRelay<[KeywordCategory]>(value: [])
    private let selectedKeywordData = PublishRelay<KeywordData>()
    private let deselectedKeywordData = PublishRelay<KeywordData>()
    
    private var keywordCategoryList: [KeywordCategory] = []
    
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
        
        viewDidLoadEvent.accept(())
    }
    
    //MARK: - UI
    
    private func register() {
        rootView.novelSelectedKeywordListView.selectedKeywordCollectionView.register(NovelSelectedKeywordCollectionViewCell.self, forCellWithReuseIdentifier: NovelSelectedKeywordCollectionViewCell.cellIdentifier)
        rootView.novelKeywordSelectSearchResultView.searchResultCollectionView.register(NovelKeywordSelectSearchResultCollectionViewCell.self, forCellWithReuseIdentifier: NovelKeywordSelectSearchResultCollectionViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.novelSelectedKeywordListView.selectedKeywordCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        rootView.novelKeywordSelectSearchResultView.searchResultCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Bind
    
    private func bindViewModel() {
        let input = NovelKeywordSelectModalViewModel.Input(
            viewDidLoadEvent: viewDidLoadEvent.asObservable(),
            updatedEnteredText: rootView.novelKeywordSelectSearchBarView.keywordTextField.rx.text.orEmpty.distinctUntilChanged().asObservable(),
            keywordTextFieldEditingDidBegin: rootView.novelKeywordSelectSearchBarView.keywordTextField.rx.controlEvent(.editingDidBegin).asControlEvent(),
            keywordTextFieldEditingDidEnd: rootView.novelKeywordSelectSearchBarView.keywordTextField.rx.controlEvent(.editingDidEnd).asControlEvent(),
            keywordTextFieldEditingDidEndOnExit: rootView.novelKeywordSelectSearchBarView.keywordTextField.rx.controlEvent(.editingDidEndOnExit).asControlEvent(),
            searchCancelButtonDidTap: rootView.novelKeywordSelectSearchBarView.searchCancelButton.rx.tap,
            closeButtonDidTap: rootView.closeButton.rx.tap,
            searchButtonDidTap: rootView.novelKeywordSelectSearchBarView.searchButton.rx.tap,
            selectedKeywordCollectionViewItemSelected: rootView.novelSelectedKeywordListView.selectedKeywordCollectionView.rx.itemSelected.asObservable(),
            searchResultCollectionViewItemSelected: rootView.novelKeywordSelectSearchResultView.searchResultCollectionView.rx.itemSelected.asObservable(),
            searchResultCollectionViewItemDeselected: rootView.novelKeywordSelectSearchResultView.searchResultCollectionView.rx.itemDeselected.asObservable(),
            resetButtonDidTap: rootView.novelKeywordSelectModalButtonView.resetButton.rx.tap,
            selectButtonDidTap: rootView.novelKeywordSelectModalButtonView.selectButton.rx.tap,
            contactButtonDidTap: rootView.novelKeywordSelectEmptyView.contactButton.rx.tap,
            selectedKeywordData: selectedKeywordData.asObservable(),
            deselectedKeywordData: deselectedKeywordData.asObservable()
        )
        
        let output = self.novelKeywordSelectModalViewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.dismissModalViewController
            .subscribe(with: self, onNext: { owner, _ in
                owner.dismissModalViewController()
            })
            .disposed(by: disposeBag)
        
        output.enteredText
            .subscribe(with: self, onNext: { owner, text in
                owner.rootView.novelKeywordSelectSearchBarView.keywordTextField.text = text
            })
            .disposed(by: disposeBag)
        
        output.isKeywordTextFieldEditing
            .subscribe(with: self, onNext: { owner, isEditing in
                owner.rootView.novelKeywordSelectSearchBarView.updateKeywordTextField(isEditing: isEditing)
            })
            .disposed(by: disposeBag)
        
        output.endEditing
            .subscribe(with: self, onNext: { owner, _ in
                owner.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        output.selectedKeywordListData
            .subscribe(with: self, onNext: { owner, selectedKeywordList in
                owner.rootView.novelKeywordSelectModalButtonView.updateSelectLabelText(keywordCount: selectedKeywordList.count)
                owner.rootView.updateNovelKeywordSelectModalViewLayout(isSelectedKeyword: !selectedKeywordList.isEmpty)
                owner.keywordCategoryListData.accept(owner.keywordCategoryList)
            })
            .disposed(by: disposeBag)
        
        output.selectedKeywordListData
            .bind(to: rootView.novelSelectedKeywordListView.selectedKeywordCollectionView.rx.items(cellIdentifier: NovelSelectedKeywordCollectionViewCell.cellIdentifier, cellType: NovelSelectedKeywordCollectionViewCell.self)) { item, element, cell in
                cell.bindData(keyword: element)
            }
            .disposed(by: disposeBag)
        
        output.keywordSearchResultListData
            .subscribe(with: self, onNext: { owner, searchResultList in
                owner.rootView.showSearchResultView(show: !searchResultList.isEmpty)
                owner.rootView.showEmptyView(show: searchResultList.isEmpty)
            })
            .disposed(by: disposeBag)
        
        output.keywordSearchResultListData
            .bind(to: rootView.novelKeywordSelectSearchResultView.searchResultCollectionView.rx.items(cellIdentifier: NovelKeywordSelectSearchResultCollectionViewCell.cellIdentifier, cellType: NovelKeywordSelectSearchResultCollectionViewCell.self)) { item, element, cell in
                let indexPath = IndexPath(item: item, section: 0)
                
                if self.novelKeywordSelectModalViewModel.selectedKeywordList.contains(where: { $0.keywordId == element.keywordId }) {
                    self.rootView.novelKeywordSelectSearchResultView.searchResultCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                } else {
                    self.rootView.novelKeywordSelectSearchResultView.searchResultCollectionView.deselectItem(at: indexPath, animated: false)
                }
                cell.bindData(keyword: element)
            }
            .disposed(by: disposeBag)
        
        output.keywordCategoryListData
            .subscribe(with: self, onNext: { owner, keywordCategoryListData in
                owner.keywordCategoryList = keywordCategoryListData
                owner.keywordCategoryListData.accept(owner.keywordCategoryList)
                owner.setupKeywordCategoryStackView()
                owner.rootView.showCategoryListView(show: true)
            })
            .disposed(by: disposeBag)
        
        output.isKeywordCountOverLimit
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.rootView.novelKeywordSelectSearchResultView.searchResultCollectionView.deselectItem(at: indexPath, animated: false)
                owner.showToast(.selectionOverLimit(count: 20))
            })
            .disposed(by: disposeBag)
        
        output.showEmptyView
            .subscribe(with: self, onNext: { owner, show in
                owner.rootView.showEmptyView(show: show)
            })
            .disposed(by: disposeBag)
        
        output.showCategoryListView
            .subscribe(with: self, onNext: { owner, show in
                owner.rootView.showCategoryListView(show: show)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Custom Method
    
    private func setupKeywordCategoryStackView() {
        for (index, category) in self.keywordCategoryList.enumerated() {
            let novelKeywordSelectCategoryView = NovelKeywordSelectCategoryView(keywordCategory: category)
            
            self.rootView.novelKeywordSelectCategoryListView.stackView.addArrangedSubview(novelKeywordSelectCategoryView)
            
            keywordCategoryListData
                .map { categories in categories[index].keywords }
                .bind(to: novelKeywordSelectCategoryView.categoryCollectionView.rx.items(cellIdentifier: NovelKeywordSelectSearchResultCollectionViewCell.cellIdentifier, cellType: NovelKeywordSelectSearchResultCollectionViewCell.self)) { item, element, cell in
                    let indexPath = IndexPath(item: item, section: 0)
                    
                    if self.novelKeywordSelectModalViewModel.selectedKeywordList.contains(where: { $0.keywordId == element.keywordId }) {
                        novelKeywordSelectCategoryView.categoryCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                    } else {
                        novelKeywordSelectCategoryView.categoryCollectionView.deselectItem(at: indexPath, animated: false)
                    }
                    cell.bindData(keyword: element)
                }
                .disposed(by: disposeBag)
            
            novelKeywordSelectCategoryView.categoryCollectionView.rx.itemSelected
                .subscribe(with: self, onNext: { owner, indexPath in
                    if owner.novelKeywordSelectModalViewModel.selectedKeywordList.count >= owner.novelKeywordSelectModalViewModel.keywordLimit {
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

extension NovelKeywordSelectModalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 1 {
            var text: String?
            
            text = self.novelKeywordSelectModalViewModel.selectedKeywordList[indexPath.item].keywordName
            
            guard let unwrappedText = text else {
                return CGSize(width: 0, height: 0)
            }
            
            let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 52
            return CGSize(width: width, height: 35)
        } else if collectionView.tag == 2 {
            var text: String?
            
            text = self.novelKeywordSelectModalViewModel.keywordSearchResultList[indexPath.item].keywordName
            
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
