//
//  UserPageViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 5/20/25.
//

import UIKit

import RxSwift
import RxCocoa

final class UserPageViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: UserPageViewModel
    
    private var navigationTitle: String = ""
    private var dropDownCellTap = PublishSubject<String>()
    private let headerViewHeightRelay = BehaviorRelay<Double>(value: 0)
    private let viewWillAppearEvent = PublishSubject<Void>()
    private let feedConnectedNovelViewDidTap = PublishRelay<Int>()
    
    //MARK: - UI Components
    
    private var rootView = UserPageView()
    
    // MARK: - Life Cycle
    
    init(viewModel: UserPageViewModel) {
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
        
        delegate()
        register()
        bindViewModel()
        
        AmplitudeManager.shared.track(AmplitudeEvent.MyPage.otherMypage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewWillAppearEvent.onNext(())
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        setNavigation(userNickname: navigationTitle)
        swipeBackGesture()
        hideTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerViewHeightRelay.accept(rootView.headerView.layer.frame.height)
    }
    
    //MARK: - Bind
    
    private func register() {
        rootView.userPageOverviewView.userPageNovelPrefrerencesView.novelPreferenceView.preferencesCollectionView
            .register(UserNovelPreferencesCollectionViewCell.self,
                      forCellWithReuseIdentifier: UserNovelPreferencesCollectionViewCell.cellIdentifier)
        
        rootView.userPageOverviewView.userPageGenrePrefrerencesView.userPageOtherGenreView.genreTableView
            .register(UserGenrePreferencesOtherTableViewCell.self,
                      forCellReuseIdentifier: UserGenrePreferencesOtherTableViewCell.cellIdentifier)
        
        rootView.userPageFeedView.userPageFeedTableView.feedTableView
            .register(FeedListTableViewCell.self,
                      forCellReuseIdentifier: FeedListTableViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.scrollView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        rootView.userPageOverviewView.userPageNovelPrefrerencesView.novelPreferenceView.preferencesCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        rootView.userPageOverviewView.userPageGenrePrefrerencesView.userPageOtherGenreView.genreTableView.delegate = self
        
        rootView.userPageFeedView.userPageFeedTableView.feedTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let inventoryStatusButtonDidTap = Observable<Int>.merge(
            rootView.userPageOverviewView.userPageLibraryStatusView.userLibraryStatusView.readStatusButtons.enumerated().map { index, button in
                button.rx.tap
                    .map { index }
            })
        
        let genrePreferenceButtonDidTap = Observable.merge(
            rootView.userPageOverviewView.userPageGenrePrefrerencesView.userPageGenreOpenButton.rx.tap.map { true },
            rootView.userPageOverviewView.userPageGenrePrefrerencesView.userPageGenreCloseButton.rx.tap.map { false }
        )
        
        let overviewButtonDidTap = Observable.merge(
            rootView.mainStickyHeaderView.overviewButton.rx.tap.map { true },
            rootView.scrolledStickyHeaderView.overviewButton.rx.tap.map { true }
        )
        
        let feedButtonDidTap = Observable.merge(
            rootView.mainStickyHeaderView.feedButton.rx.tap.map { true },
            rootView.scrolledStickyHeaderView.feedButton.rx.tap.map { true }
        )
        
        let input = UserPageViewModel.Input(
            viewWillAppearEvent: self.viewWillAppearEvent,
            headerViewHeight: headerViewHeightRelay.asDriver(),
            resizefeedTableViewHeight: rootView.userPageFeedView.userPageFeedTableView.feedTableView.rx.observe(CGSize.self, "contentSize"),
            resizeKeywordCollectionViewHeight: rootView.userPageOverviewView.userPageNovelPrefrerencesView.novelPreferenceView.preferencesCollectionView.rx.observe(CGSize.self, "contentSize"),
            scrollOffset: rootView.scrollView.rx.contentOffset.asDriver(),
            dropdownButtonDidTap: dropDownCellTap,
            backButtonDidTap: rootView.backButton.rx.tap,
            genrePreferenceButtonDidTap: genrePreferenceButtonDidTap,
            overviewButtonDidTap: overviewButtonDidTap,
            feedButtonDidTap: feedButtonDidTap,
            inventoryViewDidTap: rootView.userPageOverviewView.userPageLibraryStatusView.inventoryTitleView.rx.tapGesture()
                .when(.recognized)
                .asObservable(),
            inventorySpecificPageViewDidTap: inventoryStatusButtonDidTap,
            feedDetailButtonDidTap: rootView.userPageFeedView.userPageFeedDetailButton.rx.tap,
            feedTableViewItemSelected: rootView.userPageFeedView.userPageFeedTableView.feedTableView.rx.itemSelected.asObservable(),
            feedConnectedNovelViewDidTap: feedConnectedNovelViewDidTap.asObservable())
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.profileData
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, data in
                owner.rootView.headerView.bindData(data: data)
            })
            .disposed(by: disposeBag)
        
        output.updateNavigationBar
            .asDriver()
            .drive(with: self, onNext: { owner, data in
                let (update, navigationTitle) = data
                owner.navigationTitle = navigationTitle
                owner.navigationItem.title = update ? navigationTitle : ""
            })
            .disposed(by: disposeBag)
        
        output.updateStickyHeader
            .asDriver()
            .drive(with: self, onNext: { owner, update in
                owner.rootView.scrolledStickyHeaderView.isHidden = !update
                owner.rootView.mainStickyHeaderView.isHidden = update
                owner.rootView.headerView.isHidden = update
            })
            .disposed(by: disposeBag)
        
        output.popViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, data in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        output.isProfilePrivate
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, data in
                let (isPrivate, nickname) = data
                if isPrivate {
                    owner.rootView.userPageOverviewView.isPrivateUserView(isPrivate: isPrivate, nickname: nickname)
                    owner.rootView.userPageFeedView.isPrivateUserView(isPrivate: isPrivate, nickname: nickname)
                }
            })
            .disposed(by: disposeBag)
        
        output.bindGenreData
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] data in
                self?.rootView.userPageOverviewView.userPageGenrePrefrerencesView.bindData(data: data)
            })
            .map { Array($0.genrePreferences.dropFirst(3)) }
            .bind(to: rootView.userPageOverviewView.userPageGenrePrefrerencesView.userPageOtherGenreView.genreTableView.rx.items(
                cellIdentifier: UserGenrePreferencesOtherTableViewCell.cellIdentifier,
                cellType: UserGenrePreferencesOtherTableViewCell.self)) { row, data, cell in
                    cell.bindData(data: data)
                    cell.selectionStyle = .none
                }
                .disposed(by: disposeBag)
        
        output.bindAttractivePointsData
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, data in
                owner.rootView.userPageOverviewView.userPageNovelPrefrerencesView.novelPreferenceView.bindPreferencesDetailData(data: data)
                
            })
            .disposed(by: disposeBag)
        
        output.isExistPreferneces
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, isExist in
                if !isExist {
                    owner.rootView.userPageOverviewView.updatePreferencesEmptyView(isEmpty: !isExist)
                }
            })
            .disposed(by: disposeBag)
        
        output.bindKeywordCell
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.userPageOverviewView.userPageNovelPrefrerencesView.novelPreferenceView.preferencesCollectionView.rx.items(
                cellIdentifier: UserNovelPreferencesCollectionViewCell.cellIdentifier,
                cellType: UserNovelPreferencesCollectionViewCell.self)){ row, data, cell in
                    cell.bindData(data: data)
                }
                .disposed(by: disposeBag)
        
        output.bindInventoryData
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, data in
                owner.rootView.userPageOverviewView.userPageLibraryStatusView.userLibraryStatusView.bindData(data: data)
            })
            .disposed(by: disposeBag)
        
        output.showGenreOtherView
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, show in
                owner.rootView.userPageOverviewView.userPageGenrePrefrerencesView.updateView(showOtherGenreView: show)
                owner.rootView.userPageOverviewView.updateGenreViewHeight(isExpanded: show)
                owner.rootView.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        output.stickyHeaderAction
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, library in
                owner.rootView.mainStickyHeaderView.updateSelection(isOverviewSelected: library)
                owner.rootView.scrolledStickyHeaderView.updateSelection(isOverviewSelected: library)
                
                owner.rootView.userPageOverviewView.isHidden = !library
                owner.rootView.userPageFeedView.isHidden = library
                
                owner.rootView.contentView.snp.remakeConstraints {
                    $0.edges.equalToSuperview()
                    $0.width.equalToSuperview()
                    
                    if library {
                        $0.bottom.equalTo(owner.rootView.userPageOverviewView.snp.bottom)
                    } else {
                        $0.bottom.equalTo(owner.rootView.userPageFeedView.snp.bottom)
                    }
                }
                
                owner.rootView.layoutIfNeeded()
                
            })
            .disposed(by: disposeBag)
        
        output.bindFeedData
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.userPageFeedView.userPageFeedTableView.feedTableView.rx.items(
                cellIdentifier: FeedListTableViewCell.cellIdentifier,
                cellType: FeedListTableViewCell.self)) { _, element, cell in
                    cell.bindProfileFeedData(feed: element)
                    cell.delegate = self
                }
                .disposed(by: disposeBag)
        
        output.isEmptyFeed
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, isEmpty in
                owner.rootView.userPageFeedView.isEmptyView(isEmpty: isEmpty)
            })
            .disposed(by: disposeBag)
        
        output.showFeedDetailButton
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, show in
                owner.rootView.userPageFeedView.showMoreButton(isShow: show)
            })
            .disposed(by: disposeBag)
        
        output.pushToLibraryViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, userId in
                owner.pushToLibraryViewController(userId: userId)
            })
            .disposed(by: disposeBag)
        
        output.pushToSpecificLibraryViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, data in
                let (userId, pageIndex) = data
                owner.pushToLibraryViewController(userId: userId, pageIndex: pageIndex)
            })
            .disposed(by: disposeBag)
        
        output.updateButtonWithLibraryView
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, showLibraryView in
                owner.rootView.showContentView(showLibraryView: showLibraryView)
            })
            .disposed(by: disposeBag)
        
        output.updateFeedTableViewHeight
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, height in
                owner.rootView.userPageFeedView.userPageFeedTableView.updateTableViewHeight(height: height)
            })
            .disposed(by: disposeBag)
        
        output.updateKeywordCollectionViewHeight
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, height in
                owner.rootView.userPageOverviewView.userPageNovelPrefrerencesView.novelPreferenceView.updateKeywordViewHeight(height: height)
            })
            .disposed(by: disposeBag)
        
        output.pushToUserPageFeedDetailViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self as UIViewController, onNext: { owner, userData in
                let (id, data) = userData
                owner.pushToUserPageFeedDetailViewController(userId: id, userData: data)
            })
            .disposed(by: disposeBag)
        
        output.pushToNovelDetailViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, novelId in
                owner.pushToNovelDetailViewController(novelId: novelId)
            })
            .disposed(by: disposeBag)
        
        output.pushToFeedDetailViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, feedId in
                owner.pushToFeedDetailViewController(feedId: feedId)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Custom Method
    
    func scrollToTop() {
        self.rootView.scrollView.setContentOffset(CGPoint(x: 0, y: -self.rootView.scrollView.contentInset.top), animated: true)
    }
}

