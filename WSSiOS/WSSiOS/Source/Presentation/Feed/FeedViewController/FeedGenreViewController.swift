//
//  FeedGenreViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 5/19/24.
//

import UIKit

import RxSwift
import RxRelay

class FeedGenreViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let loadMoreTrigger = PublishSubject<Void>()
    private let feedData = BehaviorRelay<[TotalFeeds]>(value: [])
    
    //MARK: - Components
    
    private var rootView = FeedGenreView()
    private var viewModel: FeedGenreViewModel
    
    // MARK: - Life Cycle
    
    init(viewModel: FeedGenreViewModel) {
        
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
    
    //MARK: - Bind
    
    private func register() {
        rootView.feedCollectionView.register(FeedCollectionViewCell.self,
                                             forCellWithReuseIdentifier: FeedCollectionViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.feedCollectionView.rx
            .setDelegate(self).disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = FeedGenreViewModel.Input(loadMoreTrigger: loadMoreTrigger)
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.feedList
            .bind(to: feedData)
            .disposed(by: disposeBag)
        
        feedData
            .bind(to: rootView.feedCollectionView.rx.items(
                cellIdentifier: FeedCollectionViewCell.cellIdentifier,
                cellType: FeedCollectionViewCell.self)) { (row, element, cell) in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
    }
}

extension FeedGenreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let feeds = try? feedData.value, indexPath.item < feeds.count 
        else { return CGSize(width: UIScreen.main.bounds.width, height: 289) }
        
        let isSpolier = feeds[indexPath.row].isSpoiler
        let content = isSpolier ? StringLiterals.Feed.spoilerText : feeds[indexPath.row].feedContent
        let width = UIScreen.main.bounds.width
        
        let feedContentLabel = UILabel().then {
            $0.applyWSSFont(.body2, with: content)
            $0.textColor = isSpolier ? .wssSecondary100 : .wssBlack
            $0.textAlignment = .natural
            $0.numberOfLines = 5
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
        }
        
        let maxSize = CGSize(width: width, height: 115)
        let requiredSize = feedContentLabel.sizeThatFits(maxSize)
        let finalHeight = min(requiredSize.height, 115)
        
        return CGSize(width: width, height: finalHeight + 266)
    }
}
