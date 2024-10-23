//
//  DetailSearchResultViewController.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 10/23/24.
//

import UIKit

final class DetailSearchResultViewController: UIViewController {
    
    //MARK: - Properties

    
    //MARK: - Components
    
    private let rootView = DetailSearchResultView()
    
    //MARK: - Life Cycle
    
    init() {
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
        
        registerCell()
        setDelegate()
        
        bindViewModel()
    }
    
    private func registerCell() {
        rootView.novelView.resultNovelCollectionView.register(HomeTasteRecommendCollectionViewCell.self,
                                                              forCellWithReuseIdentifier: HomeTasteRecommendCollectionViewCell.cellIdentifier)
    }
    
    private func setDelegate() {
        rootView.novelView
            .resultNovelCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Bind
    
    private func bindViewModel() {
        let input = DetailSearchResultViewModel.Input(
            backButtonDidTap: rootView.headerView.backButton.rx.tap,
            novelCollectionViewContentSize: rootView.novelView.resultNovelCollectionView.rx.observe(CGSize.self, "contentSize")
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.popViewController
            .bind(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        viewModel.getNovelsObservable()
            .bind(to: rootView.novelView.resultNovelCollectionView.rx.items(cellIdentifier: HomeTasteRecommendCollectionViewCell.cellIdentifier, cellType: HomeTasteRecommendCollectionViewCell.self)) { row, element, cell in
                cell.bindData(data: element)
                print(element.novelTitle)
            }
            .disposed(by: disposeBag)
        
        output.novelCollectionViewHeight
            .subscribe(with: self, onNext: { owner, height in
                owner.rootView.novelView.updateCollectionViewHeight(height: height)
            })
            .disposed(by: disposeBag)
    }
}
