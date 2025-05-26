//
//  FeedViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 5/14/24.
//

import UIKit

import RxSwift
import RxRelay
import SnapKit
import Then

final class FeedViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let selectedTab = BehaviorRelay<FeedTab>(value: .my)
    private let selectedSosoFeedTab = BehaviorRelay<SosoFeedTab>(value: .all)
    private let selectedPageIndex = BehaviorRelay<Int>(value: 0)
    
    //MARK: - Components
    
    private let feedHeaderView = FeedHeaderView()
    private let sosoFeedHeaderView = SosoFeedHeaderView()
    private let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                          navigationOrientation: .horizontal,
                                                          options: nil)
    private lazy var pages = [FeedGenreViewController]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        
        delegate()
        
        setupPageViewController()
        
        bindAction()
        bindOutput()
        
        AmplitudeManager.shared.track(AmplitudeEvent.Feed.feedAll)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - Bind
    
    private func delegate() {
        pageViewController.delegate = self
        pageViewController.dataSource = self
    }
    
    private func bindOutput() {
        selectedTab.asDriver()
            .drive(with: self, onNext: { owner, selectedTab in
                owner.feedHeaderView.updateButtons(selectedTab: selectedTab)
                owner.setSosoFeedHeaderViewHidden(isHidden: selectedTab == .my)
            })
            .disposed(by: disposeBag)
        
        selectedSosoFeedTab.asDriver()
            .drive(with: self, onNext: { owner, selectedTab in
                owner.sosoFeedHeaderView.updateButtons(selectedTab: selectedTab)
            })
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(selectedTab, selectedSosoFeedTab)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in
                let (sosoTab, feedTab) = data
            
                switch data {
                case (.my, _ ): owner.selectedPageIndex.accept(0)
                case (.soso, .all): owner.selectedPageIndex.accept(1)
                case (.soso, .recommended): owner.selectedPageIndex.accept(2)
                }
            })
            .disposed(by: disposeBag)
        
        selectedPageIndex.asDriver()
            .drive(with: self, onNext: { owner, index in
                owner.pageViewController.setViewControllers(
                    [owner.pages[index]],
                    direction: .forward,
                    animated: false,
                    completion: nil
                )
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAction() {
        [feedHeaderView.myFeedTabButton, feedHeaderView.sosoFeedTabButton].forEach { button in
            button.rx.tap
                .map { button.tab }
                .bind(to: selectedTab)
                .disposed(by: disposeBag)
        }
        
        sosoFeedHeaderView.allTabButton.rx.tap
            .map { SosoFeedTab.all }
            .bind(to: selectedSosoFeedTab)
            .disposed(by: disposeBag)
        
        sosoFeedHeaderView.recommendedTabButton.rx.tap
            .map { SosoFeedTab.recommended }
            .bind(to: selectedSosoFeedTab)
            .disposed(by: disposeBag)
        
        feedHeaderView.createFeedButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                AmplitudeManager.shared.track(AmplitudeEvent.Feed.feedWriteFloatingButton)
                owner.pushToFeedEditViewController()
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name("FeedEdited"))
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.showToast(.feedEdited)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name("BlockUser"))
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, notification in
                guard let nickname = notification.object as? String else { return }
                owner.showToast(.blockUser(nickname: nickname))
            })
            .disposed(by: disposeBag)
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func scrollToTop() {
        guard let pageViewController = self.children.first as? UIPageViewController,
              let currentVC = pageViewController.viewControllers?.first else { return }
        
        if let scrollView = currentVC.view.subviews.compactMap({ $0 as? UIScrollView }).first {
            scrollView.setContentOffset(CGPoint(x: 0, y: -scrollView.contentInset.top), animated: true)
        }
    }
}

extension FeedViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentIndex = pages.firstIndex(of: viewController as! FeedGenreViewController),
           currentIndex > 0 { return pages[currentIndex - 1] }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentIndex = pages.firstIndex(of: viewController as! FeedGenreViewController),
           currentIndex < pages.count - 1 { return pages[currentIndex + 1] }
        return nil
    }
}

// MARK: - UI

extension FeedViewController {
    
    private func setUI() {
        self.view.backgroundColor = .wssWhite
    }
    
    private func setHierarchy() {
        self.view.addSubviews(feedHeaderView,
                              sosoFeedHeaderView)
        self.addChild(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    private func setLayout() {
        feedHeaderView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
        }
        
        sosoFeedHeaderView.snp.makeConstraints {
            $0.top.equalTo(feedHeaderView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(sosoFeedHeaderView.snp.bottom)
            $0.width.bottom.equalToSuperview()
        }
    }
    
    private func setupPageViewController() {
        [(FeedTab.my, nil), (FeedTab.soso, SosoFeedTab.all), (FeedTab.soso, SosoFeedTab.recommended)].forEach { tab, sosoTab in
            let viewController = FeedGenreViewController(
                viewModel: FeedGenreViewModel(
                    feedRepository: DefaultFeedRepository(
                        feedService: DefaultFeedService()
                    ),
                    feedDetailRepository: DefaultFeedDetailRepository(
                        feedDetailService: DefaultFeedDetailService()
                    ),
                    category: NewNovelGenre.fantasy.rawValue
                ),
                feedTab: tab,
                sosoFeedTab: sosoTab)
            pages.append(viewController)
        }
        
        // UIPageViewController 스크롤로 VC 전환되는 것 막기.
        let scrollView =  pageViewController.view.subviews.first { $0 is UIScrollView } as? UIScrollView
        scrollView?.isScrollEnabled = false
        
        pageViewController.setViewControllers([pages[0]],
                                              direction: .forward,
                                              animated: false,
                                              completion: nil)
    }
    
    //MARK: - Custom Method
    
    private func setSosoFeedHeaderViewHidden(isHidden: Bool) {
        if isHidden {
            sosoFeedHeaderView.isHidden = true
            
            pageViewController.view.snp.remakeConstraints {
                $0.top.equalTo(feedHeaderView.snp.bottom)
                $0.width.bottom.equalToSuperview()
            }
        } else {
            sosoFeedHeaderView.isHidden = false
            
            pageViewController.view.snp.remakeConstraints {
                $0.top.equalTo(sosoFeedHeaderView.snp.bottom)
                $0.width.bottom.equalToSuperview()
            }
        }
    }
}
