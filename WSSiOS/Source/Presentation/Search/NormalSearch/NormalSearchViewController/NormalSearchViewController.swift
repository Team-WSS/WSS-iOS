//
//  NormalSearchViewController.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/27/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

final class NormalSearchViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    
    private let viewModel: NormalSearchViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = NormalSearchView()
    private let emptyView = NormalSearchEmptyView()
    
    //MARK: - Life Cycle
    
    init(viewModel: NormalSearchViewModel) {
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
        
        setNavigationBar()
        swipeBackGesture()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        registerCell()
        setDelegate()
        bindViewModel()
        bindAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let initialText = viewModel.initialSearchText {
            rootView.headerView.searchTextField.text = initialText
            rootView.headerView.searchTextField.sendActions(for: .valueChanged)
            rootView.headerView.searchTextField.sendActions(for: .editingDidEndOnExit)
        } else {
            rootView.headerView.searchTextField.becomeFirstResponder()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - UI
    
    private func setNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setUI() {
        self.view.backgroundColor = .wssWhite
    }
    
    //MARK: - Bind
    
    private func registerCell() {
        rootView.resultView.normalSearchCollectionView.register(
            NormalSearchCollectionViewCell.self,
            forCellWithReuseIdentifier: NormalSearchCollectionViewCell.cellIdentifier)
        rootView.sosoPickView.sosopickCollectionView.register(
            SosoPickCollectionViewCell.self,
            forCellWithReuseIdentifier: SosoPickCollectionViewCell.cellIdentifier)
    }
    
    private func setDelegate() {
        rootView.headerView.searchTextField.delegate = self
    }
    
    private func bindViewModel() {
        let reachedBottom = rootView.resultView.scrollView.rx.didScroll
            .map { self.isNearBottomEdge() }
            .distinctUntilChanged()
            .asObservable()
        
        let collectionViewSwipeGesture = rootView.resultView.normalSearchCollectionView.rx.swipeGesture([.up, .down])
            .when(.recognized)
            .asObservable()
        
        let input = NormalSearchViewModel.Input(
            searchTextUpdated: rootView.headerView.searchTextField.rx.text.orEmpty,
            searchTextFieldEditingDidBegin: rootView.headerView.searchTextField.rx.controlEvent(.editingDidBegin).asControlEvent(),
            searchTextFieldEditingDidEnd: rootView.headerView.searchTextField.rx.controlEvent(.editingDidEnd).asControlEvent(),
            returnKeyDidTap: rootView.headerView.searchTextField.rx.controlEvent(.editingDidEndOnExit),
            searchButtonDidTap: rootView.headerView.searchButton.rx.tap,
            clearButtonDidTap: rootView.headerView.searchClearButton.rx.tap,
            backButtonDidTap: rootView.headerView.backButton.rx.tap,
            inquiryButtonDidTap: rootView.emptyView.inquiryButton.rx.tap,
            normalSearchCollectionViewContentSize: rootView.resultView.normalSearchCollectionView.rx.observe(CGSize.self, "contentSize"),
            normalSearchCellSelected: rootView.resultView.normalSearchCollectionView.rx.itemSelected,
            reachedBottom: reachedBottom,
            normalSearchCollectionViewSwipeGesture: collectionViewSwipeGesture,
            sosoPickCellSelected: rootView.sosoPickView.sosopickCollectionView.rx.itemSelected)
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.resultCount
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, data in
                self.rootView.resultView.resultCountView.bindData(data: data)
            })
            .disposed(by: disposeBag)
        
        output.normalSearchList
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.resultView.normalSearchCollectionView.rx.items(
                cellIdentifier: NormalSearchCollectionViewCell.cellIdentifier,
                cellType: NormalSearchCollectionViewCell.self)) { row, element, cell in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        output.normalSearchList
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext: { owner, novels in
                if owner.rootView.headerView.searchTextField.text == "" {
                    owner.rootView.emptyView.isHidden = true
                    owner.rootView.resultView.isHidden = true
                    owner.rootView.resultView.resultCountView.isHidden = true
                    owner.rootView.sosoPickView.isHidden = false
                }
                else if novels.isEmpty {
                    owner.rootView.emptyView.isHidden = false
                    owner.rootView.resultView.isHidden = true
                    owner.rootView.resultView.resultCountView.isHidden = true
                    owner.rootView.sosoPickView.isHidden = true
                }
                else {
                    owner.rootView.emptyView.isHidden = true
                    owner.rootView.resultView.isHidden = false
                    owner.rootView.resultView.resultCountView.isHidden = false
                    owner.rootView.sosoPickView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        output.scrollToTop
            .subscribe(with: self, onNext: { owner, _ in
                owner.rootView.resultView.scrollView.setContentOffset(.zero, animated: false)
            })
            .disposed(by: disposeBag)
        
        output.scrollToTopAndendEditing
            .subscribe(with: self, onNext: { owner, _ in
                owner.view.endEditing(true)
                owner.rootView.resultView.scrollView.setContentOffset(.zero, animated: false)
            })
            .disposed(by: disposeBag)
        
        output.clearButtonEnabled
            .subscribe(with: self, onNext: { owner, _ in
                owner.rootView.headerView.searchTextField.text = ""
            })
            .disposed(by: disposeBag)
        
        output.popViewController
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        output.inquiryButtonEnabled
            .subscribe(with: self, onNext: { owner, _ in
                if let url = URL(string: ExternalLinks.inquiryAddNovel) {
                    UIApplication.shared.open(url, options: [:])
                }
            })
            .disposed(by: disposeBag)

        output.normalSearchCollectionViewHeight
            .drive(with: self, onNext: { owner, height in
                owner.rootView.resultView.updateCollectionViewHeight(height: height)
            })
            .disposed(by: disposeBag)
        
        output.pushToNovelDetailViewController
            .subscribe(with: self, onNext: { owner, novelId in
                owner.pushToNovelDetailViewController(novelId: novelId)
            })
            .disposed(by: disposeBag)
        
        output.isSearchTextFieldEditing
            .subscribe(with: self, onNext: { owner, isEditing in
                owner.rootView.headerView.updateSearchTextField(isEditing: isEditing)
            })
            .disposed(by: disposeBag)
        
        output.endEditing
            .subscribe(with: self, onNext: { owner, _ in
                owner.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        output.showLoadingView
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, isShow in
                owner.rootView.showLoadingView(isShow: isShow)
            })
            .disposed(by: disposeBag)

        output.sosoPickList
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.sosoPickView.sosopickCollectionView.rx.items(
                cellIdentifier: SosoPickCollectionViewCell.cellIdentifier,
                cellType: SosoPickCollectionViewCell.self)) { _, element, cell in
                    cell.bindData(data: element)
                }
            .disposed(by: disposeBag)

        output.presentToInduceLoginView
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                owner.presentInduceLoginViewController()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAction() {
        rootView.resultView.resultCountView.noSearchResultLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe(with: self, onNext: { owner, _ in
                if let url = URL(string: ExternalLinks.inquiryAddNovel) {
                    UIApplication.shared.open(url, options: [:])
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func isNearBottomEdge() -> Bool {
        guard self.rootView.resultView.scrollView.contentSize.height > 0 else {
            return false
        }
        
        let checkNearBottomEdge = self.rootView.resultView.scrollView.contentOffset.y + self.rootView.resultView.scrollView.bounds.size.height + 1.0 >= self.rootView.resultView.scrollView.contentSize.height
        
        return checkNearBottomEdge
    }
}

extension NormalSearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, 
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return newText.count <= 30
    }
}
