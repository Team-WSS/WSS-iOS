//
//  FeedGenreViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 5/19/24.
//

import UIKit

import RxSwift
import RxRelay
import RxGesture

class FeedGenreViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    private let feedProfileViewDidTap = PublishRelay<Int>()
    private let feedDropdownButtonDidTap = PublishRelay<(Int, Bool)>()
    private let feedConnectedNovelViewDidTap = PublishRelay<Int>()
    private let feedLikeViewDidTap = PublishRelay<(Int, Bool)>()
    private let reloadFeed = PublishRelay<Void>()
    
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
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadFeed.accept(())
        navigationController?.setNavigationBarHidden(true, animated: true)
        showTabBar()
    }
    
    //MARK: - Bind
    
    private func register() {
        rootView.feedTableView.register(FeedListTableViewCell.self,
                                        forCellReuseIdentifier: FeedListTableViewCell.cellIdentifier)
    }
    
    private func bindViewModel() {
        let dropdownButtonDidTap = Observable.merge(
            rootView.dropdownView.topDropdownButton.rx.tap.map { DropdownButtonType.top },
            rootView.dropdownView.bottomDropdownButton.rx.tap.map { DropdownButtonType.bottom }
        )
        
        let input = FeedGenreViewModel.Input(
            reloadFeed: reloadFeed.asObservable(),
            feedTableViewItemSelected: rootView.feedTableView.rx.itemSelected.asObservable(),
            feedProfileViewDidTap: feedProfileViewDidTap.asObservable(),
            feedDropdownButtonDidTap: feedDropdownButtonDidTap.asObservable(),
            dropdownButtonDidTap: dropdownButtonDidTap,
            feedConnectedNovelViewDidTap: feedConnectedNovelViewDidTap.asObservable(),
            feedLikeViewDidTap: feedLikeViewDidTap.asObservable(),
            feedTableViewVillBeginDragging: rootView.feedTableView.rx.willBeginDragging.asObservable(),
            feedTableViewReachedBottom: observeReachedBottom(rootView.feedTableView),
            feedTableViewIsRefreshing: rootView.feedTableView.refreshControl!.rx.controlEvent(.valueChanged).asObservable()
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.feedList
            .bind(to: rootView.feedTableView.rx.items(
                cellIdentifier: FeedListTableViewCell.cellIdentifier,
                cellType: FeedListTableViewCell.self)) { _, element, cell in
                    cell.bindData(feed: element)
                    cell.delegate = self
                }
                .disposed(by: disposeBag)
        
        output.feedList
            .skip(1)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, feedList in
                owner.rootView.bindData(isEmpty: feedList.isEmpty)
            })
            .disposed(by: disposeBag)
        
        output.pushToFeedDetailViewController
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, feedId in
                owner.pushToFeedDetailViewController(feedId: feedId)
            })
            .disposed(by: disposeBag)
        
        output.pushToUserViewController
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, userId in
                owner.pushToMyPageViewController(userId: userId)
            })
            .disposed(by: disposeBag)
        
        output.pushToNovelDetailViewController
            .subscribe(with: self, onNext: { owner, novelId in
                owner.pushToDetailViewController(novelId: novelId)
            })
            .disposed(by: disposeBag)
        
        output.showDropdownView
            .subscribe(with: self, onNext: { owner, data in
                let (indexPath, isMyFeed) = data
                owner.rootView.showDropdownView(indexPath: indexPath,
                                                isMyFeed: isMyFeed)
            })
            .disposed(by: disposeBag)
        
        output.hideDropdownView
            .subscribe(with: self, onNext: { owner, _ in
                owner.rootView.hideDropdownView()
            })
            .disposed(by: disposeBag)
        
        output.toggleDropdownView
            .subscribe(with: self, onNext: { owner, _ in
                owner.rootView.toggleDropdownView()
            })
            .disposed(by: disposeBag)
        
        output.showSpoilerAlertView
            .flatMapLatest { postSpoilerFeed, feedId in
                self.presentToAlertViewController(
                    iconImage: .icModalWarning,
                    titleText: StringLiterals.FeedDetail.spoilerTitle,
                    contentText: nil,
                    leftTitle: StringLiterals.FeedDetail.cancel,
                    rightTitle: StringLiterals.FeedDetail.report,
                    rightBackgroundColor: UIColor.wssPrimary100.cgColor
                )
                .flatMapLatest { buttonType in
                    if buttonType == .right {
                        AmplitudeManager.shared.track(AmplitudeEvent.Feed.alertFeedSpoiler)
                        return postSpoilerFeed(feedId)
                    } else {
                        return Observable.empty()
                    }
                }
            }
            .subscribe(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true) {
                    _ = owner.presentToAlertViewController(
                        iconImage: .icReportCheck,
                        titleText: StringLiterals.FeedDetail.reportResult,
                        contentText: nil,
                        leftTitle: nil,
                        rightTitle: StringLiterals.FeedDetail.confirm,
                        rightBackgroundColor: UIColor.wssPrimary100.cgColor
                    )
                }
            }, onError: { owner, error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
        
        output.showImproperAlertView
            .flatMapLatest { postImpertinenceFeed, feedId in
                self.presentToAlertViewController(
                    iconImage: .icModalWarning,
                    titleText: StringLiterals.FeedDetail.impertinentTitle,
                    contentText: nil,
                    leftTitle: StringLiterals.FeedDetail.cancel,
                    rightTitle: StringLiterals.FeedDetail.report,
                    rightBackgroundColor: UIColor.wssPrimary100.cgColor
                )
                .flatMapLatest { buttonType in
                    if buttonType == .right {
                        AmplitudeManager.shared.track(AmplitudeEvent.Feed.alertFeedAbuse)
                        return postImpertinenceFeed(feedId)
                    } else {
                        return Observable.empty()
                    }
                }
            }
            .subscribe(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true) {
                    _ = owner.presentToAlertViewController(
                        iconImage: .icReportCheck,
                        titleText: StringLiterals.FeedDetail.reportResult,
                        contentText: StringLiterals.FeedDetail.impertinentContent,
                        leftTitle: nil,
                        rightTitle: StringLiterals.FeedDetail.confirm,
                        rightBackgroundColor: UIColor.wssPrimary100.cgColor
                    )
                }
            }, onError: { owner, error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
        
        output.pushToFeedEditViewController
            .subscribe(with: self, onNext: { owner, feedId in
                owner.pushToFeedEditViewController(feedId: feedId)
            })
            .disposed(by: disposeBag)
        
        output.showDeleteAlertView
            .flatMapLatest { deleteFeed, feedId in
                self.presentToAlertViewController(
                    iconImage: .icModalWarning,
                    titleText: StringLiterals.FeedDetail.deleteTitle,
                    contentText: StringLiterals.FeedDetail.deleteContent,
                    leftTitle: StringLiterals.FeedDetail.cancel,
                    rightTitle: StringLiterals.FeedDetail.delete,
                    rightBackgroundColor: UIColor.wssSecondary100.cgColor
                )
                .flatMapLatest { buttonType in
                    if buttonType == .right {
                        return deleteFeed(feedId)
                    } else {
                        return Observable.empty()
                    }
                }
            }
            .subscribe(with: self, onNext: { owner, _ in
                owner.reloadFeed.accept(())
            }, onError: { owner, error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
        
        output.feedTableViewEndRefreshing
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                owner.rootView.feedTableView.refreshControl?.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        output.showWithdrawalUserToastView
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                owner.showToast(.unknownUser)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Custom Method
    
    private func observeReachedBottom(_ scrollView: UIScrollView) -> Observable<Bool> {
        return scrollView.rx.contentOffset
            .map { contentOffset in
                let contentHeight = scrollView.contentSize.height
                let viewHeight = scrollView.frame.size.height
                let offsetY = contentOffset.y
                
                return offsetY + viewHeight >= contentHeight
            }
            .distinctUntilChanged()
    }
}

extension FeedGenreViewController: FeedTableViewDelegate {
    func profileViewDidTap(userId: Int) {
        self.feedProfileViewDidTap.accept(userId)
    }
    
    func dropdownButtonDidTap(feedId: Int, isMyFeed: Bool) {
        self.feedDropdownButtonDidTap.accept((feedId, isMyFeed))
    }
    
    func connectedNovelViewDidTap(novelId: Int) {
        self.feedConnectedNovelViewDidTap.accept(novelId)
    }
    
    func likeViewDidTap(feedId: Int, isLiked: Bool) {
        self.feedLikeViewDidTap.accept((feedId, isLiked))
    }
}
