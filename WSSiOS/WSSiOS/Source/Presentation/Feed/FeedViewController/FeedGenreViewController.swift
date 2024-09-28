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
        
        let profileTapped = PublishSubject<Int>()
        let contentTapped = PublishSubject<Int>()
        let novelTapped = PublishSubject<Int>()
        let commentTapped = PublishSubject<Int>()
        
        let input = FeedGenreViewModel.Input(loadMoreTrigger: loadMoreTrigger,
                                             profileTapped: profileTapped,
                                             contentTapped: contentTapped,
                                             novelTapped: novelTapped,
                                             commentTapped: commentTapped)
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.feedList
            .bind(to: feedData)
            .disposed(by: disposeBag)
        
        feedData
            .bind(to: rootView.feedCollectionView.rx.items(
                cellIdentifier: FeedCollectionViewCell.cellIdentifier,
                cellType: FeedCollectionViewCell.self)) { (row, element, cell) in
                    cell.userView.rx.tapGesture()
                        .when(.recognized)
                        .map { _ in element.userId }
                        .bind(to: profileTapped)
                        .disposed(by: cell.disposeBag)
                    
                    cell.detailContentView.rx.tapGesture()
                        .when(.recognized)
                        .map { _ in element.feedId }
                        .bind(to: contentTapped)
                        .disposed(by: cell.disposeBag)
                    
                    cell.novelView.rx.tapGesture()
                        .when(.recognized)
                        .map { _ in element.novelId ?? 0 }
                        .bind(to: novelTapped)
                        .disposed(by: cell.disposeBag)
                    
                    cell.reactView.commentView.rx.tapGesture()
                        .when(.recognized)
                        .map { _ in element.feedId }
                        .bind(to: commentTapped)
                        .disposed(by: cell.disposeBag)
                    
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        //        output.pushToMyPageViewController
        //            .bind(with: self, onNext: { owner, userlId in
        //                owner.pushToMyPageViewController(isMyPage: <#T##Bool#>)
        //            })
        //            .disposed(by: disposeBag)
        
        output.pushToFeedDetailViewController
            .subscribe(with: self, onNext: { owner, feedId in
                self.pushToFeedDetailViewController(feedId: feedId)
            })
            .disposed(by: disposeBag)
        
        output.pushToNovelDetailViewController
            .subscribe(with: self, onNext: { owner, novelId in
                self.pushToDetailViewController(novelId: novelId)
            })
            .disposed(by: disposeBag)
    }
}

extension FeedGenreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let feeds = try? feedData.value, indexPath.item < feeds.count else {
            return CGSize(width: collectionView.frame.width, height: 289)
        }
        
        let cell = FeedCollectionViewCell(frame: CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 0))
        
        let feed = feeds[indexPath.item]
        cell.bindData(data: feed)
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        let targetSize = CGSize(width: collectionView.frame.width, height: UIView.layoutFittingCompressedSize.height)
        let size = cell.systemLayoutSizeFitting(targetSize)
        
        return CGSize(width: collectionView.frame.width, height: size.height)
    }
}
