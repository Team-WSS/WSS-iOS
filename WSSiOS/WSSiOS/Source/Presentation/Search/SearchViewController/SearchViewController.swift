//
//  SearchViewController.swift
//  WSSiOS
//
//  Created by 최서연 on 1/6/24.
//

import UIKit

import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    
    //MARK: - Properties
    
    private let novelRepository: NovelRepository
    private var searchResultListRelay = BehaviorRelay<[SearchNovel]>(value: [])
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = SearchView()
    private let backButton = UIButton()
    
    //MARK: - Life Cycle
    
    init(novelRepository: NovelRepository) {
        self.novelRepository = novelRepository
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
        setDelegate()
        registerCell()
        
        bindDataToSearchCollectionView()
        setSearchAction()
    }

    //MARK: - UI
    
    private func setUI() {
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.rx.tap
                .subscribe(with: self ,onNext: { owner, _ in
                    owner.navigationController?.popViewController(animated: true)
                })
                .disposed(by: disposeBag)
        }
    }

    //MARK: - Bind
    
    private func setDelegate() {
        rootView.headerView.searchBar.delegate = self
    }
    
    private func registerCell() {
        rootView.mainResultView.searchCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.cellIdentifier)
    }
    
    //MARK: - Actions
    
    private func bindDataToSearchCollectionView() {
        searchResultListRelay.bind(to: rootView.mainResultView.searchCollectionView.rx.items(
            cellIdentifier: SearchCollectionViewCell.cellIdentifier,
            cellType: SearchCollectionViewCell.self)) { (row, element, cell) in
                cell.bindData(data: element)
            }
            .disposed(by: disposeBag)
        
        rootView.mainResultView.searchCollectionView
            .rx
            .itemSelected
            .subscribe(onNext:{ indexPath in
                self.navigationController?.pushViewController(
                    RegisterNormalViewController(
                        novelRepository: DefaultNovelRepository(
                            novelService: DefaultNovelService()),
                        userNovelRepository: DefaultUserNovelRepository(
                            userNovelService:DefaultUserNovelService()),
                        novelId: self.searchResultListRelay.value[indexPath.row].novelId),
                    animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func updateUI(searchList: [SearchNovel]) {
        Observable.just(searchList)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, list in
                owner.searchResultListRelay.accept(list)
            })
            .disposed(by: disposeBag)
    }
    
    private func searchNovels(with searchText: String) {
        let searchWord = searchText.isEmpty ? "" : searchText
        
        self.getDataFromAPI(disposeBag: disposeBag, searchWord: searchWord) { [weak self] searchResultList in
            self?.updateUI(searchList: searchResultList.novels)
        }
    }
    
    private func setSearchAction() {
        rootView.headerView.searchBar.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner ,searchText in
                if searchText.isEmpty {
                    owner.searchResultListRelay.accept([])
                } else {
                    owner.searchNovels(with: searchText)
                }
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - API
    
    private func getDataFromAPI(disposeBag: DisposeBag,
                                searchWord: String,
                                completion: @escaping (SearchNovels)
                                -> Void) {
        self.novelRepository.getSearchNovels(searchWord: searchWord)
            .subscribe (with: self, onNext: { owner, search in
                completion(search)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Custom
    
    private func showSearchBarAndFocus() {
        rootView.headerView.searchBar.becomeFirstResponder()
    }
}

//MARK: - Extensions

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        rootView.headerView.searchBar.resignFirstResponder()
    }
}
