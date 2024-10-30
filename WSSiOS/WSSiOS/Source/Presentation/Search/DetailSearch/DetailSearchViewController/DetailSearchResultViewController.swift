//
//  DetailSearchResultViewController.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 10/23/24.
//

import UIKit

import RxSwift
import RxCocoa

final class DetailSearchResultViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    
    private let viewModel: DetailSearchResultViewModel
    private let disposeBag = DisposeBag()
    
    private let viewDidLoadEvent = PublishRelay<Void>()
    
    //MARK: - Components
    
    private let rootView = DetailSearchResultView()
    
    //MARK: - Life Cycle
    
    init(viewModel: DetailSearchResultViewModel) {
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
        
        setNavigationBar()
        swipeBackGesture()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        setDelegate()

        bindViewModel()
        
        viewDidLoadEvent.accept(())
    }
    
    private func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
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
            novelCollectionViewContentSize: rootView.novelView.resultNovelCollectionView.rx.observe(CGSize.self, "contentSize"),
            novelResultCellSelected: rootView.novelView.resultNovelCollectionView.rx.itemSelected,
            searchHeaderViewDidTap: rootView.headerView.backgroundView.rx.tapGesture().when(.recognized).asObservable(),
            viewDidLoadEvent: self.viewDidLoadEvent.asObservable()
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.popViewController
            .bind(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        output.filteredNovelsData
            .map { $0.novels }
            .bind(to: rootView.novelView.resultNovelCollectionView.rx.items(cellIdentifier: HomeTasteRecommendCollectionViewCell.cellIdentifier, cellType: HomeTasteRecommendCollectionViewCell.self)) { row, element, cell in
                cell.bindData(data: element)
            }
            .disposed(by: disposeBag)
        
        output.novelCollectionViewHeight
            .subscribe(with: self, onNext: { owner, height in
                owner.rootView.novelView.updateCollectionViewHeight(height: height)
            })
            .disposed(by: disposeBag)
        
        output.filteredNovelsData
            .map { $0.resultCount }
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, count in
                owner.rootView.novelView.updateNovelCountLabel(count: count)
            })
            .disposed(by: disposeBag)
        
        output.pushToNovelDetailViewController
            .subscribe(with: self, onNext: { owner, novelId in
                owner.pushToDetailViewController(novelId: novelId)
            })
            .disposed(by: disposeBag)
        
        output.presentDetailSearchModal
            .subscribe(with: self, onNext: { owner, _ in
                owner.presentToDetailSearchViewController(selectedKeywordList: [])
            })
            .disposed(by: disposeBag)
    }
}
