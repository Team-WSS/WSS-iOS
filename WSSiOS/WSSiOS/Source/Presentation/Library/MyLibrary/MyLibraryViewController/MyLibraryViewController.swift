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
    private let selectedFilterOption = BehaviorRelay<LibraryFilterOption>(value: LibraryFilterOption())
    
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
        .withLatestFrom(selectedFilterOption)
        .observe(on: MainScheduler.instance)
        .flatMap { filterOption in
            self.presentLibraryFilterViewController(filterOption)
        }
        .distinctUntilChanged()
        .bind(to: selectedFilterOption)
        .disposed(by: disposeBag)
    }
}
