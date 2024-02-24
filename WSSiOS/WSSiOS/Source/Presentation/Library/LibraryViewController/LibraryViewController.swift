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
    
    private let userNovelListRepository: DefaultUserNovelRepository
    
    private let disposeBag = DisposeBag()
    private let tabBarList = StringLiterals.Alignment.TabBar.allCases.map { $0.rawValue }
    private let readStatusList = StringLiterals.Alignment.ReadStatus.allCases.map { $0.rawValue }
    private let sortTypeList = StringLiterals.Alignment.SortType.self
    private var currentPageIndex = 0
    
    //MARK: - Components
    
    private let libraryPageViewController = UIPageViewController(transitionStyle: .scroll,
                                                                 navigationOrientation: .horizontal,
                                                                 options: nil)
    private let libraryPageBar = LibraryPageBar()
    private let libraryDescriptionView = LibraryDescriptionView()
    private let libraryListView = LibraryListView()
    private lazy var libraryPages = [LibraryBaseViewController]()
    
    // MARK: - Life Cycle
    
    init(userNovelListRepository: DefaultUserNovelRepository) {
        self.userNovelListRepository = userNovelListRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.library,
                                    left: nil,
                                    right: nil)
        setupPages()
        setUI()
        setHierarchy()
        delegate()
        register()
        bindCell()
        setLayout()
        setAction()
        addNotificationCenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showTabBar()
    }
    
    //MARK: - Bind
    
    private func register() {
        libraryPageBar.libraryTabCollectionView
            .register(LibraryTabCollectionViewCell.self,
                      forCellWithReuseIdentifier: "LibraryTabCollectionViewCell")
    }
    
    private func bindCell() {
        Observable.just(tabBarList)
            .bind(to: libraryPageBar.libraryTabCollectionView.rx.items(
            cellIdentifier: "LibraryTabCollectionViewCell",
            cellType: LibraryTabCollectionViewCell.self)) { (row, element, cell) in
                cell.bindData(data: element)
            }
            .disposed(by: disposeBag)
        
        libraryPageBar.libraryTabCollectionView.rx.itemSelected
            .map { indexPath in
                return indexPath.row
            }
            .bind(to: self.libraryPageBar.selectedTabIndex)
            .disposed(by: disposeBag)
        
        libraryPageBar.libraryTabCollectionView.selectItem(at: IndexPath(item: 0, section: 0),
                                                                 animated: true,
                                                                 scrollPosition: [])
    }
    
    private func delegate() {
        libraryPageViewController.delegate = self
        libraryPageViewController.dataSource = self
    }
    
    private func setupPages() {
        for i in 0..<readStatusList.count {
            let sortTypeList = sortTypeList.newest
            let viewController = LibraryBaseViewController(
                userNovelListRepository: DefaultUserNovelRepository(
                    userNovelService: DefaultUserNovelService()),
                readStatus: readStatusList[i],
                lastUserNovelId: sortTypeList.lastUserNovelIdData,
                size: sortTypeList.sizeData,
                sortType: sortTypeList.sortType)
            
            viewController.delegate = self
            libraryPages.append(viewController)
        }
        
        for (index, viewController) in libraryPages.enumerated() {
            viewController.view.tag = index
        }
        
        libraryPageViewController.setViewControllers([libraryPages[0]],
                                                     direction: .forward,
                                                     animated: false,
                                                     completion: nil)
    }
    
    //MARK: - Actions
    
    private func setAction() {
        libraryPageBar.selectedTabIndex
            .subscribe(with: self, onNext: { owner, index in 
                let direction: UIPageViewController.NavigationDirection = index > (owner.libraryPageViewController.viewControllers?.first?.view.tag ?? 0) ? .forward : .reverse
                owner.libraryPageViewController.setViewControllers([owner.libraryPages[index]],
                                                                   direction: direction,
                                                                   animated: true,
                                                                   completion: nil)
            })
            .disposed(by: disposeBag)
        
        libraryDescriptionView.libraryNovelListButton.rx.tap
            .bind(with: self, onNext: { owner, _ in 
                owner.libraryListView.isHidden.toggle()
            })
            .disposed(by: disposeBag)
        
        libraryListView.libraryNewestButton.rx.tap
            .bind(with: self) { owner , _ in
                let sortTypeList = owner.sortTypeList.newest
                owner.updatePages(sortType: sortTypeList)
                owner.resetUI(title: sortTypeList.title)
                owner.libraryListView.isHidden.toggle()
            }
            .disposed(by: disposeBag)
        
        libraryListView.libraryOldesttButton.rx.tap
            .bind(with: self) { owner , _ in
                let sortTypeList = owner.sortTypeList.oldest
                owner.updatePages(sortType: sortTypeList)
                owner.resetUI(title: sortTypeList.title)
                owner.libraryListView.isHidden.toggle()
            }
            .disposed(by: disposeBag)
    }
    
    private func updatePages(sortType: StringLiterals.Alignment.SortType) {
        let viewController = libraryPages[currentPageIndex]
        viewController.updateNovelList(readStatus: readStatusList[currentPageIndex],
                                       lastUserNovelId: sortType.lastUserNovelIdData,
                                       size: sortType.sizeData,
                                       sortType: sortType.sortType)
    }
}

