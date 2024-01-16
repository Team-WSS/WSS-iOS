//
//  HomeViewController.swift
//  WSSiOS
//
//  Created by 최서연 on 1/9/24.
//

import UIKit

import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private let rootView = HomeView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        registerCell()
        addTapGesture()
        bindDataToSosoPickCollectionView()
    }
    
    private func setUI() {
        self.view.do {
            $0.backgroundColor = .White
        }
    }
    
    private func registerCell() {
        rootView.sosopickView.sosoPickCollectionView.register(HomeSosoPickCollectionViewCell.self,
                                                              forCellWithReuseIdentifier: HomeSosoPickCollectionViewCell.identifier)
    }
    
    private func bindDataToSosoPickCollectionView() {
        sosoPickDummy.bind(to: rootView.sosopickView.sosoPickCollectionView.rx.items(
            cellIdentifier: HomeSosoPickCollectionViewCell.identifier,
            cellType: HomeSosoPickCollectionViewCell.self)) { (row, element, cell) in
                cell.bindData(data: element)
            }
            .disposed(by: disposeBag)
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pushSearchVC(_:)))
        rootView.headerView.headerSearchView.addGestureRecognizer(tapGesture)
        rootView.headerView.headerSearchView.isUserInteractionEnabled = true
    }
    
    @objc private func pushSearchVC(_ sender: UITapGestureRecognizer) {
        self.navigationController?.pushViewController(SearchViewController(), animated: true)
    }
}
