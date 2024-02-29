//
//  SearchViewController.swift
//  WSSiOS
//
//  Created by 최서연 on 1/6/24.
//

import UIKit

import RxSwift
import RxCocoa
import Then

final class SearchViewController: UIViewController {
    
    //MARK: - Properties
    
    private let searchViewModel: SearchViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = SearchView()
    private let emptyView = SearchEmptyView()
    private let backButton = UIButton()
    
    //MARK: - Life Cycle
    
    init(searchViewModel: SearchViewModel) {
        self.searchViewModel = searchViewModel
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
        
        showSearchBarAndFocus()
        hideTabBar()
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.search,
                                    left: backButton,
                                    right: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        delegate()
        register()
        
        bindViewModel()
        swipeBackGesture()
    }
    
    //MARK: - UI
    
    private func setUI() {
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    //MARK: - Bind
    
    private func delegate() {
        rootView.headerView.searchBar.delegate = self
    }
    
    private func register() {
        rootView.mainResultView.searchCollectionView.register(
            SearchCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchCollectionViewCell.cellIdentifier)
    }

    //MARK: - Custom Method
    
    private func showSearchBarAndFocus() {
        rootView.headerView.searchBar.becomeFirstResponder()
    }
    
    private func bindViewModel() {
        let input = SearchViewModel.Input(
            searchTextUpdated: rootView.headerView.searchBar.rx.text.orEmpty,
            backButtonTapped: backButton.rx.tap,
            searchCellSelected: rootView.mainResultView.searchCollectionView.rx.itemSelected
        )
        
        let output = searchViewModel.transform(from: input, disposeBag: disposeBag)
        
        output.searchResultList
            .bind(to: rootView.mainResultView.searchCollectionView.rx.items(
                cellIdentifier: SearchCollectionViewCell.cellIdentifier,
                cellType: SearchCollectionViewCell.self)) { (row, element, cell) in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        output.searchResultList
            .asDriver()
            .drive(with: self, onNext: { owner, list in
                if list.isEmpty && !(owner.rootView.headerView.searchBar.text ?? "").isEmpty {
                    owner.view.addSubview(owner.emptyView)
                    owner.emptyView.snp.makeConstraints {
                        $0.edges.equalToSuperview()
                    }
                } else {
                    owner.emptyView.removeFromSuperview()
                }
            })
            .disposed(by: disposeBag)

        output.backToHome
            .bind(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        output.navigateToRegisterNormal
            .bind(with: self, onNext: { owner, indexPath in
                owner.pushToRegisterNormalViewController(
                    novelId: output.searchResultList.value[indexPath.row].novelId)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Extension

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        rootView.headerView.searchBar.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
}
