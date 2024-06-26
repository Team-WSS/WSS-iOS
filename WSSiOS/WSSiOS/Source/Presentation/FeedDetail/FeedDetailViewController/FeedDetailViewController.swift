//
//  FeedDetailViewController.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 6/23/24.
//

import UIKit

import RxSwift
import RxCocoa

final class FeedDetailViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: FeedDetailViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private let rootView = FeedDetailView()
    
    private var backButton = UIButton()
    private var dotsButton = UIButton()
    
    // MARK: - Life Cycle
    
    init(viewModel: FeedDetailViewModel) {
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
        
        preparationSetNavigationBar(title: StringLiterals.FeedDetail.title,
                                    left: self.backButton,
                                    right: self.dotsButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        registerCell()
        bindViewModel()
    }
    
    private func setUI() {
        self.view.backgroundColor = .wssWhite
        
        backButton.do {
            $0.setImage(.icNavigateLeft, for: .normal)
        }
        
        dotsButton.do {
            $0.setImage(.icThreedots, for: .normal)
        }
    }
    
    //MARK: - Bind
    
    private func registerCell() {
        rootView.replyView.replyTableView.register(FeedDetailReplyTableViewCell.self,
                                                   forCellReuseIdentifier: FeedDetailReplyTableViewCell.cellIdentifier)
    }
    
    private func bindViewModel() {
        let input = FeedDetailViewModel.Input()
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.commentDataList
            .bind(to: rootView.replyView.replyTableView.rx.items(
                cellIdentifier: FeedDetailReplyTableViewCell.cellIdentifier,
                cellType: FeedDetailReplyTableViewCell.self)) { row, element, cell in
                cell.bindData(data: element)
            }
            .disposed(by: disposeBag)
    }
}
