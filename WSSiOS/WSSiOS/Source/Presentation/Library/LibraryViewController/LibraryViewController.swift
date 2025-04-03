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
    
    var pageIndex: Int = 0
    private let userId: Int
    private let disposeBag = DisposeBag()
    private let sortTypeList = StringLiterals.Alignment.self
    private let readStatusList = StringLiterals.LibraryReadStatus.allCases.map { $0.rawValue }
    private let tabBarList = StringLiterals.ReviewerStatus.allCases.map { $0.rawValue }
    private let sendNovelTotalCount = BehaviorRelay<Int>(value: 0)
    
    //MARK: - UI Components
    
    private let libraryNavigationView = LibraryNavigationView()
    private let libraryPageBar = LibraryPageBar()
    private var libraryPages = [LibraryChildViewController]()
    private let libraryPageViewController = UIPageViewController(transitionStyle: .scroll,
                                                                 navigationOrientation: .horizontal,
                                                                 options: nil)
    
    // MARK: - Life Cycle
    
    init(userId: Int) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        
        delegate()
        register()
        
        setupPageBar()
        setupPageViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - Bind
    
    private func register() {
        libraryPageBar.libraryTabCollectionView
            .register(LibraryTabCollectionViewCell.self, forCellWithReuseIdentifier: LibraryTabCollectionViewCell.cellIdentifier)
    }
    
    private func delegate() {
        libraryPageViewController.delegate = self
        libraryPageViewController.dataSource = self
    }
    
    private func setupPageBar() {
        Observable.just(tabBarList)
            .do(onNext: { [weak self] index in
                guard !index.isEmpty else { return }
                DispatchQueue.main.async {
                    self?.libraryPageBar.libraryTabCollectionView.selectItem(at: IndexPath(item: self?.pageIndex ?? 0, section: 0),
                                                                             animated: true,
                                                                             scrollPosition: [])
                }
            })
            .bind(to: libraryPageBar.libraryTabCollectionView.rx.items(
                cellIdentifier: LibraryTabCollectionViewCell.cellIdentifier,
                cellType: LibraryTabCollectionViewCell.self
            )) { _, element, cell in
                cell.bindData(data: element)
            }
            .disposed(by: disposeBag)
        
        libraryPageBar.libraryTabCollectionView.rx.itemSelected
            .map { $0.row }
            .subscribe(with: self, onNext: { owner, index in
                guard index >= 0, index < owner.libraryPages.count else { return }
                
                let currentTag = owner.libraryPageViewController.viewControllers?.first?.view.tag ?? 0
                let direction: UIPageViewController.NavigationDirection = index > currentTag ? .forward : .reverse
                owner.libraryPageViewController.setViewControllers([owner.libraryPages[index]],
                                                                   direction: direction,
                                                                   animated: true,
                                                                   completion: nil)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name("MoveToLibraryViewController"))
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, notification in
                owner.tabBarController?.selectedIndex = WSSTabBarItem.library.rawValue
                
                if let pageIndex = notification.object as? Int {
                    owner.pageIndex = pageIndex
                    owner.setPageViewControllerToPageIndex()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupPageViewController() {
        addChild(libraryPageViewController)
        view.addSubviews(libraryPageViewController.view)
        libraryPageViewController.didMove(toParent: self)
        
        for readStatus in readStatusList {
            let sortTypeList = sortTypeList.newest
            let sortTypeQuery = UserNovelNovelStatus(
                readStatus: readStatus,
                lastUserNovelId: sortTypeList.lastId,
                size: sortTypeList.sizeData,
                sortType: sortTypeList.sortType
            )
            let viewController = setLibraryChildViewController(userId: userId, data: sortTypeQuery)
            libraryPages.append(viewController)
        }
        
        for (index, viewController) in libraryPages.enumerated() {
            viewController.view.tag = index
        }
        
        guard pageIndex < StringLiterals.ReviewerStatus.allCases.count else { return }
        libraryPageViewController.setViewControllers(
            [libraryPages[pageIndex]],
            direction: .forward,
            animated: false,
            completion: nil
        )
    }
    
    //MARK: - Custom Method
    func setPageViewControllerToPageIndex() {
        libraryPageViewController.setViewControllers(
            [libraryPages[pageIndex]],
            direction: .forward,
            animated: false,
            completion: nil
        )
        libraryPageBar.libraryTabCollectionView.selectItem(at: IndexPath(item: pageIndex, section: 0),
                                                                 animated: true,
                                                                 scrollPosition: [])
    }
}

//MARK: - Set PageController

extension LibraryViewController : UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentViewController = pageViewController.viewControllers?.first, let index = libraryPages.firstIndex(of: currentViewController as! LibraryChildViewController) {
            libraryPageBar.libraryTabCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            pageIndex = index
        }
    }
}

extension LibraryViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = libraryPages.firstIndex(of: viewController as! LibraryChildViewController) else { return nil }
        guard currentIndex > 0 else { return nil }
        
        return libraryPages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentIndex = libraryPages.firstIndex(of: viewController as! LibraryChildViewController), currentIndex < libraryPages.count - 1 {
            return libraryPages[currentIndex + 1]
        }
        return nil
    }
}

extension LibraryViewController {
    private func setLibraryChildViewController(userId: Int, data: UserNovelNovelStatus) -> LibraryChildViewController {
        return LibraryChildViewController(
            libraryViewModel: LibraryChildViewModel(
                userRepository: DefaultUserInfoRepository(
                    userService: DefaultUserService()
                ),
                initData: data,
                userId: userId))
    }
}

//MARK: - UI

extension LibraryViewController {
    
    private func setUI() {
        self.view.backgroundColor = .wssWhite
    }
    
    private func setHierarchy() {
        self.view.addSubviews(libraryNavigationView,
                              libraryPageBar)
        self.addChild(libraryPageViewController)
        self.view.addSubviews(libraryPageViewController.view)
        libraryPageViewController.didMove(toParent: self)
    }
    
    private func setLayout() {
        libraryNavigationView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(52)
        }
        
        libraryPageBar.snp.makeConstraints() {
            $0.top.equalTo(libraryNavigationView.snp.bottom).offset(-6)
            $0.width.equalToSuperview()
            $0.height.equalTo(54)
        }
        
        libraryPageViewController.view.snp.makeConstraints {
            $0.top.equalTo(libraryPageBar.snp.bottom)
            $0.width.bottom.equalToSuperview()
        }
    }
}