//MARK: - Set PageController

extension LibraryViewController : UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) { 
        if completed, let currentViewController = pageViewController.viewControllers?.first, let index = libraryPages.firstIndex(of: currentViewController as! LibraryBaseViewController) {
            libraryPageBar.libraryTabCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            currentPageIndex = index
        }
    }
}

extension LibraryViewController: UIPageViewControllerDataSource {
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

extension LibraryViewController: NovelDelegate {
    func sendData(data: Int) {
        libraryDescriptionView.libraryNovelCountLabel.text = "\(data)개"
    }
}

extension LibraryViewController {
    
    //MARK: - UI
    
    private func setUI() {
        self.view.backgroundColor = .wssWhite
        
        libraryListView.isHidden = true
    }
    
    private func setHierarchy() {
        self.view.addSubviews(libraryPageBar,
                              libraryDescriptionView)
        self.addChild(libraryPageViewController)
        self.view.addSubviews(libraryPageViewController.view)
        libraryPageViewController.didMove(toParent: self)
        self.view.addSubview(libraryListView)
    }
    
    private func setLayout() {
        libraryPageBar.snp.makeConstraints() {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.width.equalToSuperview()
            $0.height.equalTo(54)
        }
        
        libraryDescriptionView.snp.makeConstraints() {
            $0.top.equalTo(libraryPageBar.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        libraryPageViewController.view.snp.makeConstraints {
            $0.top.equalTo(libraryDescriptionView.snp.bottom)
            $0.width.bottom.equalToSuperview()
        }
        
        libraryListView.snp.makeConstraints() {
            $0.top.equalTo(libraryDescriptionView.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(25)
            $0.width.equalTo(100)
            $0.height.equalTo(104)
        }
    }
    
    private func resetUI(title: String) {
        self.libraryDescriptionView.libraryNovelListButton.do {
            let title = title
            var attString = AttributedString(title)
            attString.font = UIFont.Label1
            attString.foregroundColor = UIColor.wssGray300
            
            var configuration = UIButton.Configuration.filled()
            configuration.attributedTitle = attString
            configuration.image = .icDropDown
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0)
            configuration.imagePlacement = .trailing
            configuration.baseBackgroundColor = UIColor.clear
            $0.configuration = configuration
        }
    }
    
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
        self.navigationController?.pushViewController(NovelDetailViewController(
            viewModel: NovelDetailViewModel(
                userNovelRepository: DefaultUserNovelRepository(
                    userNovelService: DefaultUserNovelService()
                ),
                selectedMenu: .info
            ),
            userNovelId: userNovelId
        ), animated: true)
    }
    
    @objc
    func showNovelMemo(_ notification: Notification) {
        guard let userNovelId = notification.object as? Int else { return }
        self.navigationController?.pushViewController(NovelDetailViewController(
            viewModel: NovelDetailViewModel(
                userNovelRepository: DefaultUserNovelRepository(
                    userNovelService: DefaultUserNovelService()
                ),
                selectedMenu: .memo
            ),
            userNovelId: userNovelId
        ), animated: true)
    }
}


