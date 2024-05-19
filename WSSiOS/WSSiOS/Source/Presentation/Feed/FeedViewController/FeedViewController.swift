//
//  FeedViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 5/14/24.
//

import UIKit

import RxSwift
import RxRelay

final class FeedViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let dummyTitle = dummyFeedPageBarTitle
    private lazy var selectedTabIndex = PublishSubject<Int>()
    
    //MARK: - Components
    
    private let navigationBar = FeedNavigationView()
    private let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                          navigationOrientation: .horizontal,
                                                          options: nil)
    private let pageBar = FeedPageBar()
    private lazy var pages = [FeedGenreViewController]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        
        register()
        delegate()
        setupPages()
        bindColletionView()
        
        setAction()
    }
    
    //MARK: - Bind
    
    private func register() {
        pageBar.feedPageBarCollectionView.register(FeedPageBarCollectionViewCell.self,
                                                   forCellWithReuseIdentifier: FeedPageBarCollectionViewCell.cellIdentifier)
    }
    
    private func delegate() {
        pageViewController.delegate = self
        pageViewController.dataSource = self
    }
    
    private func bindColletionView() {
        Observable.just(dummyTitle)
            .bind(to: pageBar.feedPageBarCollectionView.rx.items(
                cellIdentifier: FeedPageBarCollectionViewCell.cellIdentifier,
                cellType: FeedPageBarCollectionViewCell.self)) { (row, element, cell) in
                    cell.bindData(text: element)
                }
                .disposed(by: disposeBag)
        
        pageBar.feedPageBarCollectionView.rx
            .setDelegate(self).disposed(by: disposeBag)
        
        pageBar.feedPageBarCollectionView
            .selectItem(at: IndexPath(item: 0, section: 0),
                        animated: true,
                        scrollPosition: [])
    }
    
    private func setupPages() {
        for _ in 0..<dummyTitle.count {
            let viewController = FeedGenreViewController(
                viewModel: FeedViewModel(
                    feedRepository: DefaultFeedRepository(
                        feedService: DefaultFeedService()
                    )
                ), feedsDummy: dummyFeedData)
            
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
    
    //TODO: - 추후 ViewModel 로 뺄 예정
    
    private func setAction() {
        pageBar.feedPageBarCollectionView.rx.itemSelected
            .map{$0.row}
            .bind(to: selectedTabIndex)
            .disposed(by: disposeBag)
        
        selectedTabIndex
            .subscribe(with: self, onNext: { owner, index in 
                owner.pageBar.feedPageBarCollectionView.scrollToItem(
                    at: IndexPath(item: index, section: 0),
                    at: .centeredHorizontally,
                    animated: true
                )
                
                let direction: UIPageViewController.NavigationDirection = index > (owner.pageViewController.viewControllers?.first?.view.tag ?? 0) ? .forward : .reverse
                owner.pageViewController.setViewControllers([owner.pages[index]],
                                                            direction: direction,
                                                            animated: true,
                                                            completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case pageBar.feedPageBarCollectionView:
            guard let pageTitle = try? dummyTitle, indexPath.item < pageTitle.count else {
                return CGSize(width: 0, height: 0)
            }
            
            let text = pageTitle[indexPath.row]
            let height: CGFloat = 41
            
            let pageTitleLabel = UILabel()
            pageTitleLabel.text = text
            pageTitleLabel.font = .Title3
            
            let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
            let requiredSize = pageTitleLabel.sizeThatFits(maxSize)
            let finalWidth = max(requiredSize.width + 24, 24)
            
            return CGSize(width: finalWidth, height: height)
            
        default:
            return CGSize()
        }
    }
}

extension FeedViewController : UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) { 
        if completed,
           let currentViewController = pageViewController.viewControllers?.first,
           let index = pages.firstIndex(of: currentViewController as! FeedGenreViewController) {
            pageBar.feedPageBarCollectionView
                .selectItem(at: IndexPath(item: index, section: 0),
                            animated: true,
                            scrollPosition: .centeredHorizontally)
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

extension FeedViewController {
    
    // MARK: - UI
    
    private func setUI() {
        self.view.backgroundColor = .wssWhite
    }
    
    private func setHierarchy() {
        self.view.addSubviews(navigationBar,
                              pageBar)
        self.addChild(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    private func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(52)
        }
        
        pageBar.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(41)
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(pageBar.snp.bottom).offset(18)
            $0.width.bottom.equalToSuperview()
        }
    }
}
