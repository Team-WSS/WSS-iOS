//
//  NovelDetailViewController.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/25/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

/// Detail View
final class NovelDetailViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: NovelDetailViewModel
    private let disposeBag = DisposeBag()
    
    private let viewWillAppearEvent = PublishRelay<Void>()
    private let imageNetworkError = BehaviorRelay<Bool>(value: false)
    private let deleteReview = PublishSubject<Void>()
    
    private var navigationTitle: String = ""
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = StringLiterals.Register.Normal.DatePicker.dateFormat
        $0.timeZone = TimeZone(identifier: StringLiterals.Register.Normal.DatePicker.KoreaTimeZone)
    }
    
    // NovelDetailFeed
    private let novelDetailFeedProfileViewDidTap = PublishRelay<Int>()
    private let novelDetailFeedDropdownButtonDidTap = PublishRelay<(Int, Bool)>()
    private let novelDetailFeedConnectedNovelViewDidTap = PublishRelay<Int>()
    private let novelDetailFeedLikeViewDidTap = PublishRelay<(Int, Bool)>()
    private let reloadNovelDetailFeed = PublishRelay<Void>()
    
    //MARK: - Components
    
    private let rootView = NovelDetailView()
    
    //MARK: - Life Cycle
    
    init(viewModel: NovelDetailViewModel) {
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
        
        registerCell()
        delegate()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewWillAppearEvent.accept(())
        setNavigationBar()
        swipeBackGesture()
        self.hidesBottomBarWhenPushed = true
    }
    
    //MARK: - UI
    
    private func setNavigationBar() {
        self.setWSSNavigationBar(title: navigationTitle, left: rootView.backButton, right: rootView.headerDropDownButton, isVisibleBeforeScroll: false)
    }
    
    //MARK: - Bind
    
    private func registerCell() {
        rootView.infoView.platformView.platformCollectionView.register(
            NovelDetailInfoPlatformCollectionViewCell.self,
            forCellWithReuseIdentifier: NovelDetailInfoPlatformCollectionViewCell.cellIdentifier)
        
        rootView.infoView.reviewView.keywordView.keywordCollectionView.register(
            NovelDetailInfoReviewKeywordCollectionViewCell.self,
            forCellWithReuseIdentifier: NovelDetailInfoReviewKeywordCollectionViewCell.cellIdentifier)
        
        rootView.feedView.feedListView.feedTableView.register(
            FeedListTableViewCell.self,
            forCellReuseIdentifier: FeedListTableViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.infoView.reviewView.keywordView.keywordCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        rootView.scrollView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = createViewModelInput()
        let output = viewModel.transform(from: input,
                                         disposeBag: disposeBag)
        bindViewModelOutput(output)
    }
    
    private func bindViewModelOutput(_ output: NovelDetailViewModel.Output) {
        
        //MARK: - Bind/Total
         
        output.detailHeaderData
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in
                owner.rootView.bindHeaderData(data)
                owner.rootView.showLoadingView(isShow: false)
                owner.makeUIImage(data: data)
                owner.navigationTitle = data.novelTitle
                owner.setNavigationBar()
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        output.detailInfoData
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in
                owner.rootView.bindInfoData(data)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        output.scrollContentOffset
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(with: self, onNext: { owner, offset in
                let stickyoffset = owner.rootView.headerView.frame.size.height - owner.view.safeAreaInsets.top
                let showStickyTabBar = offset.y > stickyoffset
                owner.rootView.updateStickyTabBarShow(showStickyTabBar)
            })
            .disposed(by: disposeBag)
        
        output.popToLastViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        output.showNetworkErrorView
            .drive(with: self, onNext: { owner, isShow in
                owner.rootView.showNetworkErrorView(isShow: isShow)
            })
            .disposed(by: disposeBag)
        
        output.hidefirstReviewDescriptionView
            .drive(with: self, onNext: { owner, isHidden in
                owner.rootView.showFirstDescriptionView(isHidden: isHidden)
            })
            .disposed(by: disposeBag)
        
        output.showReviewDeleteAlert
            .flatMapLatest { _ in
                self.presentToAlertViewController(
                    iconImage: .icModalWarning,
                    titleText: StringLiterals.NovelDetail.Header.deleteReviewAlertTitle,
                    contentText: StringLiterals.NovelDetail.Header.deleteReviewAlertDescription,
                    leftTitle: StringLiterals.NovelDetail.Header.deleteCancel,
                    rightTitle: StringLiterals.NovelDetail.Header.deleteAccept,
                    rightBackgroundColor: UIColor.wssSecondary100.cgColor
                )
            }
            .bind(with: self, onNext: { owner, buttonType in
                owner.rootView.showHeaderDropDownView(isShow: false)
                if buttonType == .right {
                    owner.deleteReview.onNext(())
                }
            })
            .disposed(by: disposeBag)
        
        output.showReviewDeletedToast
            .drive(with: self, onNext: { owner, _ in
                owner.showToast(.novelReviewDeleted)
            })
            .disposed(by: disposeBag)
        
        //MARK: - Bind/NovelDetailHeader
        
        output.showLargeNovelCoverImage
            .drive(with: self, onNext: { owner, isShow in
                owner.showLargeNovelCoverImageView(isShow)
            })
            .disposed(by: disposeBag)
        
        output.pushToReviewViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, result in
                let (isInterest, readStatus, novelId, novelTitle) = result
                owner.pushToNovelReviewViewController(isInterest: isInterest,
                                                      readStatus: readStatus,
                                                      novelId: novelId,
                                                      novelTitle: novelTitle)
            })
            .disposed(by: disposeBag)
        
        output.isUserNovelInterested
            .drive(with: self, onNext: { owner, isInterested in
                owner.rootView.headerView.interestReviewButton.updateInterestButtonState(isInterested)
            })
            .disposed(by: disposeBag)
        
        output.pushTofeedWriteViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, result in
                let (genre, novelId, novelTitle) = result
                owner.pushToFeedEditViewController(relevantCategories: genre,
                                                   novelId: novelId,
                                                   novelTitle: novelTitle)
            })
            .disposed(by: disposeBag)
        
        output.showHeaderDropdownView
            .drive(with: self, onNext: { owner, isShow in
                owner.rootView.showHeaderDropDownView(isShow: isShow)
            })
            .disposed(by: disposeBag)
        
        output.showReportPage
            .drive(with: self, onNext: { owner, _ in
                owner.rootView.showHeaderDropDownView(isShow: false)
                if let url = URL(string: URLs.Contact.kakao) {
                    UIApplication.shared.open(url, options: [:])
                }
            })
            .disposed(by: disposeBag)
        
        //MARK: - Bind/Tab
        
        output.selectedTab
            .drive(with: self, onNext: { owner, tab in
                owner.rootView.updateTab(selected: tab)
                owner.rootView.showCreateFeedButton(show: tab == .feed)
                
                if tab == .info {
                    AmplitudeManager.shared.track(AmplitudeEvent.Novel.novelInfo)
                } else {
                    AmplitudeManager.shared.track(AmplitudeEvent.Novel.novelFeed)
                }
            })
            .disposed(by: disposeBag)
        
        //MARK: - Bind/NovelDetailInfo
        
        output.isInfoDescriptionExpended
            .drive(with: self, onNext: { owner, isExpended in
                owner.rootView.infoView.descriptionView.updateAccordionButton(isExpended)
            })
            .disposed(by: disposeBag)
        
        output.platformList
            .drive(rootView.infoView.platformView.platformCollectionView.rx.items(
                cellIdentifier: NovelDetailInfoPlatformCollectionViewCell.cellIdentifier,
                cellType: NovelDetailInfoPlatformCollectionViewCell.self)) { _, element, cell in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        rootView.infoView.platformView.platformCollectionView.rx.itemSelected
            .withLatestFrom(output.platformList) {(indexPath: $0, platformList: $1)}
            .subscribe(with: self, onNext: { owner, data in
                AmplitudeManager.shared.track(AmplitudeEvent.Novel.directNovel)
                if let url = URL(string: data.platformList[data.indexPath.item].platformURL) {
                    UIApplication.shared.open(url, options: [:])
                }
            })
            .disposed(by: disposeBag)
        
        output.keywordList
            .drive(rootView.infoView.reviewView.keywordView.keywordCollectionView.rx.items(
                cellIdentifier: NovelDetailInfoReviewKeywordCollectionViewCell.cellIdentifier,
                cellType: NovelDetailInfoReviewKeywordCollectionViewCell.self)) { _, element, cell in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        output.reviewSectionVisibilities
            .drive(with: self, onNext: { owner, visibilities in
                owner.rootView.infoView.updateVisibility(visibilities)
            })
            .disposed(by: disposeBag)
        
        //MARK: - Bind/NovelDetailFeed
        
        output.feedList
            .bind(to: rootView.feedView.feedListView.feedTableView.rx.items(
                cellIdentifier: FeedListTableViewCell.cellIdentifier,
                cellType: FeedListTableViewCell.self)) { _, element, cell in
                    cell.bindData(feed: element)
                    cell.delegate = self
                }
                .disposed(by: disposeBag)
        
        output.feedList
            .skip(1)
            .subscribe(with: self, onNext: { owner, feedList in
                owner.rootView.feedView.bindData(isEmpty: feedList.isEmpty)
            })
            .disposed(by: disposeBag)
        
        output.novelDetailFeedTableViewHeight
            .subscribe(with: self, onNext: { owner, height in
                owner.rootView.feedView.feedListView.updateTableViewHeight(height: height)
            })
            .disposed(by: disposeBag)
        
        output.pushToFeedDetailViewController
            .subscribe(with: self, onNext: { owner, feedId in
                owner.pushToFeedDetailViewController(feedId: feedId)
            })
            .disposed(by: disposeBag)
        
        output.pushToUserViewController
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
                owner.rootView.feedView.feedListView.showDropdownView(indexPath: indexPath,
                                                                      isMyFeed: isMyFeed)
            })
            .disposed(by: disposeBag)
        
        output.hideDropdownView
            .subscribe(with: self, onNext: { owner, _ in
                owner.rootView.feedView.feedListView.hideDropdownView()
            })
            .disposed(by: disposeBag)
        
        output.toggleDropdownView
            .subscribe(with: self, onNext: { owner, _ in
                owner.rootView.feedView.feedListView.toggleDropdownView()
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
                owner.rootView.feedView.feedListView.dropdownView.isHidden = true
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
                owner.reloadNovelDetailFeed.accept(())
            }, onError: { owner, error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
        
        output.showFeedEditedToast
            .subscribe(with: self, onNext: { owner, _ in
                owner.showToast(.feedEdited)
            })
            .disposed(by: disposeBag)
        
        output.showWithdrawalUserToastView
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                owner.showToast(.unknownUser)
            })
            .disposed(by: disposeBag)
        
        //MARK: - Bind/NovelReview
        
        output.showNovelReviewedToast
            .subscribe(with: self, onNext: { owner, _ in
                owner.showToast(.novelReviewed)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Actions
    
    private func createViewModelInput() -> NovelDetailViewModel.Input {
        let reviewResultButtonDidTap = Observable<ReadStatus?>.merge(
            rootView.headerView.reviewResultView.readStatusButtons
                .map{ button in
                    button.rx.tap.map { button.readStatus }
                }
            + rootView.headerView.reviewResultView.readInfoButtons
                .map{
                    button in
                    button.rx.tap.map { nil }
                })
        
        let dropdownButtonDidTap = Observable.merge(
            rootView.feedView.feedListView.dropdownView.topDropdownButton.rx.tap.map { DropdownButtonType.top },
            rootView.feedView.feedListView.dropdownView.bottomDropdownButton.rx.tap.map { DropdownButtonType.bottom }
        )
        
        let headerDropdownButtonDidTap = Observable.merge(
            rootView.headerDropDownView.topDropdownButton.rx.tap.map { DropdownButtonType.top },
            rootView.headerDropDownView.bottomDropdownButton.rx.tap.map { DropdownButtonType.bottom }
        )
        
        return NovelDetailViewModel.Input(
            viewWillAppearEvent: viewWillAppearEvent.asObservable(),
            scrollContentOffset: rootView.scrollView.rx.contentOffset,
            backButtonDidTap: rootView.backButton.rx.tap,
            networkErrorRefreshButtonDidTap: rootView.networkErrorView.refreshButton.rx.tap,
            imageNetworkError: imageNetworkError.asObservable(),
            deleteReview: deleteReview.asObservable(),
            backgroundDidTap: rootView.rx.tapGesture(configuration: { gestureRecognizer, delegate in
                gestureRecognizer.cancelsTouchesInView = false
            }),
            firstDescriptionBackgroundDidTap: rootView.firstReviewDescriptionBackgroundView.rx.tap,
            headerDotsButtonDidTap: rootView.headerDropDownButton.rx.tap,
            headerDropdownButtonDidTap: headerDropdownButtonDidTap,
            novelCoverImageButtonDidTap: rootView.headerView.coverImageButton.rx.tap,
            largeNovelCoverImageDismissButtonDidTap: rootView.largeNovelCoverImageButton.dismissButton.rx.tap,
            largeNovelCoverImageBackgroundDidTap: rootView.largeNovelCoverImageButton.rx.tap,
            reviewResultButtonDidTap: reviewResultButtonDidTap,
            interestButtonDidTap: rootView.headerView.interestReviewButton.interestButton.rx.tap,
            feedWriteButtonDidTap: rootView.headerView.interestReviewButton.feedWriteButton.rx.tap,
            infoTabBarButtonDidTap: rootView.tabBarView.infoButton.rx.tap,
            feedTabBarButtonDidTap: rootView.tabBarView.feedButton.rx.tap,
            stickyInfoTabBarButtonDidTap: rootView.stickyTabBarView.infoButton.rx.tap,
            stickyFeedTabBarButtonDidTap: rootView.stickyTabBarView.feedButton.rx.tap,
            descriptionAccordionButtonDidTap: rootView.infoView.descriptionView.accordionButton.rx.tap,
            novelDetailFeedTableViewContentSize: rootView.feedView.feedListView.feedTableView.rx.observe(CGSize.self, "contentSize"),
            novelDetailFeedTableViewItemSelected: rootView.feedView.feedListView.feedTableView.rx.itemSelected.asObservable(),
            novelDetailFeedProfileViewDidTap: novelDetailFeedProfileViewDidTap.asObservable(),
            novelDetailFeedDropdownButtonDidTap: novelDetailFeedDropdownButtonDidTap.asObservable(),
            dropdownButtonDidTap: dropdownButtonDidTap,
            novelDetailFeedConnectedNovelViewDidTap: novelDetailFeedConnectedNovelViewDidTap.asObservable(),
            novelDetailFeedLikeViewDidTap: novelDetailFeedLikeViewDidTap.asObservable(),
            reloadNovelDetailFeed: reloadNovelDetailFeed.asObservable(),
            scrollViewReachedBottom: observeReachedBottom(rootView.scrollView),
            createFeedButtonDidTap: rootView.createFeedButton.rx.tap,
            feedEditedNotification: NotificationCenter.default.rx.notification(Notification.Name("FeedEdited")).asObservable(),
            novelReviewedNotification: NotificationCenter.default.rx.notification(Notification.Name("NovelReviewed")).asObservable()
        )
    }
    
    //MARK: - Custom Method
    
    private func showLargeNovelCoverImageView(_ isShow: Bool) {
        rootView.largeNovelCoverImageButton.isHidden = !isShow
        self.navigationController?.setNavigationBarHidden(isShow, animated: false)
    }
    
    private func makeUIImage(data: NovelDetailHeaderEntity) {
        Observable.zip (
            KingFisherRxHelper.kingFisherImage(urlString: data.novelImage),
            KingFisherRxHelper.kingFisherImage(urlString: data.novelGenreImage)
        )
        .subscribe(with: self, onNext: { owner, result in
            let (novelImage, genreImage) = result
            owner.rootView.bindHeaderImage(novelImage: novelImage, genreImage: genreImage)
        }, onError: { owner, error in
            print(error)
            owner.imageNetworkError.accept(true)
        })
        .disposed(by: disposeBag)
    }
    
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

extension NovelDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let text = viewModel.keywordNameForItemAt(indexPath: indexPath) else {
            return CGSize(width: 0, height: 0)
        }
        
        let width = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 24
        return CGSize(width: width, height: 37)
    }
}

extension NovelDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
}

extension NovelDetailViewController: FeedTableViewDelegate {
    func profileViewDidTap(userId: Int) {
        self.novelDetailFeedProfileViewDidTap.accept(userId)
    }
    
    func dropdownButtonDidTap(feedId: Int, isMyFeed: Bool) {
        self.novelDetailFeedDropdownButtonDidTap.accept((feedId, isMyFeed))
    }
    
    func connectedNovelViewDidTap(novelId: Int) {
        self.novelDetailFeedConnectedNovelViewDidTap.accept(novelId)
    }
    
    func likeViewDidTap(feedId: Int, isLiked: Bool) {
        self.novelDetailFeedLikeViewDidTap.accept((feedId, isLiked))
    }
}
