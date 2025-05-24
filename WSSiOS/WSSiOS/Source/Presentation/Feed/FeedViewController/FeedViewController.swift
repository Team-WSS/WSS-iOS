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
    private var categoryList = BehaviorRelay<[NewNovelGenre]>(value: [])
    
    //MARK: - Components
    
    private let navigationBar = FeedNavigationView()
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
        
        AmplitudeManager.shared.track(AmplitudeEvent.Feed.feedAll)
    }
    
    //MARK: - Bind
    
    
    private func delegate() {
        pageViewController.delegate = self
        pageViewController.dataSource = self
    }
    
    private func setupPageViewController() {
        for pageIndex in 0..<3 {
            let viewController = FeedGenreViewController(
                viewModel: FeedGenreViewModel(
                    feedRepository: DefaultFeedRepository(
                        feedService: DefaultFeedService()
                    ),
                    feedDetailRepository: DefaultFeedDetailRepository(
                        feedDetailService: DefaultFeedDetailService()
                    ),
                    category: NewNovelGenre.fantasy.rawValue
                )
            )
            
            pages.append(viewController)
        }
        
        for (index, viewController) in pages.enumerated() {
            viewController.view.tag = index
        }
        
        pageViewController.setViewControllers([pages[0]],
                                              direction: .forward,
                                              animated: false,
                                              completion: nil)
    }
    
    private func bindAction() {
        navigationBar.createFeedButton.rx.tap
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

extension FeedViewController : UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
           let currentViewController = pageViewController.viewControllers?.first,
           let index = pages.firstIndex(of: currentViewController as! FeedGenreViewController) {
//            pageBar.feedPageBarCollectionView
//                .selectItem(at: IndexPath(item: index, section: 0),
//                            animated: true,
//                            scrollPosition: .centeredHorizontally)
        }
    }
}

extension FeedViewController: UIPageViewControllerDataSource {
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
        self.view.addSubviews(navigationBar)
        self.addChild(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    private func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.width.bottom.equalToSuperview()
        }
    }
}
