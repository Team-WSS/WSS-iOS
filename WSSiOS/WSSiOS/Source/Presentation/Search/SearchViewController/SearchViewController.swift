//
//  SearchViewController.swift
//  WSSiOS
//
//  Created by 최서연 on 1/6/24.
//

import UIKit

import RxSwift
import RxCocoa
import Then

final class SearchViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = SearchView()
    
    //MARK: - Life Cycle
    
    init() {
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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        delegate()
        register()
        
        bindViewModel()
    }
    
    //MARK: - UI
    
    private func setUI() {
        
    }
    
    //MARK: - Bind
    
    private func delegate() {
        
    }
    
    private func register() {
        
    }
    
    private func bindViewModel() {
        
    }
}

//MARK: - Extension
//
//extension SearchViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        rootView.headerView.searchBar.resignFirstResponder()
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
//        self.view.endEditing(true)
//    }
//
//    private func showSearchBarAndFocus() {
//        rootView.headerView.searchBar.becomeFirstResponder()
//    }
//}
