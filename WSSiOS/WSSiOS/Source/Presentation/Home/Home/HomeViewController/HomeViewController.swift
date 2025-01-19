//
//  HomeViewController.swift
//  WSSiOS
//
//  Created by 최서연 on 1/9/24.
//

import UIKit

import RxSwift
import RxCocoa
import Lottie

final class HomeViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    
    private let isLoggedIn = APIConstants.isLogined
    private let viewWillAppearEvent = PublishRelay<Void>()
    private let viewDidLoadEvent = PublishRelay<Void>()
    
    //MARK: - UI Components
    
    private let rootView: HomeView
    
    //MARK: - Life Cycle
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.rootView = HomeView(frame: .zero)
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
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        showTabBar()
        viewWillAppearEvent.accept(())
        
        AmplitudeManager.shared.track(AmplitudeEvent.Home.home)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        registerCell()
        setDelegate()
        bindViewModel()
        setRemoteNotification()
        
        viewDidLoadEvent.accept(())
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.view.backgroundColor = .wssWhite
    }
    
    //MARK: - Bind
    
    private func registerCell() {
        rootView.todayPopularView.todayPopularCollectionView.register(
            HomeTodayPopularCollectionViewCell.self,
            forCellWithReuseIdentifier: HomeTodayPopularCollectionViewCell.cellIdentifier)
        
        rootView.realtimePopularView.realtimePopularCollectionView.register(
            HomeRealtimePopularCollectionViewCell.self,
            forCellWithReuseIdentifier: HomeRealtimePopularCollectionViewCell.cellIdentifier)
        
        rootView.interestView.interestCollectionView.register(
            HomeInterestCollectionViewCell.self,
            forCellWithReuseIdentifier: HomeInterestCollectionViewCell.cellIdentifier)
        
        rootView.tasteRecommendView.tasteRecommendCollectionView.register(
            HomeTasteRecommendCollectionViewCell.self,
            forCellWithReuseIdentifier: HomeTasteRecommendCollectionViewCell.cellIdentifier)
    }
    
    private func setDelegate() {
        rootView.realtimePopularView.realtimePopularCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = HomeViewModel.Input(
            viewWillAppearEvent: viewWillAppearEvent.asObservable(),
            viewDidLoadEvent: viewDidLoadEvent.asObservable(),
            todayPopularCellSelected: rootView.todayPopularView.todayPopularCollectionView.rx.itemSelected,
            interestCellSelected: rootView.interestView.interestCollectionView.rx.itemSelected,
            tasteRecommendCellSelected: rootView.tasteRecommendView.tasteRecommendCollectionView.rx.itemSelected,
            tasteRecommendCollectionViewContentSize: rootView.tasteRecommendView.tasteRecommendCollectionView.rx.observe(CGSize.self, "contentSize"),
            announcementButtonDidTap: rootView.headerView.announcementButton.rx.tap,
            registerInterestNovelButtonTapped: rootView.interestView.unregisterView.registerButton.rx.tap,
            setPreferredGenresButtonTapped: rootView.tasteRecommendView.unregisterView.registerButton.rx.tap
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        // 오늘의 인기작
        output.todayPopularList
            .bind(to: rootView.todayPopularView.todayPopularCollectionView.rx.items(
                cellIdentifier: HomeTodayPopularCollectionViewCell.cellIdentifier,
                cellType: HomeTodayPopularCollectionViewCell.self)) { row, element, cell in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        // 지금 뜨는 수다글
        output.realtimePopularData
            .bind(to: rootView.realtimePopularView.realtimePopularCollectionView.rx.items(
                cellIdentifier: HomeRealtimePopularCollectionViewCell.cellIdentifier,
                cellType: HomeRealtimePopularCollectionViewCell.self)) { row, element, cell in
                    cell.bindData(data: element)
                    cell.onFeedViewTapped = { feedId in
                        if self.isLoggedIn {
                            if let intFeedId = Int(feedId) {
                                self.pushToFeedDetailViewController(feedId: intFeedId)
                            } else {
                                print("Invalid feedId: \(feedId)")
                            }
                        } else {
                            self.viewModel.showInduceLoginModalView.accept(())
                        }
                    }
                }
                .disposed(by: disposeBag)
        
        output.realtimePopularData
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, realtimePopularItems in
                owner.rootView.realtimePopularView.configureDots(numberOfItems: realtimePopularItems.count)
            })
            .disposed(by: disposeBag)
        
        // 관심글
        output.interestList
            .bind(to: rootView.interestView.interestCollectionView.rx.items(
                cellIdentifier: HomeInterestCollectionViewCell.cellIdentifier,
                cellType: HomeInterestCollectionViewCell.self)) { row, element, cell in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        output.updateInterestView
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in
                let isLogined = data.0
                let message = data.1
                let nickname = UserDefaults.standard.string(forKey: StringLiterals.UserDefault.userNickname)
                owner.rootView.interestView.updateView(isLogined, message, nickname)
            })
            .disposed(by: disposeBag)
        
        output.pushToNormalSearchViewController
            .bind(with: self, onNext: { owner, _ in
                owner.pushToNormalSearchViewController()
            })
            .disposed(by: disposeBag)
        
        // 취향 추천
        output.tasteRecommendList
            .bind(to: rootView.tasteRecommendView.tasteRecommendCollectionView.rx.items(
                cellIdentifier: HomeTasteRecommendCollectionViewCell.cellIdentifier,
                cellType: HomeTasteRecommendCollectionViewCell.self)) { row, element, cell in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        output.tasteRecommendCollectionViewHeight
            .drive(with: self, onNext: { owner, height in
                owner.rootView.tasteRecommendView.updateCollectionViewHeight(height: height)
            })
            .disposed(by: disposeBag)
        
        output.updateTasteRecommendView
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, updateData in
                let (isLogined, isEmpty) = updateData
                owner.rootView.tasteRecommendView.updateView(isLogined, isEmpty)
            })
            .disposed(by: disposeBag)
        
        output.pushToMyPageEditViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.pushToMyPageEditViewController(entryType: .home, profile: nil)
            })
            .disposed(by: disposeBag)
        
        output.pushToNovelDetailViewController
            .bind(with: self, onNext: { owner, novelId in
                owner.pushToDetailViewController(novelId: novelId)
            })
            .disposed(by: disposeBag)
        
        output.pushToAnnouncementViewController
            .bind(with: self, onNext: { owner, _ in
                let viewController = HomeNoticeViewController(viewModel: HomeNoticeViewModel(noticeRepository: DefaultNoticeRepository(noticeService: DefaultNoticeService() )))
                viewController.navigationController?.isNavigationBarHidden = false
                viewController.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showInduceLoginModalView
            .bind(with: self, onNext: { owner, _ in
                owner.presentInduceLoginViewController()
            })
            .disposed(by: disposeBag)
        
        output.showLoadingView
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, isShow in
                owner.rootView.showLoadingView(isShow: isShow)
            })
            .disposed(by: disposeBag)
        
        output.showUpdateVersionAlertView
            .observe(on: MainScheduler.instance)
            .flatMapLatest { _ -> Observable<AlertButtonType> in
                return self.presentToAlertViewController(iconImage: .icModalWarning,
                                                         titleText: StringLiterals.AppMinimumVersion.title,
                                                         contentText: StringLiterals.AppMinimumVersion.content,
                                                         leftTitle: nil,
                                                         rightTitle: StringLiterals.AppMinimumVersion.buttonTitle,
                                                         rightBackgroundColor: UIColor.wssPrimary100.cgColor,
                                                         isDismissable: false)
            }
            .subscribe(with: self, onNext: { owner, buttonType in
                guard let url = URL(string: StringLiterals.AppMinimumVersion.appStoreURL) else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            })
            .disposed(by: disposeBag)
        
        //취향장르 정보 수정 Notification
        NotificationCenter.default.rx.notification(NSNotification.Name("EditProfile"))
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.showToast(.editUserProfile)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Custom Method
    
    func scrollToTop() {
        self.rootView.scrollView.setContentOffset(CGPoint(x: 0, y: -self.rootView.scrollView.contentInset.top), animated: true)
    }
    
    func setRemoteNotification() {
        Task {
            await NotificationHelper.shared.setRemoteNotification()
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == rootView.realtimePopularView.realtimePopularCollectionView {
            let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
            let cellWidth: CGFloat = UIScreen.main.bounds.width - 40
            let index = round(scrolledOffsetX / cellWidth)
            targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == rootView.realtimePopularView.realtimePopularCollectionView {
            let pageWidth = scrollView.frame.width
            let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            rootView.realtimePopularView.updateDots(currentPage: currentPage)
        }
    }
}

