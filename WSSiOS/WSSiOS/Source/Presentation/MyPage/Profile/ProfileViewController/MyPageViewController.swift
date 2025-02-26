//
//  MyPageViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 7/9/24.
//

import UIKit

import RxSwift
import RxCocoa

enum EntryType {
    case tabBar
    case otherVC
}

final class MyPageViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: MyPageViewModel
    var entryType: EntryType = .otherVC
    
    private var navigationTitle: String = ""
    
    private let isEntryTabbarRelay = BehaviorRelay<Bool>(value: false)
    private var dropDownCellTap = PublishSubject<String>()
    private let headerViewHeightRelay = BehaviorRelay<Double>(value: 0)
    private let viewWillAppearEvent = PublishSubject<Void>()
    private let feedConnectedNovelViewDidTap = PublishRelay<Int>()
    
    //MARK: - UI Components
    
    private var rootView = MyPageView()
    
    // MARK: - Life Cycle
    
    init(viewModel: MyPageViewModel) {
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
        
        switch entryType {
        case .tabBar:
            print("탭바에서 진입")
            AmplitudeManager.shared.track(AmplitudeEvent.MyPage.mypage)
            isEntryTabbarRelay.accept(true)
            
        case .otherVC:
            print("다른 VC에서 진입")
            AmplitudeManager.shared.track(AmplitudeEvent.MyPage.otherMypage)
            isEntryTabbarRelay.accept(false)
            hideTabBar()
            swipeBackGesture()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.viewWillAppearEvent.onNext(())
        decideNavigation(myPage: entryType == .tabBar, navigationTitle: navigationTitle)
        swipeBackGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerViewHeightRelay.accept(rootView.headerView.layer.frame.height)
    }
    
    private func register() {
        rootView.myPageLibraryView.novelPrefrerencesView.preferencesCollectionView.register(
            MyPageNovelPreferencesCollectionViewCell.self,
            forCellWithReuseIdentifier: MyPageNovelPreferencesCollectionViewCell.cellIdentifier)
        
        rootView.myPageLibraryView.genrePrefrerencesView.otherGenreView.genreTableView.register(MyPageGenrePreferencesOtherTableViewCell.self, forCellReuseIdentifier: MyPageGenrePreferencesOtherTableViewCell.cellIdentifier)
        
        rootView.myPageFeedView.myPageFeedTableView.feedTableView.register(FeedListTableViewCell.self, forCellReuseIdentifier: FeedListTableViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.scrollView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        rootView.myPageLibraryView.novelPrefrerencesView.preferencesCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        rootView.myPageLibraryView.genrePrefrerencesView.otherGenreView.genreTableView.delegate = self
        
        rootView.myPageFeedView.myPageFeedTableView.feedTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Bind
    
    private func bindViewModel() {
        let inventoryStatusButtonDidTap = Observable<Int>.merge(
            rootView.myPageLibraryView.inventoryView.readStatusButtons.enumerated().map { index, button in
                button.rx.tap
                    .map { index }
            })
        
        let genrePreferenceButtonDidTap = Observable.merge(
            rootView.myPageLibraryView.genrePrefrerencesView.myPageGenreOpenButton.rx.tap.map { true },
            rootView.myPageLibraryView.genrePrefrerencesView.myPageGenreCloseButton.rx.tap.map { false }
        )
        
        let libraryButtonDidTap = Observable.merge(
            rootView.mainStickyHeaderView.libraryButton.rx.tap.map { true },
            rootView.scrolledStickyHeaderView.libraryButton.rx.tap.map { true }
        )
        
        let feedButtonDidTap = Observable.merge(
            rootView.mainStickyHeaderView.feedButton.rx.tap.map { true },
            rootView.scrolledStickyHeaderView.feedButton.rx.tap.map { true }
        )
        
        let input = MyPageViewModel.Input(
            isEntryTabbar: isEntryTabbarRelay.asObservable(),
            viewWillAppearEvent: self.viewWillAppearEvent,
            headerViewHeight: headerViewHeightRelay.asDriver(),
            resizefeedTableViewHeight: rootView.myPageFeedView.myPageFeedTableView.feedTableView.rx.observe(CGSize.self, "contentSize"),
            resizeKeywordCollectionViewHeight: rootView.myPageLibraryView.novelPrefrerencesView.preferencesCollectionView.rx.observe(CGSize.self, "contentSize"),
            scrollOffset: rootView.scrollView.rx.contentOffset.asDriver(),
            settingButtonDidTap: rootView.settingButton.rx.tap,
            dropdownButtonDidTap: dropDownCellTap,
            editButtonDidTap: rootView.headerView.userImageChangeButton.rx.tap,
            backButtonDidTap: rootView.backButton.rx.tap,
            genrePreferenceButtonDidTap: genrePreferenceButtonDidTap,
            libraryButtonDidTap: libraryButtonDidTap,
            feedButtonDidTap: feedButtonDidTap,
            inventoryViewDidTap: rootView.myPageLibraryView.inventoryView.inventoryTitleView.rx.tapGesture()
                .when(.recognized)
                .asObservable(),
            inventorySpecificPageViewDidTap: inventoryStatusButtonDidTap,
            feedDetailButtonDidTap: rootView.myPageFeedView.myPageFeedDetailButton.rx.tap,
            editProfileNotification: NotificationCenter.default.rx.notification(NSNotification.Name("EditProfile")).asObservable(),
            feedTableViewItemSelected: rootView.myPageFeedView.myPageFeedTableView.feedTableView.rx.itemSelected.asObservable(),
            feedConnectedNovelViewDidTap: feedConnectedNovelViewDidTap.asObservable())
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.isMyPage
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, isMyPage in
                owner.decideNavigation(myPage: isMyPage, navigationTitle: "")
                owner.rootView.mainStickyHeaderView.buttonLabelText(isMyPage: isMyPage)
                owner.rootView.scrolledStickyHeaderView.buttonLabelText(isMyPage: isMyPage)
            })
            .disposed(by: disposeBag)
        
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
        
        output.pushToSettingViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.pushToSettingViewController()
            })
            .disposed(by: disposeBag)
        
        output.pushToEditViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, data in
                owner.pushToMyPageEditViewController(entryType: .myPage, profile: data)
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
                    owner.rootView.myPageLibraryView.isPrivateUserView(isPrivate: isPrivate, nickname: nickname)
                    owner.rootView.myPageFeedView.isPrivateUserView(isPrivate: isPrivate, nickname: nickname)
                }
            })
            .disposed(by: disposeBag)
        
        output.bindGenreData
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] data in
                self?.rootView.myPageLibraryView.genrePrefrerencesView.bindData(data: data)
            })
            .map { Array($0.genrePreferences.dropFirst(3)) }
            .bind(to: rootView.myPageLibraryView.genrePrefrerencesView.otherGenreView.genreTableView.rx.items(cellIdentifier: MyPageGenrePreferencesOtherTableViewCell.cellIdentifier,cellType: MyPageGenrePreferencesOtherTableViewCell.self)) { row, data, cell in
                cell.bindData(data: data)
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        output.bindAttractivePointsData
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, data in
                owner.rootView.myPageLibraryView.novelPrefrerencesView.bindPreferencesDetailData(data: data)
                
            })
            .disposed(by: disposeBag)
        
        output.isExistPreferneces
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, isExist in
                if !isExist {
                    owner.rootView.myPageLibraryView.updatePreferencesEmptyView(isEmpty: !isExist)
                }
            })
            .disposed(by: disposeBag)
        
        output.bindKeywordCell
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.myPageLibraryView.novelPrefrerencesView.preferencesCollectionView.rx.items(cellIdentifier: MyPageNovelPreferencesCollectionViewCell.cellIdentifier, cellType: MyPageNovelPreferencesCollectionViewCell.self)){ row, data, cell in
                cell.bindData(data: data)
            }
            .disposed(by: disposeBag)
        
        output.bindInventoryData
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, data in
                owner.rootView.myPageLibraryView.inventoryView.bindData(data: data)
            })
            .disposed(by: disposeBag)
        
        output.showGenreOtherView
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, show in
                owner.rootView.myPageLibraryView.genrePrefrerencesView.updateView(showOtherGenreView: show)
                owner.rootView.myPageLibraryView.updateGenreViewHeight(isExpanded: show)
                owner.rootView.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        output.stickyHeaderAction
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, library in
                owner.rootView.mainStickyHeaderView.updateSelection(isLibrarySelected: library)
                owner.rootView.scrolledStickyHeaderView.updateSelection(isLibrarySelected: library)
                
                owner.rootView.myPageLibraryView.isHidden = !library
                owner.rootView.myPageFeedView.isHidden = library
                
                owner.rootView.contentView.snp.remakeConstraints {
                    $0.edges.equalToSuperview()
                    $0.width.equalToSuperview()
                    
                    if library {
                        $0.bottom.equalTo(owner.rootView.myPageLibraryView.snp.bottom)
                    } else {
                        $0.bottom.equalTo(owner.rootView.myPageFeedView.snp.bottom)
                    }
                }
                
                owner.rootView.layoutIfNeeded()
                
            })
            .disposed(by: disposeBag)
        
        output.bindFeedData
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.myPageFeedView.myPageFeedTableView.feedTableView.rx.items(
                cellIdentifier: FeedListTableViewCell.cellIdentifier,
                cellType: FeedListTableViewCell.self)) { _, element, cell in
                    cell.bindProfileData(feed: element)
                }
                .disposed(by: disposeBag)
        
        output.isEmptyFeed
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, isEmpty in
                owner.rootView.myPageFeedView.isEmptyView(isEmpty: isEmpty)
            })
            .disposed(by: disposeBag)
        
        output.showFeedDetailButton
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, show in
                owner.rootView.myPageFeedView.showMoreButton(isShow: show)
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
            .bind(with: self, onNext: { owner, userData in
                let (id, pageIndex) = userData
                owner.pushToLibraryViewController(userId: id, pageIndex: pageIndex)
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
                owner.rootView.myPageFeedView.myPageFeedTableView.updateTableViewHeight(height: height)
            })
            .disposed(by: disposeBag)
        
        output.updateKeywordCollectionViewHeight
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, height in
                owner.rootView.myPageLibraryView.novelPrefrerencesView.updateKeywordViewHeight(height: height)
            })
            .disposed(by: disposeBag)
        
        output.pushToMyPageFeedDetailViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, userData in
                let (id, data) = userData
                owner.pushToMyPageFeedDetailViewController(userId: id, useData: data)
            })
            .disposed(by: disposeBag)
        
        output.showToastView
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.showToast(.editUserProfile)
            })
            .disposed(by: disposeBag)
        
        output.pushToNovelDetailViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, novelId in
                owner.pushToDetailViewController(novelId: novelId)
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

extension MyPageViewController: UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITableViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let keywords = try? viewModel.bindKeywordRelay.value,
              indexPath.row < keywords.count else {
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

extension MyPageViewController {
    
    //MARK: - UI
    
    private func decideNavigation(myPage: Bool, navigationTitle: String) {
        if myPage {
            setWSSNavigationBar(title: navigationTitle,
                                left: nil,
                                right: rootView.settingButton,
                                isVisibleBeforeScroll: false)
        } else {
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
            
            setWSSNavigationBar(title: navigationTitle,
                                left: rootView.backButton,
                                right: dropdownButton,
                                isVisibleBeforeScroll: false)
        }
        
        rootView.headerView.userImageChangeButton.isHidden = !myPage
    }
}

extension MyPageViewController: FeedTableViewDelegate {
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

