//
//  LibraryChildViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/14/24.
//

import UIKit

import RxSwift
import RxCocoa

final class LibraryChildViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    
    private let libraryViewModel: LibraryChildViewModel
    
    private let disposeBag = DisposeBag()
    let updateNovelListRelay = PublishRelay<ShowNovelStatus>()
    private lazy var novelTotalRelay = PublishRelay<Int>()
    private let updateRelay = PublishRelay<Void>()
    private let viewWillAppearEventRelay = PublishRelay<Void>()
    
    //MARK: - Components
    
    private let rootView = LibraryChildView()
    
    // MARK: - Life Cycle
    
    init(libraryViewModel: LibraryChildViewModel) {
        self.libraryViewModel = libraryViewModel
    
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
        
        register()
        setDelegate()

        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewWillAppearEventRelay.accept(())
    }
    
    //MARK: - Bind
    
    private func register() {
        rootView.libraryCollectionView.register(LibraryCollectionViewCell.self,
                                                forCellWithReuseIdentifier: LibraryCollectionViewCell.cellIdentifier)
    }
    
    private func setDelegate() {
        rootView.libraryCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let loadNextPageTrigger = rootView.libraryCollectionView.rx.contentOffset
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
        
        let input = LibraryChildViewModel.Input(
            viewWillAppear: viewWillAppearEventRelay.asObservable(),
            lookForNovelButtonDidTap: rootView.libraryEmptyView.libraryLookForNovelButton.rx.tap,
            cellItemSeleted: rootView.libraryCollectionView.rx.itemSelected,
            loadNextPageTrigger: loadNextPageTrigger,
            updateCollectionView: updateRelay.asObservable(),
            listTapped: rootView.descriptionView.libraryNovelListButton.rx.tap,
            newestTapped: rootView.libraryListView.libraryNewestButton.rx.tap,
            oldestTapped: rootView.libraryListView.libraryOldestButton.rx.tap
        )
        
        let output = libraryViewModel.transform(from: input, disposeBag: disposeBag)
        
        output.cellData
            .bind(to: rootView.libraryCollectionView.rx.items(
                cellIdentifier: LibraryCollectionViewCell.cellIdentifier,
                cellType: LibraryCollectionViewCell.self)) {(row, element, cell) in
                    cell.bindData(element)
                }
                .disposed(by: disposeBag)
        
        output.showEmptyView
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, data in
                let (isEmpty, isMyPage) = data
                owner.rootView.libraryEmptyView.isHidden = !isEmpty
                owner.rootView.libraryEmptyView.libraryLookForNovelButton.isHidden = !isMyPage
            })
            .disposed(by: disposeBag)
        
        output.pushToDetailNovelViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, novelId in
                owner.pushToDetailViewController(novelId: novelId)
            })
            .disposed(by: disposeBag)
        
        output.pushToSearchViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.pushToNormalSearchViewController()
            })
            .disposed(by: disposeBag)
        
        output.sendNovelTotalCount
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, count in
                owner.rootView.descriptionView.updateNovelCount(count: count)
            })
            .disposed(by: disposeBag)
        
        output.showListView
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, show in
                owner.rootView.libraryListView.isHidden = !show
            })
            .disposed(by: disposeBag)
        
        output.updateToggleViewTitle
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, isNewest in
                owner.rootView.descriptionView.updatelibraryNovelListButtonTitle(title: isNewest)
            })
            .disposed(by: disposeBag)
    }
}
