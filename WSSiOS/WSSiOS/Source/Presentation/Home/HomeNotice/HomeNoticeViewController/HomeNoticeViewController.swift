//
//  HomeNoticeViewController.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/12/24.
//

import UIKit

import RxSwift

final class HomeNoticeViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: HomeNoticeViewModel
    private let disposeBag = DisposeBag()
    private var backButton = UIButton()
    
    //MARK: - UI Components
    
    private let rootView = HomeNoticeView()
    
    //MARK: - Life Cycle
    
    init(viewModel: HomeNoticeViewModel) {
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
        
        swipeBackGesture()
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.notice,
                                    left: self.backButton,
                                    right: nil)
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
        
        backButton.do {
            $0.setImage(.icNavigateLeft, for: .normal)
        }
    }
    
    //MARK: - Bind
    
    private func registerCell() {
        rootView.noticeTableView.register(
            HomeNoticeTableViewCell.self,
            forCellReuseIdentifier: HomeNoticeTableViewCell.cellIdentifier)
    }
    
    private func bindViewModel() {
        let input = HomeNoticeViewModel.Input(
            noticeCellDidTap: rootView.noticeTableView.rx.itemSelected
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.noticeList
            .bind(to: rootView.noticeTableView.rx.items(
                cellIdentifier: HomeNoticeTableViewCell.cellIdentifier,
                cellType: HomeNoticeTableViewCell.self)) { row, element, cell in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        output.selectedNoticeCellIndexPath
            .bind(with: self, onNext: { owner, indexPath in
                let viewController = HomeNoticeDetailViewController(viewModel: HomeNoticeDetailViewModel(noticeRepository: TestNoticeRepository()))
                viewController.navigationController?.isNavigationBarHidden = false
                viewController.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        self.backButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
    }
}
