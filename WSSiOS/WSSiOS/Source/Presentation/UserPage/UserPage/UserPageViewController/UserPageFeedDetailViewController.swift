//
//  UserPageFeedDetailViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 12/3/24.
//

import UIKit

import RxSwift
import RxRelay
import RxGesture

final class UserPageFeedDetailViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: UserPageFeedDetailViewModel
    private let viewWillAppearRelay = PublishRelay<Void>()
 
    //MARK: - Components
    
    private let rootView = UserPageFeedDetailView()
    
    // MARK: - Life Cycle
    
    init(viewModel: UserPageFeedDetailViewModel) {
        
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
        
        register()
        delegate()
        bindViewModel()
        bindAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewWillAppearRelay.accept(())
        swipeBackGesture()
    }
    
    //MARK: - Bind
    
    private func register() {
        rootView.userPageFeedDetailTableView.register(FeedListTableViewCell.self,
                                                      forCellReuseIdentifier: FeedListTableViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.userPageFeedDetailTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindAction() {
        rootView.backButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let loadNextPageTrigger = rootView.userPageFeedDetailTableView.rx.contentOffset
            .map { [weak self] contentOffset in
                guard let self = self else { return false }
                let offsetY = contentOffset.y
                let contentHeight = self.rootView.userPageFeedDetailTableView.contentSize.height
                let frameHeight = self.rootView.userPageFeedDetailTableView.frame.height
                return offsetY + frameHeight >= contentHeight - 10
            }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in () }
        
        let input = UserPageFeedDetailViewModel.Input(
            loadNextPageTrigger: loadNextPageTrigger,
            viewWillAppearEvent: viewWillAppearRelay.asObservable(),
            feedTableViewItemSelected: rootView.userPageFeedDetailTableView.rx.itemSelected
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.bindFeedData
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.userPageFeedDetailTableView.rx.items(
                cellIdentifier: FeedListTableViewCell.cellIdentifier,
                cellType: FeedListTableViewCell.self)) { _, element, cell in
                    cell.bindProfileFeedData(feed: element)
                    cell.delegate = self
                }
                .disposed(by: disposeBag)
        
        output.pushToFeedDetailViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, feedId in
                owner.pushToFeedDetailViewController(feedId: feedId)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - FeedTableViewDelegate

extension UserPageFeedDetailViewController: FeedTableViewDelegate {
    func profileViewDidTap(userId: Int) {
        return
    }
    
    func dropdownButtonDidTap(feedId: Int, isMyFeed: Bool) {
        return
    }
    
    func likeViewDidTap(feedId: Int, isLiked: Bool) {
        return
    }
    
    func connectedNovelViewDidTap(novelId: Int) {
        self.pushToNovelDetailViewController(novelId: novelId)
    }
}
