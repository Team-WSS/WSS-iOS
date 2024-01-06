//
//  SearchWebNovelViewController.swift
//  WSSiOS
//
//  Created by 최서연 on 1/6/24.
//

import UIKit

final class SearchWebNovelViewController: UIViewController, UISearchBarDelegate {
    
    //MARK: set Properties
    
    private let headerView = SearchHeaderView()
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    //MARK: set UI
    
    private func setUI() {
        self.view.backgroundColor = .White
        headerView.searchBar.delegate = self
    }
    
    //MARK: set Hierachy
    
    private func setHierachy() {
        self.view.addSubview(headerView)
    }
    
    //MARK: set Layout
    
    private func setLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(100) // 임시 -> 네비게이션바 만들고 재조정 필요
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(67)
        }
    }
}
