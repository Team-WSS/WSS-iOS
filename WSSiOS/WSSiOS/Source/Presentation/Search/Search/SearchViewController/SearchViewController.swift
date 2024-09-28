//
//  SearchViewController.swift
//  WSSiOS
//
//  Created by 최서연 on 1/6/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

final class SearchViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: SearchViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = SearchView()
    
    //MARK: - Life Cycle
    
    init(viewModel: SearchViewModel) {
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
        
        showTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        registerCell()
        
        bindViewModel()
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.view.backgroundColor = .wssWhite
    }
    
    //MARK: - Bind
    
    private func registerCell() {
        rootView.sosopickView.sosopickCollectionView.register(
            SosoPickCollectionViewCell.self,
            forCellWithReuseIdentifier: SosoPickCollectionViewCell.cellIdentifier)
    }
    
    private func bindViewModel() {
        let input = SearchViewModel.Input(
            searhBarDidTap: rootView.searchbarView.rx.tapGesture().when(.recognized).asObservable(),
            induceButtonDidTap: rootView.searchDetailInduceView.rx.tapGesture().when(.recognized).asObservable()
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.sosoPickList
            .bind(to: rootView.sosopickView.sosopickCollectionView.rx.items(
                cellIdentifier: SosoPickCollectionViewCell.cellIdentifier,
                cellType: SosoPickCollectionViewCell.self)) { row, element, cell in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        output.searchBarEnabled
            .bind(with: self, onNext: { owner, _ in
                let viewController = NormalSearchViewController(viewModel: NormalSearchViewModel(searchRepository: DefaultSearchRepository(searchService: DefaultSearchService())))
                viewController.navigationController?.isNavigationBarHidden = false
                viewController.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.induceButtonEnabled
            .bind(with: self, onNext: { owner, _ in
                let detailSearchViewController = DetailSearchViewController(viewModel: DetailSearchViewModel(keywordRepository: DefaultKeywordRepository(keywordService: DefaultKeywordService()), selectedKeywordList: []))
                detailSearchViewController.navigationController?.isNavigationBarHidden = false
                detailSearchViewController.hidesBottomBarWhenPushed = true
                owner.presentModalViewController(detailSearchViewController)
            })
            .disposed(by: disposeBag)
    }
}
