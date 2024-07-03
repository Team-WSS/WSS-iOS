//
//  LibraryViewController.swift
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

final class LibraryBaseViewController: UIViewController {
    
    //MARK: - Properties
    
    private let readStatus: String
    private var lastUserNovelId: Int
    private let size: Int
    private var sortType: String
    private let userNovelListRepository: DefaultUserNovelRepository
    
    private let disposeBag = DisposeBag()
    weak var delegate : NovelDelegate?
    private lazy var novelListRelay = PublishRelay<[UserNovelListDetail]>()
    private lazy var novelTotalRelay = PublishRelay<Int>()
    
    //MARK: - Components
    
    private let rootView = LibraryView()
    private let libraryEmptyView = LibraryEmptyView()
    
    // MARK: - Life Cycle
    
    init(userNovelListRepository: DefaultUserNovelRepository,
         readStatus: String,
         lastUserNovelId: Int,
         size: Int,
         sortType: String) {
        
        self.userNovelListRepository = userNovelListRepository
        self.readStatus = readStatus
        self.lastUserNovelId = lastUserNovelId
        self.size = size
        self.sortType = sortType
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
        
        setUI()
        setHierarchy()
        setLayout()
        register()
        bindCell()
        bindAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabBar()
        updateNovelList(readStatus: readStatus,
                        lastUserNovelId: lastUserNovelId,
                        size: size,
                        sortType: sortType)
    }
    
    //MARK: - Bind
    
    private func register() {
        rootView.libraryCollectionView.register(LibraryCollectionViewCell.self,
                                                forCellWithReuseIdentifier: "LibraryCollectionViewCell")
    }
    
    private func bindCell() {
        novelListRelay.bind(to: rootView.libraryCollectionView.rx.items(
            cellIdentifier: "LibraryCollectionViewCell",
            cellType: LibraryCollectionViewCell.self)) {(row, element, cell) in
                cell.bindData(element)
            }
            .disposed(by: disposeBag)
        
        novelListRelay
            .subscribe(with: self, onNext: { owner, list in
                owner.libraryEmptyView.isHidden = !list.isEmpty
            })
            .disposed(by: disposeBag)
        
        novelTotalRelay
            .subscribe(with: self, onNext: { owner, count in
                owner.delegate?.sendData(data: count)
            })
            .disposed(by: disposeBag)
    }
    
    func updateNovelList(readStatus: String,
                         lastUserNovelId: Int,
                         size: Int,
                         sortType: String) {
        userNovelListRepository.getUserNovelList(readStatus: readStatus,
                                                 lastUserNovelId: lastUserNovelId,
                                                 size: size,
                                                 sortType: sortType)
        .observe(on: MainScheduler.instance)
        .subscribe(with: self, onNext: { owner, data in
            owner.novelListRelay.accept(data.userNovels)
            owner.novelTotalRelay.accept(data.userNovelCount)
        }, onError: { error, _  in
            print(error)
        })
        .disposed(by: disposeBag)
    }
    
    //MARK: - Actions
    
    private func bindAction() {
        rootView.libraryCollectionView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .withLatestFrom(novelListRelay) { (indexPath, novelList) -> UserNovelListDetail? in
                return novelList[indexPath.row]
            }
            .compactMap { $0 }
            .subscribe(with: self, onNext: { owner, selectedItem in
                owner.navigationController?.pushViewController(TrashNovelDetailViewController(
                    viewModel: TrashNovelDetailViewModel(
                        userNovelRepository: DefaultUserNovelRepository(
                            userNovelService: DefaultUserNovelService()
                        )
                    ), userNovelId: selectedItem.userNovelId), animated: true)
            })
            .disposed(by: disposeBag)
        
        libraryEmptyView.libraryRegisterButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                self.navigationController?.pushViewController(
                    SearchViewController(searchViewModel: SearchViewModel(novelRepository: DefaultNovelRepository(novelService: DefaultNovelService()))), 
                    animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension LibraryBaseViewController {
    
    //MARK: - UI
    
    private func setUI() {
        libraryEmptyView.isHidden = true
    }
    
    private func setHierarchy() {
        self.view.addSubview(libraryEmptyView)
    }
    
    private func setLayout() {
        libraryEmptyView.snp.makeConstraints() {
            $0.edges.equalToSuperview()
        }
    }
}
