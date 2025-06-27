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
    private let viewWillAppear = PublishRelay<Void>()
    
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
        
        registerCell()
        delegate()
        bindAction()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppear.accept(())
        //        DefaultMyLibraryService().getMyLibraryList(userId:  UserDefaults.standard.integer(forKey: StringLiterals.UserDefault.userId), query: MyLibraryNovelListQuery(lastUserNovelId: 0, size: 20, sortType: "NEWEST"))
        //            .subscribe({ data in
        //                print(data)
        //            })
        //            .disposed(by: disposeBag)
    }
    
    //MARK: - Bind
    
    private func registerCell() {
        rootView.libraryCollectionView.libraryCollectionView
            .register(MyLibraryCollectionViewCell.self,
                      forCellWithReuseIdentifier: MyLibraryCollectionViewCell.cellIdentifier)
        rootView.libraryTableView.libraryTableView
            .register(MyLibraryTableViewCell.self,
                      forCellReuseIdentifier: MyLibraryTableViewCell.cellIdentifier)
        
    }
    
    private func delegate() {
        rootView.libraryCollectionView.libraryCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        rootView.libraryTableView.libraryTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = createViewModelInput()
        let output = viewModel.transform(from: input,
                                         disposeBag: disposeBag)
        bindViewModelOutput(output)
    }
    
    private func bindViewModelOutput(_ output: MyLibraryViewModel.Output) {
        output.selectedFilterOption
            .drive(with: self, onNext: { owner, option in
                owner.rootView.headerView.filterHeaderView.updateFilterButtons(selectedOption: option)
            })
            .disposed(by: disposeBag)
        
        output.selectedSortType
            .drive(with: self, onNext: { owner, sortType in
                owner.rootView.headerView.sortButton.updateSortButton(sortType: sortType)
            })
            .disposed(by: disposeBag)
        
        output.selectedLayoutType
            .drive(with: self, onNext: { owner, layoutType in
                owner.rootView.headerView.updateLayoutToggleButton(selectedType: layoutType)
                owner.rootView.showLibraryListView(selectedType: layoutType)
            })
            .disposed(by: disposeBag)
    }
    
    private func createViewModelInput() -> MyLibraryViewModel.Input {
        return MyLibraryViewModel.Input(
            viewWillAppear: viewWillAppear.asObservable(),
            interestFilterButtonDidTap: rootView.headerView.filterHeaderView.interestFilterButton.rx.tap,
            sortButtonDidTap: rootView.headerView.sortButton.rx.tap, layoutToggleButtonDidTap: rootView.headerView.layoutToggleButton.rx.tap
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
        
        rootView.libraryEmptyView.searchNovelButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.pushToNormalSearchViewController()
            })
            .disposed(by: disposeBag)
    }
}

extension MyLibraryViewController: UIScrollViewDelegate {
    
}
