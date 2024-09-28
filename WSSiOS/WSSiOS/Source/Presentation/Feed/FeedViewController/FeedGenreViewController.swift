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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        showTabBar()
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
        let likedTapped = PublishSubject<Bool>()
        let commentTapped = PublishSubject<Int>()
        
        let input = FeedGenreViewModel.Input(loadMoreTrigger: loadMoreTrigger,
                                             profileTapped: profileTapped,
                                             contentTapped: contentTapped,
                                             novelTapped: novelTapped,
                                             likedTapped: likedTapped,
                                             commentTapped: commentTapped)
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.feedList
            .bind(to: feedData)
            .disposed(by: disposeBag)
        
        feedData
            .bind(to: rootView.feedCollectionView.rx.items(
                cellIdentifier: FeedCollectionViewCell.cellIdentifier,
                cellType: FeedCollectionViewCell.self)) { (row, element, cell) in                   
                    
                    cell.profileTapHandler = {
                        profileTapped.onNext(element.userId)
                    }
                    
                    cell.contentTapHandler = {
                        contentTapped.onNext(element.feedId)
                    }
                    
                    cell.novelTapHandler = {
                        if let novelId = element.novelId {
                            novelTapped.onNext(novelId)
                        }
                    }
                    
                    cell.commentTapHandler = {
                        commentTapped.onNext(element.feedId)
                    }
                    
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        output.pushToFeedDetailViewController
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, feedId in
                print(feedId, "📌")
                self.pushToFeedDetailViewController(feedId: feedId)
            })
            .disposed(by: disposeBag)
        
        output.pushToNovelDetailViewController
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, novelId in
                print(novelId, "📌📌")
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
