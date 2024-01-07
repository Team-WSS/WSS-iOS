//
//  SearchWebNovelViewController.swift
//  WSSiOS
//
//  Created by 최서연 on 1/6/24.
//

import UIKit

final class SearchWebNovelViewController: UIViewController, UISearchBarDelegate {
    
    //MARK: set Properties
    
    private let navigationBarTitleLabel = UILabel()
    private let headerView = SearchHeaderView()
    private let dividerLine = UIView()
    private let mainEmptyView = SearchEmptyView()
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierachy()
        setLayout()
        
        setNavigationBar()
        setDelegate()
    }
    
    //MARK: set UI
    
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
    
    //MARK: customize NaivationBar
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.topItem?.titleView = navigationBarTitleLabel
        
        //TODO: custom backbutton 추가 필요
    }
    
    //MARK: set Hierachy
    
    private func setHierachy() {
        self.view.addSubview(headerView)
        self.view.addSubview(dividerLine)
        self.view.addSubview(mainEmptyView)
    }
    
    //MARK: set Layout
    
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
        
        mainEmptyView.snp.makeConstraints {
            $0.top.equalTo(dividerLine.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    //MARK: set Delegate
    
    private func setDelegate() {
        headerView.searchBar.delegate = self
    }
}
