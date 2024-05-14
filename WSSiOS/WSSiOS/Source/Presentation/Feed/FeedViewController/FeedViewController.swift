//
//  FeedViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 5/14/24.
//

import UIKit

import RxSwift
import RxRelay

final class FeedViewController: UIViewController {
    
    //MARK: - Properties
    
    private var feedListRelay = BehaviorRelay<[TotalFeeds]>(value: [])
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private var rootView = FeedView()
    private var viewModel: FeedViewModel
    
    // MARK: - Life Cycle
    
    init(viewModel: FeedViewModel) {
        
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
        bindData()
        //        bindViewModel()
    }
    
    
    //MARK: - Bind
    
    private func register() {
        rootView.feedCollectionView.register(FeedCollectionViewCell.self,
                                             forCellWithReuseIdentifier: FeedCollectionViewCell.cellIdentifier)
    }
    
    private func bindData() {
        Observable.just(dummy)
            .bind(to: rootView.feedCollectionView.rx.items(
                cellIdentifier: FeedCollectionViewCell.cellIdentifier,
                cellType: FeedCollectionViewCell.self)) { (row, element, cell) in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
    }
    
    
    private func bindViewModel() {
        let input = FeedViewModel.Input()
        let output = viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.feedList
            .bind(to: rootView.feedCollectionView.rx.items(
                cellIdentifier: FeedCollectionViewCell.cellIdentifier,
                cellType: FeedCollectionViewCell.self)) { (row, element, cell) in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
    }
}
