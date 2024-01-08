//
//  SearchWebNovelViewController.swift
//  WSSiOS
//
//  Created by 최서연 on 1/6/24.
//

import UIKit

final class SearchWebNovelViewController: UIViewController, UISearchBarDelegate {
    
    //MARK: - set Properties
    
    private let navigationBarTitleLabel = UILabel()
    private let headerView = SearchHeaderView()
    private let dividerLine = UIView()
    private let mainResultView = SearchResultView()
    private let mainEmptyView = SearchEmptyView()
    private let searchDummy = SearchNovel.searchNovelDummy()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierachy()
        setLayout()
        
        setNavigationBar()
        setDelegate()
        setCollectionViewConfig()
        setCollectionViewLayout()
    }
    
    //MARK: - set UI
    
    private func setUI() {
        self.view.backgroundColor = .White
        
        navigationBarTitleLabel.do {
            $0.text = "검색"
            $0.font = .Title2
            $0.textColor = .Black
        }
        
        dividerLine.do {
            $0.backgroundColor = .Gray50
        }
    }
    
    //MARK: - customize NaivationBar
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.topItem?.titleView = navigationBarTitleLabel
        
        //TODO: custom backbutton 추가 필요
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        self.view.addSubviews(headerView,
                              dividerLine,
                              mainResultView)
    }
    
    //MARK: - set Layout
    
    private func setLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(67)
        }
        
        dividerLine.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        mainResultView.snp.makeConstraints {
            $0.top.equalTo(dividerLine.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    //MARK: - set Delegate
    
    private func setDelegate() {
        headerView.searchBar.delegate = self
    }
    
    private func setCollectionViewConfig() {
        mainResultView.searchCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        mainResultView.searchCollectionView.dataSource = self
        mainResultView.searchCollectionView.delegate = self
    }
    
    private func setCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 15
        mainResultView.searchCollectionView.setCollectionViewLayout(flowLayout, animated: false)
    }
}

//MARK: - Extensions

extension SearchWebNovelViewController: UICollectionViewDelegate {}

extension SearchWebNovelViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchDummy.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell()}
        
        item.bindData(data: searchDummy[indexPath.row])
        return item
    }
}

extension SearchWebNovelViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mainResultView.searchCollectionView.frame.width, height: 104)
    }
}
