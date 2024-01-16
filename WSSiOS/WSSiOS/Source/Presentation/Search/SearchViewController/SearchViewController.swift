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
        
        bindDataToUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setNavigationBar()
        
        registerCell()
        bindDataToSearchCollectionView()
        setCollectionViewLayout()
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
        
        //self.navigationItem.hidesBackButton = true
    }
    
    //MARK: - set Delegate
    
    private func setDelegate() {
        rootView.headerView.searchBar.delegate = self
    }
    
    private func registerCell() {
        rootView.mainResultView.searchCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
    }
    
    private func setCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 15
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width-40, height: 104)
        flowLayout.sectionInset = UIEdgeInsets(top: 13, left: 0, bottom: 54.5, right: 0)
        rootView.mainResultView.searchCollectionView.setCollectionViewLayout(flowLayout, animated: false)
    }
    
    private func getDataFromAPI(disposeBag: DisposeBag,
                                completion: @escaping (SearchNovels)
                                -> Void) {
        self.novelRepository.getSearchNovels()
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
    
    private func bindDataToUI() {
        self.getDataFromAPI(disposeBag: disposeBag) { [weak self] searchResultList in
            // 뷰 컨트롤러에서 전달받은 데이터 처리
            self?.updateUI(searchList: searchResultList.novels)
        }
    }
    
    func updateUI(searchList: [SearchNovel]) {
        Observable.just(searchList)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] list in
                self?.searchResultListRelay.accept(list)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Extensions

extension SearchViewController: UISearchBarDelegate {}
