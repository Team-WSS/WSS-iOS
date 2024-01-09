//
//  SearchViewController.swift
//  WSSiOS
//
//  Created by 최서연 on 1/6/24.
//

import UIKit

final class SearchViewController: UIViewController {
    
    //MARK: - Properties
    
    private let navigationBarTitleLabel = UILabel()
    private let searchDummy = SearchNovel.searchNovelDummy()
    
    //MARK: - UI Components
    
    private let rootView = SearchView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNavigationBar()
        
        setDelegate()
        setCollectionViewConfig()
        setCollectionViewLayout()
    }
    
    //MARK: - set UI
    
    private func setUI() {
        navigationBarTitleLabel.do {
            $0.text = "검색"
            $0.font = .Title2
            $0.textColor = .Black
        }
    }
    
    //MARK: - customize NaivationBar
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.topItem?.titleView = navigationBarTitleLabel
        
        //TODO: custom backbutton 추가 필요
    }
    
    //MARK: - set Delegate
    
    private func setDelegate() {
        rootView.headerView.searchBar.delegate = self
    }
    
    private func setCollectionViewConfig() {
        rootView.mainResultView.searchCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        rootView.mainResultView.searchCollectionView.dataSource = self
        rootView.mainResultView.searchCollectionView.delegate = self
    }
    
    private func setCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 15
        flowLayout.sectionInset = UIEdgeInsets(top: 13, left: 0, bottom: 0, right: 0)
        rootView.mainResultView.searchCollectionView.setCollectionViewLayout(flowLayout, animated: false)
    }
}

//MARK: - Extensions

extension SearchViewController: UISearchBarDelegate {}

extension SearchViewController: UICollectionViewDelegate {}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchDummy.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell()}
        
        item.bindData(data: searchDummy[indexPath.row])
        return item
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = rootView.mainResultView.searchCollectionView.frame.width
        return CGSize(width: itemWidth, height: 104)
    }
}
