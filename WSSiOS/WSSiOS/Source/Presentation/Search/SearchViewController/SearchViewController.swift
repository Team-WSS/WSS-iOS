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
    
    //MARK: - UI Components
    
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
    
    //MARK: - set UI
    
    private func setUI() {
        backButton.do {
            $0.setImage(ImageLiterals.icon.navigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                })
                .disposed(by: disposeBag)
        }
    }
    
    //MARK: - customize NaivationBar
    
    private func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "검색"
        self.navigationController?.navigationBar.backgroundColor = .White
        
        // Navigation Bar의 title 폰트 설정
        if let navigationBar = self.navigationController?.navigationBar {
            let titleTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.Title2
            ]
            navigationBar.titleTextAttributes = titleTextAttributes
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
    }
    
    //MARK: - set Delegate
    
    private func setDelegate() {
        rootView.headerView.searchBar.delegate = self
    }
    
    private func setCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 15
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width-40, height: 104)
        flowLayout.sectionInset = UIEdgeInsets(top: 13, left: 0, bottom: 54.5, right: 0)
        rootView.mainResultView.searchCollectionView.setCollectionViewLayout(flowLayout, animated: false)
    }
    
    private func registerCell() {
        rootView.mainResultView.searchCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
    }
    
    private func getDataFromAPI(disposeBag: DisposeBag,
                                searchWord: String,
                                completion: @escaping (SearchNovels)
                                -> Void) {
        self.novelRepository.getSearchNovels(searchWord: searchWord)
            .subscribe (
                onNext: { [weak self] search in
                    guard self != nil else { return }
                    
                    completion(search)
                },
                onError: { error in
                    print(error)
                })
            .disposed(by: disposeBag)
    }
    
    private func bindDataToSearchCollectionView() {
        searchResultListRelay.bind(to: rootView.mainResultView.searchCollectionView.rx.items(
            cellIdentifier: SearchCollectionViewCell.identifier,
            cellType: SearchCollectionViewCell.self)) { (row, element, cell) in
                cell.bindData(data: element)
            }
            .disposed(by: disposeBag)
    }
    
    func updateUI(searchList: [SearchNovel]) {
        Observable.just(searchList)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] list in
                self?.searchResultListRelay.accept(list)
            })
            .disposed(by: disposeBag)
    }
    
    func searchNovels(with searchText: String) {
        let searchWord = searchText.isEmpty ? "" : searchText
        
        self.getDataFromAPI(disposeBag: disposeBag, searchWord: searchWord) { [weak self] searchResultList in
            self?.updateUI(searchList: searchResultList.novels)
        }
    }
    
    func setSearchAction() {
        let searchTextObservable = rootView.headerView.searchBar.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
        
        searchTextObservable
            .subscribe(onNext: { [weak self] searchText in
                if searchText.isEmpty {
                    // 아무것도 입력하지 않았을 때, 테이블뷰 내 데이터에 빈 배열 삽입
                    self?.searchResultListRelay.accept([])
                } else {
                    self?.searchNovels(with: searchText)
                }
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Extensions

extension SearchViewController: UISearchBarDelegate {}
