//
//  HomeNotificationViewController.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/12/24.
//

import UIKit

import RxSwift
import RxRelay

final class HomeNotificationViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: HomeNotificationViewModel
    private let disposeBag = DisposeBag()
    
    private let viewWillAppearEvent = PublishRelay<Void>()
    
    //MARK: - UI Components
    
    private let rootView = HomeNotificationView()
    
    //MARK: - Life Cycle
    
    init(viewModel: HomeNotificationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setWSSNavigationBar(title: StringLiterals.Navigation.Title.notification,
                            left: self.rootView.backButton,
                            right: nil)
        swipeBackGesture()
        
        viewWillAppearEvent.accept(())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        registerCell()
        bindViewModel()
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.view.backgroundColor = .wssWhite
    }
    
    //MARK: - Bind
    
    private func registerCell() {
        rootView.notificationTableView.register(
            HomeNotificationTableViewCell.self,
            forCellReuseIdentifier: HomeNotificationTableViewCell.cellIdentifier)
    }
    
    private func bindViewModel() {
        let reachedBottom = rootView.notificationTableView.rx.didScroll
            .map { self.isNearBottomEdge() }
            .distinctUntilChanged()
            .asObservable()
        
        let input = HomeNotificationViewModel.Input(
            viewWillAppearEvent: viewWillAppearEvent.asObservable(),
            notificationTableViewContentSize: rootView.notificationTableView.rx.observe(CGSize.self, "contentSize"),
            notificationTableViewCellSelected: rootView.notificationTableView.rx.itemSelected,
            scrollReachedBottom: reachedBottom
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.notificationList
            .bind(to: rootView.notificationTableView.rx.items(
                cellIdentifier: HomeNotificationTableViewCell.cellIdentifier,
                cellType: HomeNotificationTableViewCell.self)) { row, element, cell in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        output.notificationTableViewHeight
            .drive(with: self, onNext: { owner, height in
                owner.rootView.updateTableViewHeight(height: height)
            })
            .disposed(by: disposeBag)
        
        output.pushToFeedDetailViewController
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, feedId in
                owner.pushToFeedDetailViewController(feedId: feedId)
            })
            .disposed(by: disposeBag)
        
        output.pushToNotificationDetailViewController
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, notificationId in
                owner.pushToNotificationDetailViewController(notificationId: notificationId)
            })
            .disposed(by: disposeBag)
        
        output.showLoadingView
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, isShow in
                owner.rootView.showLoadingView(isShow: isShow)
            })
            .disposed(by: disposeBag)
        
        rootView.backButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
    }
    
    private func isNearBottomEdge() -> Bool {
        guard self.rootView.notificationTableView.contentSize.height > 0 else {
            return false
        }
        
        let checkNearBottomEdge = self.rootView.notificationTableView.contentOffset.y + self.rootView.notificationTableView.bounds.size.height + 1.0 >= self.rootView.notificationTableView.contentSize.height
        
        return checkNearBottomEdge
    }
}
