//
//  MyPageFeedDetailViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 12/3/24.
//

import UIKit

import RxSwift
import RxRelay
import RxGesture

final class MyPageFeedDetailViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: MyPageFeedDetailViewModel
    private let viewWillAppearRelay = PublishRelay<Void>()
    
    private let feedConnectedNovelViewDidTap = PublishRelay<Int>()
    
    //MARK: - Components
    
    private let rootView = MyPageFeedDetailView()
    
    // MARK: - Life Cycle
    
    init(viewModel: MyPageFeedDetailViewModel) {
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewWillAppearRelay.accept(())
        swipeBackGesture()
    }
    
    private func register() {
        rootView.myPageFeedDetailTableView.register(FeedListTableViewCell.self,
                                                    forCellReuseIdentifier: FeedListTableViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.myPageFeedDetailTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let loadNextPageTrigger = rootView.myPageFeedDetailTableView.rx.contentOffset
            .map { [weak self] contentOffset in
                guard let self = self else { return false }
                let offsetY = contentOffset.y
                let contentHeight = self.rootView.myPageFeedDetailTableView.contentSize.height
                let frameHeight = self.rootView.myPageFeedDetailTableView.frame.height
                return offsetY + frameHeight >= contentHeight - 10
            }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in () }
        
        let input = MyPageFeedDetailViewModel.Input(
            loadNextPageTrigger: loadNextPageTrigger,
            popViewController: rootView.backButton.rx.tap,
            viewWillAppearEvent: viewWillAppearRelay.asObservable(),
            feedTableViewItemSelected: rootView.myPageFeedDetailTableView.rx.itemSelected.asObservable(),
            feedConnectedNovelViewDidTap: feedConnectedNovelViewDidTap.asObservable()
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.bindFeedData
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.myPageFeedDetailTableView.rx.items(
                cellIdentifier: FeedListTableViewCell.cellIdentifier,
                cellType: FeedListTableViewCell.self)) { _, element, cell in
                    cell.bindProfileData(feed: element)
                    cell.delegate = self
                }
                .disposed(by: disposeBag)
        
        output.popViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        output.isMyPage
            .bind(with: self, onNext: { owner, isMyPage in
                owner.setWSSNavigationBar(title: isMyPage ? StringLiterals.MyPage.Profile.myProfileFeed : StringLiterals.MyPage.Profile.otherProfileFeed,
                                       left: self.rootView.backButton,
                                       right: nil)
            })
            .disposed(by: disposeBag)
        
        output.pushToNovelDetailViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, novelId in
                owner.pushToDetailViewController(novelId: novelId)
            })
            .disposed(by: disposeBag)
        
        output.pushToFeedDetailViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, feedId in
                owner.pushToFeedDetailViewController(feedId: feedId)
            })
            .disposed(by: disposeBag)        
    }
}

extension MyPageFeedDetailViewController: FeedTableViewDelegate {
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
        self.feedConnectedNovelViewDidTap.accept(novelId)
    }
}