//MARK: - UIScroll 관련 Delegate

extension UserPageViewController: UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITableViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let keywords = viewModel.bindKeywordRelay.value
        guard indexPath.row < keywords.count else {
            return CGSize(width: 0, height: 0)
        }
        let keyword = keywords[indexPath.row]
        let text = "\(keyword.keywordName) \(keyword.keywordCount)"
        
        
        let width = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 24
        return CGSize(width: width, height: 37)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
}

//MARK: - UI

extension UserPageViewController {
    private func setNavigation(userNickname: String) {
        let dropdownButton = WSSDropdownButton().then {
            $0.makeDropdown(dropdownRootView: self.rootView,
                            dropdownWidth: 120,
                            dropdownLayout: .autoInNavigationBar,
                            dropdownData: [StringLiterals.MyPage.BlockUser.toastText],
                            textColor: .wssBlack)
            .observe(on: MainScheduler.instance)
            .bind(to: dropDownCellTap)
            .disposed(by: disposeBag)
        }
        
        setWSSNavigationBar(title: userNickname,
                            left: rootView.backButton,
                            right: dropdownButton,
                            isVisibleBeforeScroll: false)
    }
}

//MARK: - FeedTableViewDelegate

extension UserPageViewController: FeedTableViewDelegate {
    func profileViewDidTap(userId: Int) {
        return
    }
    
    func dropdownButtonDidTap(feedId: Int, isMyFeed: Bool) {
        return
    }
    
    func likeViewDidTap(feedId: Int, isLiked: Bool) {
        return
    }
    
    func connectedNovelViewDidTap(novelId: Int) {
        self.feedConnectedNovelViewDidTap.accept(novelId)
    }
}
