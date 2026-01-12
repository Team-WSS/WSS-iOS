//
//  MyPageBlockUserViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 7/29/24.
//

import UIKit

import RxSwift
import RxCocoa

final class MyPageBlockUserViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let userRepository: UserBlockRepository
    private var cellDataRelay = BehaviorRelay<[BlockUserEntity]>(value: [])
    
    //MARK: - UI Components
    
    private var rootView = MyPageBlockUserView()
    
    // MARK: - Life Cycle
    
    init(userRepository: UserBlockRepository) {
        self.userRepository = userRepository
        
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
        
        delegate()
        register()
        setupTableView()
        
        bindAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bindViewWillAppearAction()
    }
    
    //MARK: - Delegate
    
    private func delegate() {
        rootView.blockTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func register() {
        rootView.blockTableView.register(
            MyPageBlockUserTableViewCell.self,
            forCellReuseIdentifier: MyPageBlockUserTableViewCell.cellIdentifier)
    }
    
    
    //MARK: - Bind
    
    private func bindViewWillAppearAction() {
        swipeBackGesture()
        hideTabBar()
        setWSSNavigationBar(title: StringLiterals.Navigation.Title.myPageBlockUser,
                            left: self.rootView.backButton,
                            right: nil)
    }
    
    private func setupTableView() {
        getBlockUserList()
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, blocks in
                owner.rootView.emptyView.isHidden = !blocks.blocks.isEmpty
                owner.cellDataRelay.accept(blocks.blocks)
            })
            .disposed(by: disposeBag)
        
        cellDataRelay
            .bind(to: rootView.blockTableView.rx.items(cellIdentifier: MyPageBlockUserTableViewCell.cellIdentifier,
                                                       cellType: MyPageBlockUserTableViewCell.self)) { row, data, cell in
                cell.bindData(image: data.avatarImage, nickname: data.nickname)
            }
                                                       .disposed(by: disposeBag)
    }
    
    private func bindAction() {
        rootView.backButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        rootView.blockTableView.rx.itemSelected
            .throttle(.seconds(Int(0.5)), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] indexPath -> Observable<String> in
                guard let self = self else { return .empty() }
                var blocks = cellDataRelay.value
                let blockID = blocks[indexPath.row].blockId
                let nickName = blocks[indexPath.row].nickname
                
                return self.deleteBlockUser(blockID: blockID)
                    .map { _ -> String in
                        blocks.remove(at: indexPath.row)
                        self.cellDataRelay.accept(blocks)
                        self.rootView.emptyView.isHidden = !blocks.isEmpty
                        self.rootView.blockTableView.reloadData()
                        return nickName
                    }
            }
            .subscribe(with: self, onNext: { owner, nickname in
                owner.showToast(.deleteBlockUser(nickname: nickname))
            }, onError: { error, _ in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - API
    
    private func getBlockUserList() -> Observable<BlockUserListEntity> {
        return self.userRepository.getBlocksList()
    }
    
    private func deleteBlockUser(blockID: Int) -> Observable<Void> {
        return self.userRepository.deleteBlockUser(blockID: blockID)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
    }
}
