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

final class LibraryViewController: UIViewController {
    
    //MARK: - Properties
    
    private let libraryViewModel: LibraryViewModel
    
    private let disposeBag = DisposeBag()
    private let sortTypeList = StringLiterals.Alignment.self
    
    private let readStatusList = StringLiterals.ReadStatus.allCases.map { $0.rawValue }
    private var currentPageIndex = 0
    
    //MARK: - UI Components
    
    private let rootView = LibraryView()
    private let libraryPageViewController = UIPageViewController(transitionStyle: .scroll,
                                                                 navigationOrientation: .horizontal,
                                                                 options: nil)
    
    
    // MARK: - Life Cycle
    
    init(libraryViewModel: LibraryViewModel) {
        self.libraryViewModel = libraryViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPages()
        
        delegate()
        register()
        bindViewModel()
        
        addNotificationCenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showTabBar()
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.library,
                                    left: nil,
                                    right: nil)
    }
    
    //MARK: - Bind
    
    private func register() {
        rootView.libraryPageBar.libraryTabCollectionView
            .register(LibraryTabCollectionViewCell.self,
                      forCellWithReuseIdentifier: "LibraryTabCollectionViewCell")
    }
    
    private func delegate() {
        libraryPageViewController.delegate = self
        libraryPageViewController.dataSource = self
    }
    
    private func bindViewModel() {
        let input = LibraryViewModel.Input(
            tabBarDidTap: rootView.libraryPageBar.libraryTabCollectionView.rx.itemSelected,
            listButtonDidTap: rootView.libraryDescriptionView.libraryNovelListButton.rx.tap,
            newestButtonDidTap: rootView.libraryListView.libraryNewestButton.rx.tap,
            oldestButtonDidTap: rootView.libraryListView.libraryOldestButton.rx.tap
        )
        
        let output = libraryViewModel.transform(from: input, disposeBag: disposeBag)
        
        output.bindCell
            .bind(to: rootView.libraryPageBar.libraryTabCollectionView.rx.items(
                cellIdentifier: "LibraryTabCollectionViewCell",
                cellType: LibraryTabCollectionViewCell.self)) { (row, element, cell) in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        output.moveToTappedTabBar
            .subscribe(with: self, onNext: { owner, index in
                let direction: UIPageViewController.NavigationDirection = index > (owner.libraryPageViewController.viewControllers?.first?.view.tag ?? 0) ? .forward : .reverse
                owner.libraryPageViewController.setViewControllers([owner.rootView.libraryPages[index]],
                                                                   direction: direction,
                                                                   animated: true,
                                                                   completion: nil)
            })
            .disposed(by: disposeBag)
        
        output.showListView
            .bind(with: self, onNext: { owner, isShown in
                owner.rootView.libraryListView.isHidden = isShown
            })
            .disposed(by: disposeBag)
        
        output.changeListType
            .bind(with: self, onNext: { owner, listType in
                owner.rootView.resetUI(title: listType.title)
            })
            .disposed(by: disposeBag)
        
        output.updateChildViewController
            .bind(with: self, onNext: { owner, sortType in
                let viewController = owner.rootView.libraryPages[owner.currentPageIndex]
                viewController.updateNovelList(readStatus: owner.readStatusList[owner.currentPageIndex],
                                               lastUserNovelId: sortType.lastId,
                                               size: sortType.sizeData,
                                               sortType: sortType.sortType)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func setupPages() {
        self.addChild(libraryPageViewController)
        self.view.addSubviews(libraryPageViewController.view)
        libraryPageViewController.didMove(toParent: self)
        
        for i in 0..<readStatusList.count {
            let sortTypeList = sortTypeList.newest
            let viewController = LibraryChildViewController(
                userNovelListRepository: DefaultUserNovelRepository(
                    userNovelService: DefaultUserNovelService()),
                readStatus: readStatusList[i],
                lastUserNovelId: sortTypeList.lastId,
                size: sortTypeList.sizeData,
                sortType: sortTypeList.sortType)
            
            viewController.delegate = self
            rootView.libraryPages.append(viewController)
        }
        
        for (index, viewController) in rootView.libraryPages.enumerated() {
            viewController.view.tag = index
        }
        
        libraryPageViewController.setViewControllers([rootView.libraryPages[0]],
                                                     direction: .forward,
                                                     animated: false,
                                                     completion: nil)
    }
}

//MARK: - Set PageController

extension LibraryViewController : UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) { 
        if completed, let currentViewController = pageViewController.viewControllers?.first, let index = rootView.libraryPages.firstIndex(of: currentViewController as! LibraryChildViewController) {
            rootView.libraryPageBar.libraryTabCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            currentPageIndex = index
        }
    }
}

extension LibraryViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentIndex = rootView.libraryPages.firstIndex(of: viewController as! LibraryChildViewController), currentIndex > 0 {
            return rootView.libraryPages[currentIndex - 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentIndex = rootView.libraryPages.firstIndex(of: viewController as! LibraryChildViewController), currentIndex < rootView.libraryPages.count - 1 {
            return rootView.libraryPages[currentIndex + 1]
        }
        return nil
    }
}

extension LibraryViewController: NovelDelegate {
    func sendData(data: Int) {
        rootView.libraryDescriptionView.libraryNovelCountLabel.text = "\(data)개"
    }
}

extension LibraryViewController {
    
    //MARK: - Notification
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.showNovelInfo(_:)),
            name: NSNotification.Name("ShowNovelInfo"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.showNovelMemo(_:)),
            name: NSNotification.Name("ShowNovelMemo"),
            object: nil
        )
    }
    
    @objc
    func showNovelInfo(_ notification: Notification) {
        guard let userNovelId = notification.object as? Int else { return }
        self.moveToNovelDetailViewController(userNovelId: userNovelId)
    }
    
    @objc
    func showNovelMemo(_ notification: Notification) {
        guard let userNovelId = notification.object as? Int else { return }
        self.moveToNovelDetailViewController(userNovelId: userNovelId)
    }
}


