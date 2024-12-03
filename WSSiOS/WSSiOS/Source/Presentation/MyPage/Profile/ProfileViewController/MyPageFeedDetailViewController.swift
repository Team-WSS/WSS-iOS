//
//  MyPageFeedDetailViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 12/3/24.
//

import UIKit

import RxSwift
import RxGesture

final class MyPageFeedDetailViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: MyPageFeedDetailViewModel
    
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
        
        setNavigation()
    }
    
    private func register() {
        rootView.myPageFeedDetailTableView.register(NovelDetailFeedTableViewCell.self,
                                                    forCellReuseIdentifier: NovelDetailFeedTableViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.myPageFeedDetailTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let loadNextPageTrigger = rootView.myPageFeedDetailTableView.rx.didScroll
            .map { [weak self] in
                guard let self = self else { return false }
                let offsetY = self.rootView.myPageFeedDetailTableView.contentOffset.y
                let contentHeight = self.rootView.myPageFeedDetailTableView.contentSize.height
                let frameHeight = self.rootView.myPageFeedDetailTableView.frame.height
                return offsetY + frameHeight >= contentHeight - 100
            }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in () }
        
        let input = MyPageFeedDetailViewModel.Input(
            loadNextPageTrigger: loadNextPageTrigger,
            popViewController: rootView.backButton.rx.tap)
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.bindFeedData
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.myPageFeedDetailTableView.rx.items(
                cellIdentifier: NovelDetailFeedTableViewCell.cellIdentifier,
                cellType: NovelDetailFeedTableViewCell.self)) { _, element, cell in
                    cell.bindProfileData(feed: element)
                }
                .disposed(by: disposeBag)
        
        output.popViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
    }
}

extension MyPageFeedDetailViewController {
    private func setNavigation() {
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.editProfile,
                                    left: self.rootView.backButton,
                                    right: nil)
    }
}