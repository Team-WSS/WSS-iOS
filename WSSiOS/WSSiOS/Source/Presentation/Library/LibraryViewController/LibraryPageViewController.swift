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
    
    private var tabBarDummyText = ["전체", "읽음", "읽는 중", "하차", "읽고 싶음"]
    
    
    //MARK: - UI Components
    var libraryPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private var libraryPages = [LibraryBaseViewController]()
    private var initialPage = 0
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPage()
        delegate()
        setHierarchy()
        setLayout()
    }
    
    //MARK: - Custom TabBar
    
    private func setupPage() {
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
        self.addChild(libraryPageViewController)
        self.view.addSubview(libraryPageViewController.view)
        libraryPageViewController.didMove(toParent: self)
    }
    
    private func setLayout() {
        libraryPageViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func initializePageViewController(with index: Int) {
        let currentVC = libraryPages[index]
        libraryPageViewController.setViewControllers([currentVC], direction: .forward, animated: false, completion: nil)
    }
}

extension LibraryPageViewController : UIPageViewControllerDelegate {
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        guard completed else { return }
//        if let viewController = pageViewController.viewControllers?.first {
//            detailBottomBar.detailPageController.currentPage = VCList.firstIndex(of: viewController as! DetailViewController) ?? 0
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


