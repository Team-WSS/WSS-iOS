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
        
        rootView.headerView.searchBar.becomeFirstResponder()
        hideTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
        setNavigationBar()
        
        registerCell()
        bindDataToSearchCollectionView()
        setCollectionViewLayout()
        setSearchAction()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    
    private func setNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = StringLiterals.Navigation.Title.search
        self.navigationController?.navigationBar.backgroundColor = .wssWhite
        
        if let navigationBar = self.navigationController?.navigationBar {
            let titleTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.Title2
            ]
            navigationBar.titleTextAttributes = titleTextAttributes
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
    }
    
    private func setCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 15
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width-40, height: 104)
        flowLayout.sectionInset = UIEdgeInsets(top: 13, left: 0, bottom: 54.5, right: 0)
        rootView.mainResultView.searchCollectionView.setCollectionViewLayout(flowLayout, animated: false)
    }
    
    //MARK: - Bind
    
    private func setDelegate() {
        rootView.headerView.searchBar.delegate = self
    }
    
    private func registerCell() {
        rootView.mainResultView.searchCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
    }
    
    //MARK: - Actions
    
    private func bindDataToSearchCollectionView() {
        searchResultListRelay.bind(to: rootView.mainResultView.searchCollectionView.rx.items(
            cellIdentifier: SearchCollectionViewCell.identifier,
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
}

//MARK: - Extensions

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        rootView.headerView.searchBar.resignFirstResponder()
    }
}
