//
//  LibraryPageViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/14/24.
//

import UIKit

import RxSwift
import RxRelay
import RxCocoa

final class LibraryViewController: UIViewController {
    
    //MARK: - Properties
    
    private let libraryViewModel: LibraryViewModel
    private let disposeBag = DisposeBag()
    
    private let sortTypeList = StringLiterals.Alignment.self
    private let readStatusList = StringLiterals.LibraryReadStatus.allCases.map { $0.rawValue }
    private var currentPageIndex = 0
    private let sendNovelTotalCount = BehaviorRelay<Int>(value: 0)
    
    //UI 관련
    let libraryPageBar = LibraryPageBar()
    var libraryPages = [LibraryChildViewController]()
    let backButton = UIButton()
    
    //MARK: - UI Components
    
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
        
        setUI()
        setHierarchy()
        setLayout()
        
        delegate()
        register()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideTabBar()
        setWSSNavigationBar(title: StringLiterals.Navigation.Title.library,
                         left: backButton,
                         right: nil)
    }
    
    //MARK: - Bind
    
    private func register() {
        libraryPageBar.libraryTabCollectionView
            .register(LibraryTabCollectionViewCell.self,
                      forCellWithReuseIdentifier: LibraryTabCollectionViewCell.cellIdentifier)
    }
    
    private func delegate() {
        libraryPageViewController.delegate = self
        libraryPageViewController.dataSource = self
    }
    
    private func bindViewModel() {
        let input = LibraryViewModel.Input(
            tabBarDidTap:libraryPageBar.libraryTabCollectionView.rx.itemSelected,
            backButtonDidTap: backButton.rx.tap
        )
        
        let output = libraryViewModel.transform(from: input, disposeBag: disposeBag)
        
        output.setUpPageViewController
            .subscribe(with: self, onNext: { owner, userId in
                owner.addChild(owner.libraryPageViewController)
                owner.view.addSubviews(owner.libraryPageViewController.view)
                owner.libraryPageViewController.didMove(toParent: self)
                
                for i in 0..<owner.readStatusList.count {
                    let sortTypeList = owner.sortTypeList.newest
                    let sortTypeQuery = ShowNovelStatus(readStatus: owner.readStatusList[i],
                                                        lastUserNovelId: sortTypeList.lastId,
                                                        size: sortTypeList.sizeData,
                                                        sortType: sortTypeList.sortType)
                    let viewController = owner.setLibraryChildViewController(userId: userId, data: sortTypeQuery)
                    owner.libraryPages.append(viewController)
                }
                
                for (index, viewController) in owner.libraryPages.enumerated() {
                    viewController.view.tag = index
                }
                
                owner.libraryPageViewController.setViewControllers([owner.libraryPages[0]],
                                                                   direction: .forward,
                                                                   animated: false,
                                                                   completion: nil)
            })
            .disposed(by: disposeBag)
        
        output.bindCell
            .bind(to: libraryPageBar.libraryTabCollectionView.rx.items(
                cellIdentifier: LibraryTabCollectionViewCell.cellIdentifier,
                cellType: LibraryTabCollectionViewCell.self)) { (row, element, cell) in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        output.moveToTappedTabBar
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
        
        output.popLastViewController
            .bind(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        libraryPageBar.libraryTabCollectionView.selectItem(at: IndexPath(item: 0, section: 0),
                                                           animated: true,
                                                           scrollPosition: [])
    }
}

//MARK: - Set PageController

extension LibraryViewController : UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentViewController = pageViewController.viewControllers?.first, let index = libraryPages.firstIndex(of: currentViewController as! LibraryChildViewController) {
            libraryPageBar.libraryTabCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            currentPageIndex = index
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
    private func setLibraryChildViewController(userId: Int, data: ShowNovelStatus) -> LibraryChildViewController {
        return LibraryChildViewController(
            libraryViewModel: LibraryChildViewModel(
                userRepository: DefaultUserRepository(
                    userService: DefaultUserService(),
                    blocksService: DefaultBlocksService()),
                initData: data,
                userId: userId))
    }
}

extension LibraryViewController {
    
    //MARK: - UI
    
    private func setUI() {
        self.view.backgroundColor = .wssWhite
        
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal).withTintColor(.wssGray300), for: .normal)
        }
    }
    
    private func setHierarchy() {
        self.view.addSubviews(libraryPageBar)
        self.addChild(libraryPageViewController)
        self.view.addSubviews(libraryPageViewController.view)
        libraryPageViewController.didMove(toParent: self)
    }
    
    private func setLayout() {
        libraryPageBar.snp.makeConstraints() {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.width.equalToSuperview()
            $0.height.equalTo(54)
        }
        
        libraryPageViewController.view.snp.makeConstraints {
            $0.top.equalTo(libraryPageBar.snp.bottom)
            $0.width.bottom.equalToSuperview()
        }
    }
}
