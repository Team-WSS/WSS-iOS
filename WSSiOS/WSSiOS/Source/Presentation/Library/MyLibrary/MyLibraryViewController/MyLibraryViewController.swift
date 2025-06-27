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
    
    private let viewModel: MyLibraryViewModel
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = MyLibraryView()
    
    // MARK: - Life Cycle
    
    init(viewModel: MyLibraryViewModel) {
        self.viewModel = viewModel
        
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
        
        bindAction()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Bind
    
    private func bindViewModel() {
        let input = createViewModelInput()
        let output = viewModel.transform(from: input,
                                         disposeBag: disposeBag)
        bindViewModelOutput(output)
    }
    
    private func bindViewModelOutput(_ output: MyLibraryViewModel.Output) {
        output.selectedFilterOption
            .asDriver()
            .drive(with: self, onNext: { owner, option in
                owner.rootView.headerView.filterHeaderView.updateFilterButtons(selectedOption: option)
            })
            .disposed(by: disposeBag)
    }
    
    private func createViewModelInput() -> MyLibraryViewModel.Input {
        return MyLibraryViewModel.Input(
            interestFilterButtonDidTap: rootView.headerView.filterHeaderView.interestFilterButton.rx.tap,
            sortButtonDidTap: rootView.headerView.sortButton.rx.tap
        )
    }
    
    private func bindAction() {
        Observable.merge(
            rootView.headerView.filterHeaderView.readStatusFilterButton.rx.tap.asObservable(),
            rootView.headerView.filterHeaderView.starRatingFilterButton.rx.tap.asObservable(),
            rootView.headerView.filterHeaderView.attractivePointFilterButton.rx.tap.asObservable()
        )
        .withLatestFrom(viewModel.filterOption)
        .observe(on: MainScheduler.instance)
        .flatMap { filterOption in
            self.presentLibraryFilterViewController(filterOption)
        }
        .distinctUntilChanged()
        .bind(to: viewModel.filterOption)
        .disposed(by: disposeBag)
    }
}
