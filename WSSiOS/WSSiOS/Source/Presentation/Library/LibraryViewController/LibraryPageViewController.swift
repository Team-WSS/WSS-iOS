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
    private var libraryPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private var libraryPageBar = LibraryPageBar()
    private var libraryPages = [LibraryBaseViewController]()
    private var initialPage = 0
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
        bindDataToLibraryCollectionView()
        
        setupPage()
        delegate()
        
        setHierarchy()
        setLayout()
    }
    
    //MARK: - Custom TabBar
    
    private func register() {
        libraryPageBar.libraryTabCollectionView
            .register(LibraryTabCollectionViewCell.self,
                      forCellWithReuseIdentifier: "LibraryTabCollectionViewCell")
    }
    
    private func bindDataToLibraryCollectionView() {
        dummyLibraryTabTitle.bind(to: libraryPageBar.libraryTabCollectionView.rx.items(
            cellIdentifier: "LibraryTabCollectionViewCell",
            cellType: LibraryTabCollectionViewCell.self)) { (row, element, cell) in
                cell.libraryTabButton.setTitle(element, for: .normal)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupPage() {
        self.view.backgroundColor = .White
        
        for i in 0...4 {
            libraryPages.append(LibraryBaseViewController())
        }
        
        libraryPageViewController.setViewControllers([libraryPages[0]], direction: .forward, animated: false, completion: nil)
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
}

extension LibraryPageViewController : UIPageViewControllerDelegate {
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        guard completed else { return }
//        if let viewController = pageViewController.viewControllers?.first {
//
//        }
//    }
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


