//
//  LibraryViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/14/24.
//

import UIKit

import RxSwift
import RxCocoa

protocol NovelDelegate: AnyObject {
    func sendData(data: Int)
}

final class LibraryBaseViewController: UIViewController {
    
    //MARK: - Properties
    
    private let readStatusData: String
    private var lastUserNovelIdData: Int
    private let sizeData: Int
    private var sortTypeData: String
    private lazy var novelTotalCount = 0
    weak var delegate : NovelDelegate?
    
    //MARK: - UI Components
    
    private let rootView = LibraryView()
    private let disposeBag = DisposeBag()
    private let libraryEmptyView = LibraryEmptyView()
    private let userNovelListRepository: DefaultUserNovelRepository
    private lazy var novelList = [UserNovelListDetail]()
    private let novelListRelay = PublishRelay<[UserNovelListDetail]>()
    private var novelSortTypeRelay = PublishRelay<Int>()
    
    init(userNovelListRepository: DefaultUserNovelRepository,
         readStatusData: String,
         lastUserNovelIdData: Int,
         sizeData: Int,
         sortTypeData: String) {
        
        self.userNovelListRepository = userNovelListRepository
        self.readStatusData = readStatusData
        self.lastUserNovelIdData = lastUserNovelIdData
        self.sizeData = sizeData
        self.sortTypeData = sortTypeData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierachy()
        setLayout()
        register()
        bindCell()
        bindAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabBar()
        bindUserData(readStatus: readStatusData,
                     lastUserNovelId: lastUserNovelIdData,
                     size: sizeData,
                     sortType: sortTypeData)
    }
    
    //MARK: - Custom TabBar
    
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
                if list.isEmpty {
                    owner.libraryEmptyView.isHidden = false
                } else {
                    owner.libraryEmptyView.isHidden = true
                }
                
                owner.novelList = list
            })
            .disposed(by: disposeBag)
        
        novelSortTypeRelay
            .subscribe(with: self, onNext: { owner, count in
                owner.delegate?.sendData(data: owner.novelTotalCount)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindUserData(readStatus: String,
                              lastUserNovelId: Int,
                              size: Int,
                              sortType: String) {
        userNovelListRepository.getUserNovelList(readStatus: readStatus,
                                                 lastUserNovelId: lastUserNovelId,
                                                 size: size,
                                                 sortType: sortType)
        .observe(on: MainScheduler.instance)
        .debug()
        .subscribe(with: self, onNext: { owner, data in
            owner.novelListRelay.accept(data.userNovels)
            owner.novelTotalCount = data.userNovelCount
            owner.novelSortTypeRelay.accept(data.userNovelCount)
        }, onError: { error, _  in
            print(error)
        })
        .disposed(by: disposeBag)
    }
    
    private func reBindUserData(readStatus: String,
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
        }, onError: { error, _  in
            print(error)
        })
        .disposed(by: disposeBag)
    }
    
    private func bindAction() {
        rootView.libraryCollectionView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .map { [weak self] indexPath in
                return self?.novelList[indexPath.row]
            }
            .compactMap { $0 }
            .subscribe(with: self, onNext: { owner, selectedItem in
                owner.navigationController?.pushViewController(NovelDetailViewController(
                    repository: DefaultUserNovelRepository(
                        userNovelService: DefaultUserNovelService()
                    ), userNovelId: selectedItem.userNovelId), animated: true)
            })
            .disposed(by: disposeBag)
        
        libraryEmptyView.libraryRegisterButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                self.navigationController?.pushViewController(
                    SearchViewController(novelRepository: DefaultNovelRepository(
                        novelService: DefaultNovelService())), 
                    animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func reloadView(sortType: String) {
        sortTypeData = sortType
        if sortTypeData == "NEWEST" {
            lastUserNovelIdData = 999999
            reBindUserData(readStatus: readStatusData,
                         lastUserNovelId: lastUserNovelIdData,
                         size: 500,
                         sortType: sortType)
        }
        
        else if sortTypeData == "OLDEST" {
            lastUserNovelIdData = 0
            reBindUserData(readStatus: readStatusData,
                         lastUserNovelId: lastUserNovelIdData,
                         size: 500,
                         sortType: sortType)
        }
    }
}

extension LibraryBaseViewController {
    private func setUI() {
        libraryEmptyView.isHidden = true
    }
    
    private func setHierachy() {
        self.view.addSubview(libraryEmptyView)
    }
    
    private func setLayout() {
        libraryEmptyView.snp.makeConstraints() {
            $0.edges.equalToSuperview()
        }
    }
}
