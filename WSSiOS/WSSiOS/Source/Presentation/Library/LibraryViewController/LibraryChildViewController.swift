//
//  LibraryChildViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/14/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

protocol NovelDelegate: AnyObject {
    func sendData(data: Int)
}

final class LibraryChildViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    
    private let libraryViewModel: LibraryChildViewModel
    
    private let disposeBag = DisposeBag()
    weak var delegate : NovelDelegate?
    let updateNovelListRelay = PublishRelay<ShowNovelStatus>()
    private lazy var novelTotalRelay = PublishRelay<Int>()
    
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
        
        showTabBar()
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
        let input = LibraryChildViewModel.Input(
            updateNovelList: updateNovelListRelay,
            lookForNovelButtonDidTap: rootView.libraryEmptyView.libraryLookForNovelButton.rx.tap,
            cellItemSeleted: rootView.libraryCollectionView.rx.itemSelected
        )
        
        let output = libraryViewModel.transform(from: input, disposeBag: disposeBag)
        
        output.cellData
            .bind(to: rootView.libraryCollectionView.rx.items(
                cellIdentifier: LibraryCollectionViewCell.cellIdentifier,
                cellType: LibraryCollectionViewCell.self)) {(row, element, cell) in
                    cell.bindData(element)
                }
                .disposed(by: disposeBag)
        
        output.pushToDetailNovelViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, novelId in
                owner.pushToDetailViewController(novelId: novelId)
            })
            .disposed(by: disposeBag)
        
        output.showEmptyView
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, isEmpty in
                owner.rootView.libraryEmptyView.isHidden = !isEmpty
            })
            .disposed(by: disposeBag)
        
        output.pushToSearchViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, isEmpty in
                if let tabBarController = owner.tabBarController as? WSSTabBarController {
                    if let myPageIndex = WSSTabBarItem.allCases.firstIndex(of: .search) {
                        tabBarController.selectedIndex = myPageIndex
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
