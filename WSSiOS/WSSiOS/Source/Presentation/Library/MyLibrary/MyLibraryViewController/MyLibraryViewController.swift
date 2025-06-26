//
//  MyLibraryViewController.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/26/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class MyLibraryViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = MyLibraryView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Bint
    
    private func bindAction() {
        Observable.merge(
            rootView.headerView.filterHeaderView.readStatusFilterButton.rx.tap.asObservable(),
            rootView.headerView.filterHeaderView.starRatingFilterButton.rx.tap.asObservable(),
            rootView.headerView.filterHeaderView.attractivePointFilterButton.rx.tap.asObservable()
        )
        .observe(on: MainScheduler.instance)
        .bind(with: self, onNext: { owner, _ in
            owner.presentLibraryFilterViewController()
        })
        .disposed(by: disposeBag)
    }
}
