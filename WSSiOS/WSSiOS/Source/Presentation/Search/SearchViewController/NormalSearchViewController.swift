//
//  NormalSearchViewController.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/27/24.
//

import UIKit

import RxSwift
import RxCocoa
import Then

final class NormalSearchViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: NormalSearchViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = NormalSearchView()
    
    //MARK: - Life Cycle
    
    init(viewModel: NormalSearchViewModel) {
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        registerCell()
        
        bindViewModel()
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.view.do {
            $0.backgroundColor = .White
        }
    }
    
    //MARK: - Bind
    
    private func registerCell() {
        rootView.resultView.normalSearchCollectionView.register(
            NormalSearchCollectionViewCell.self,
            forCellWithReuseIdentifier: NormalSearchCollectionViewCell.cellIdentifier)
    }
    
    private func bindViewModel() {
        let input = NormalSearchViewModel.Input(
            backButtonDidTap: rootView.headerView.backButton.rx.tap,
            inquiryButtonDidTap: rootView.emptyView.inquiryButton.rx.tap
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.normalSearchList
            .bind(to: rootView.resultView.normalSearchCollectionView.rx.items(
                cellIdentifier: NormalSearchCollectionViewCell.cellIdentifier,
                cellType: NormalSearchCollectionViewCell.self)) { row, element, cell in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        output.backButtonEnabled
            .bind(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        output.inquiryButtonEnabled
            .bind(with: self, onNext: { owner, _ in
                if let url = URL(string: StringLiterals.Search.Empty.kakaoChannelUrl) {
                    UIApplication.shared.open(url, options: [:])
                }
            })
            .disposed(by: disposeBag)
    }
}
