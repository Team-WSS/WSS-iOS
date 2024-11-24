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
        setNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        registerCell()
        
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.view.backgroundColor = .wssWhite
    }
    
    private func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
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
            induceButtonDidTap: rootView.searchDetailInduceView.rx.tapGesture().when(.recognized).asObservable(),
            sosoPickCellSelected: rootView.sosopickView.sosopickCollectionView.rx.itemSelected.asObservable(),
            pushToDetailSearchResultNotification: NotificationCenter.default.rx.notification(Notification.Name("PushToDetailSearchResult")).asObservable()
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.sosoPickList
            .bind(to: rootView.sosopickView.sosopickCollectionView.rx.items(
                cellIdentifier: SosoPickCollectionViewCell.cellIdentifier,
                cellType: SosoPickCollectionViewCell.self)) { row, element, cell in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        output.pushToNormalSearchViewController
            .bind(with: self, onNext: { owner, _ in
                owner.pushToNormalSearchViewController()
            })
            .disposed(by: disposeBag)
        
        output.pushToDetailSearchViewController
            .bind(with: self, onNext: { owner, _ in
                owner.presentToDetailSearchViewController(selectedKeywordList: [],
                                                          previousViewInfo: .search,
                                                          selectedFilteredQuery: SearchFilterQuery(keywords: [],
                                                                                                   genres: [],
                                                                                                   isCompleted: nil,
                                                                                                   novelRating: nil))
            })
            .disposed(by: disposeBag)
        
        output.pushToNovelDetailViewController
            .bind(with: self, onNext: { owner, novelId in
                owner.pushToDetailViewController(novelId: novelId)
            })
            .disposed(by: disposeBag)
        
        output.pushToDetailSearchResultView
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, notification in
                if let userInfo = notification.userInfo {
                    let keywords = userInfo["keywords"] as? [KeywordData]
                    let genres = userInfo["genres"] as? [NovelGenre]
                    let isCompleted = userInfo["isCompleted"] as? Bool
                    let novelRating = userInfo["novelRating"] as? Float
                    
                    let detailSearchResultViewModel = DetailSearchResultViewModel(
                        searchRepository: DefaultSearchRepository(searchService: DefaultSearchService()),
                        keywords: keywords ?? [],
                        genres: genres ?? [],
                        isCompleted: isCompleted,
                        novelRating: novelRating
                    )

                    let detailSearchResultViewController = DetailSearchResultViewController(viewModel: detailSearchResultViewModel)
                    
                    detailSearchResultViewController.navigationController?.isNavigationBarHidden = false
                    detailSearchResultViewController.hidesBottomBarWhenPushed = true
                    
                    owner.navigationController?.pushViewController(detailSearchResultViewController, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        output.presentToInduceLoginView
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                owner.presentInduceLoginViewController()
            })
            .disposed(by: disposeBag)
    }
}
