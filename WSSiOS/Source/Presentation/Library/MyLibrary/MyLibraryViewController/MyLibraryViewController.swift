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
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        viewWillAppear.accept(())
    }
    
    //MARK: - Bind
    
    private func registerCell() {
        rootView.libraryCollectionView.register(
            MyLibraryCollectionViewCell.self,
            forCellWithReuseIdentifier: MyLibraryCollectionViewCell.cellIdentifier)
        rootView.libraryTableView.register(
            MyLibraryTableViewCell.self,
            forCellReuseIdentifier: MyLibraryTableViewCell.cellIdentifier)
        
    }
    
    private func delegate() {
        rootView.libraryCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        rootView.libraryTableView.rx.setDelegate(self)
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
        
        output.novelCount
            .drive(with: self, onNext: { owner, count in
                owner.rootView.headerView.updateCountLabel(count: count)
            })
            .disposed(by: disposeBag)
        
        output.libraryNovelList
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.libraryCollectionView.rx.items(
                cellIdentifier: MyLibraryCollectionViewCell.cellIdentifier,
                cellType: MyLibraryCollectionViewCell.self)
            ) { _, element, cell in
                cell.bindData(element)
            }
            .disposed(by: disposeBag)
        
        output.libraryNovelList
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.libraryTableView.rx.items(
                cellIdentifier: MyLibraryTableViewCell.cellIdentifier,
                cellType: MyLibraryTableViewCell.self)
            ) { _, element, cell in
                cell.bindData(element)
            }
            .disposed(by: disposeBag)
        
        output.showLibraryEmptyView
            .drive(with: self, onNext: { owner, isShowing in
                owner.rootView.showLibraryEmptyView(isShowing: isShowing)
            })
            .disposed(by: disposeBag)
        
        output.showFilterResultEmptyView
            .drive(with: self, onNext: { owner, isShowing in
                owner.rootView.showFilterResultEmptyView(isShowing: isShowing)
            })
            .disposed(by: disposeBag)
        
        output.showLoadingView
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, isShowing in
                owner.rootView.showLoadingView(isShowing: isShowing)
            })
            .disposed(by: disposeBag)
        
        output.showNetworkErrorView
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, isShowing in
                owner.rootView.showNetworkErrorView(isShowing: isShowing)
            })
            .disposed(by: disposeBag)
        
        output.pushToNovelDetailViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, novelId in
                owner.pushToNovelDetailViewController(novelId: novelId)
            })
            .disposed(by: disposeBag)
    }
    
    private func createViewModelInput() -> MyLibraryViewModel.Input {
        let collectionViewDidReachBottom = rootView.libraryCollectionView.rx.contentOffset
            .map { [weak self] contentOffset in
                guard let self = self else { return false }
                let offsetY = contentOffset.y
                let contentHeight = self.rootView.libraryCollectionView.contentSize.height
                let frameHeight = self.rootView.libraryCollectionView.frame.height
                return offsetY + frameHeight >= contentHeight - 100
            }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in () }
        
        let tableViewDidReachBottom =  rootView.libraryTableView.rx.contentOffset
            .map { [weak self] contentOffset in
                guard let self = self else { return false }
                let offsetY = contentOffset.y
                let contentHeight = self.rootView.libraryTableView.contentSize.height
                let frameHeight = self.rootView.libraryTableView.frame.height
                return offsetY + frameHeight >= contentHeight - 100
            }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in () }
        
        let novelItemSelected = Observable.merge(
            rootView.libraryCollectionView.rx.itemSelected.asObservable(),
            rootView.libraryTableView.rx.itemSelected.asObservable()
        )

        let sortTypeSelected = rootView.headerView.sortButton.rx.tap
            .withLatestFrom(viewModel.sortType)
            .observe(on: MainScheduler.instance)
            .flatMapLatest { [weak self] current -> Observable<LibrarySortType> in
                guard let self else { return .empty() }
                return self.presentLibrarySortBottomSheet(current)
            }

        return MyLibraryViewModel.Input(
            viewWillAppear: viewWillAppear.asObservable(),
            interestFilterButtonDidTap: rootView.headerView.filterHeaderView.interestFilterButton.rx.tap,
            sortTypeSelected: sortTypeSelected,
            layoutToggleButtonDidTap: rootView.headerView.layoutToggleButton.rx.tap,
            collectionViewDidReachBottom: collectionViewDidReachBottom,
            tableViewDidReachBottom: tableViewDidReachBottom,
            novelItemSelected: novelItemSelected,
            networkErrorRefreshButtonDidTap: rootView.networkErrorView.refreshButton.rx.tap
        )
    }
    
    private func bindAction() {
        let filterHeaderView = rootView.headerView.filterHeaderView
        Observable.merge(
            filterHeaderView.readStatusFilterButton.rx.tap.map { LibraryFilterTab.readStatus },
            filterHeaderView.genreFilterButton.rx.tap.map { LibraryFilterTab.genre },
            filterHeaderView.publicationStatusFilterButton.rx.tap.map { LibraryFilterTab.publicationStatus },
            filterHeaderView.starRatingFilterButton.rx.tap.map { LibraryFilterTab.rating },
            filterHeaderView.attractivePointFilterButton.rx.tap.map { LibraryFilterTab.attractivePoint },
            filterHeaderView.keywordFilterButton.rx.tap.map { LibraryFilterTab.keyword }
        )
        .withLatestFrom(viewModel.filterOption) { tab, option in (tab, option) }
        .observe(on: MainScheduler.instance)
        .flatMap { [weak self] tab, option -> Observable<LibraryFilterOption> in
            guard let self else { return .empty() }
            return self.presentLibraryFilterViewController(option, initialTab: tab)
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
        
        rootView.headerView.sortButton.rx.tap
            .bind(with: self, onNext: { _, _ in
                HapticManager.shared.generateSelectionFeedback()
            })
            .disposed(by: disposeBag)

        rootView.navigationView.libraryAddButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.pushToNormalSearchViewController()
            })
            .disposed(by: disposeBag)
    }
}

extension MyLibraryViewController: UIScrollViewDelegate {
    
}
