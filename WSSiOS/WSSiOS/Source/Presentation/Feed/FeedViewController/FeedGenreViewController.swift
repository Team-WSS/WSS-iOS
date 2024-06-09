//
//  FeedGenreViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 5/19/24.
//

import UIKit

import RxSwift

class FeedGenreViewController: UIViewController, UIScrollViewDelegate {

    //MARK: - Properties

    private var feedsDummy: [TotalFeeds]
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private var rootView = FeedView()
    private var viewModel: FeedViewModel
    
    // MARK: - Life Cycle
    
    init(viewModel: FeedViewModel, feedsDummy: [TotalFeeds]) {
        
        self.viewModel = viewModel
        self.feedsDummy = feedsDummy
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
        delegate()
    }
    
    //MARK: - Bind
    
    private func register() {
        rootView.feedCollectionView.register(FeedCollectionViewCell.self,
                                             forCellWithReuseIdentifier: FeedCollectionViewCell.cellIdentifier)
    }
    
    private func bindData() {
        Observable.just(feedsDummy)
            .bind(to: rootView.feedCollectionView.rx.items(
                cellIdentifier: FeedCollectionViewCell.cellIdentifier,
                cellType: FeedCollectionViewCell.self)) { (row, element, cell) in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
    }
    
    private func delegate() {
        rootView.feedCollectionView.rx
            .setDelegate(self).disposed(by: disposeBag)
    }
}

extension FeedGenreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let feeds = try? dummyFeedData, indexPath.item < feeds.count 
        else { return CGSize(width: UIScreen.main.bounds.width, height: 289) }
        
        let text = feeds[indexPath.row].isSpolier ? StringLiterals.Feed.spoilerText : feeds[indexPath.row].feedContent
        let width = UIScreen.main.bounds.width
        
        let feedContentLabel = UILabel().then {
            $0.text = text
            $0.makeAttribute(with: $0.text)?
                .lineHeightMultiple(1.5)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.font = .Body2
            $0.numberOfLines = 5
        }
        
        //TODO: - Font 높이 계산해서 동적 height 할당
        
        let maxSize = CGSize(width: width, height: 115)
        let requiredSize = feedContentLabel.sizeThatFits(maxSize)
        let finalHeight = min(requiredSize.height, 115)
        
        return CGSize(width: width, height: finalHeight + 266)
    }
}
