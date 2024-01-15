//
//  LibraryPageViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/14/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class LibraryPageViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private var libraryPageViewController = UIPageViewController(transitionStyle: .scroll,
                                                                 navigationOrientation: .horizontal,
                                                                 options: nil)
    private var libraryPageBar = LibraryPageBar()
    private var libraryPages = [LibraryBaseViewController]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
        delegate()
        
        setupPage()
        
        setHierarchy()
        setLayout()
        setAction()
    }
    
    //MARK: - Custom TabBar
    
    private func setTabBar() {
        libraryPageBar.libraryTabCollectionView
            .register(LibraryTabCollectionViewCell.self,
                      forCellWithReuseIdentifier: "LibraryTabCollectionViewCell")
        
        dummyLibraryTabTitle.bind(to: libraryPageBar.libraryTabCollectionView.rx.items(
            cellIdentifier: "LibraryTabCollectionViewCell",
            cellType: LibraryTabCollectionViewCell.self)) { (row, element, cell) in
                cell.libraryTabButton.setTitle(element, for: .normal)
                cell.libraryTabButton.rx.tap
                    .map { row }
                    .bind(to: self.libraryPageBar.selectedTabIndex)
                    .disposed(by: cell.disposeBag)
                }
            .disposed(by: disposeBag)
        
        Observable.just(Void())
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] in
                    self?.libraryPageBar.libraryTabCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: [])
                    self?.libraryPageBar.selectedTabIndex.onNext(0)
                })
                .disposed(by: disposeBag)
    }
    
    private func setupPage() {
        self.view.backgroundColor = .White
        
        for i in 0...4 {
            libraryPages.append(LibraryBaseViewController())
        }
        
        for (index, viewController) in libraryPages.enumerated() {
            viewController.view.tag = index
        }
        
        libraryPageViewController.setViewControllers([libraryPages[0]],
                                                     direction: .forward,
                                                     animated: false,
                                                     completion: nil)
    }
    
    private func delegate() {
        libraryPageViewController.delegate = self
        libraryPageViewController.dataSource = self
    }
    
    private func setHierarchy() {
        self.view.addSubview(libraryPageBar)
        self.addChild(libraryPageViewController)
        self.view.addSubviews(libraryPageViewController.view)
        libraryPageViewController.didMove(toParent: self)
    }
    
    private func setLayout() {
        libraryPageBar.snp.makeConstraints() {
            $0.top.width.equalToSuperview()
            $0.height.equalTo(107)
        }
        
        libraryPageViewController.view.snp.makeConstraints {
            $0.top.equalTo(libraryPageBar.snp.bottom)
            $0.width.bottom.equalToSuperview()
        }
    }
    
    private func setAction() {
        libraryPageBar.selectedTabIndex
            .subscribe(onNext: { [weak self] index in
                guard let self = self, self.libraryPages.indices.contains(index) else { return }
                let direction: UIPageViewController.NavigationDirection = index > (self.libraryPageViewController.viewControllers?.first?.view.tag ?? 0) ? .forward : .reverse
                self.libraryPageViewController.setViewControllers([self.libraryPages[index]],
                                                                  direction: direction,
                                                                  animated: true,
                                                                  completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

extension LibraryPageViewController : UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) { 
        if completed, let currentViewController = pageViewController.viewControllers?.first, let index = libraryPages.firstIndex(of: currentViewController as! LibraryBaseViewController) {
            libraryPageBar.libraryTabCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }
    }
}

extension LibraryPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentIndex = libraryPages.firstIndex(of: viewController as! LibraryBaseViewController), currentIndex > 0 {
            return libraryPages[currentIndex - 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentIndex = libraryPages.firstIndex(of: viewController as! LibraryBaseViewController), currentIndex < libraryPages.count - 1 {
            return libraryPages[currentIndex + 1]
        }
        return nil
    }
}


