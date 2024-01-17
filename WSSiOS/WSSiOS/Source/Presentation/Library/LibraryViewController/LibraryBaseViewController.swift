//
//  LibraryViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/14/24.
//

import UIKit

import RxSwift
import RxCocoa

final class LibraryBaseViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let userNovelListRepository: DefaultUserNovelRepository
    private let readStatusData: String
    private let lastUserNovelIdData: Int
    private let sizeData: Int
    private let sortTypeData: String
    
    private var novelListRelay = BehaviorRelay<[UserNovelListDetail]>(value: [])
    
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
    
    //MARK: - UI Components
    
    private var rootView = LibraryView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
        bindUserData(readStatus: readStatusData,
                     lastUserNovelId: lastUserNovelIdData,
                     size: sizeData,
                     sortType: sortTypeData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = self.tabBarController as? WSSTabBarController {
            tabBarController.tabBar.isHidden = false
            tabBarController.shadowView.isHidden = false
        }
    }
    
    //MARK: - Custom TabBar
    
    private func register() {
        rootView.libraryCollectionView.register(LibraryCollectionViewCell.self,
                                                forCellWithReuseIdentifier: "LibraryCollectionViewCell")
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
        .subscribe(with: self, onNext: { owner, data in
            owner.novelListRelay.accept(data.userNovels)
            owner.bindColletionView()
        }, onError: { error, _  in
            print(error)
        })
        .disposed(by: disposeBag)
    }
    
    private func bindColletionView() {
        novelListRelay.bind(to: rootView.libraryCollectionView.rx.items(
            cellIdentifier: "LibraryCollectionViewCell",
            cellType: LibraryCollectionViewCell.self)) { [weak self] (row, element, cell) in
                guard let self = self else { return }
                cell.bindData(element)
                print("🤙🏻", element)
                
                //                cell.myPageAvaterButton.rx.tap
            }
            .disposed(by: disposeBag)
    }
}
