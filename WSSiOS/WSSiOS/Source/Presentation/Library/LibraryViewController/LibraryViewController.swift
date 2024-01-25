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
    
    private let disposeBag = DisposeBag()
    private let tabBarList = Observable.just(["전체", "읽음", "읽는 중", "하차", "읽고 싶음"])
    private let readStatusList = ["ALL", "FINISH", "READING", "DROP", "WISH"]
    private let sortTypeList = ["NEWEST", "OLDEST"]
    
    //MARK: - UI Components
    
    private var libraryPageViewController = UIPageViewController(transitionStyle: .scroll,
                                                                 navigationOrientation: .horizontal,
                                                                 options: nil)
    private let libraryPageBar = LibraryPageBar()
    private let libraryDescriptionView = LibraryDescriptionView()
    private let libraryListView = LibraryListView()
    private lazy var libraryPages = [LibraryBaseViewController]()
    private let userNovelListRepository: DefaultUserNovelRepository
    
    init(userNovelListRepository: DefaultUserNovelRepository) {
        self.userNovelListRepository = userNovelListRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        showTabBar()
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setTabBar()
        delegate()
        setupPages()
        setUI()
        setHierarchy()
        setLayout()
        setAction()
        addNotificationCenter()
    }
    
    //MARK: - set NavigationBar
    
    private func setNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = StringLiterals.Navigation.Title.library
        
        if let navigationBar = self.navigationController?.navigationBar {
            let titleTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.Title2
            ]
            navigationBar.titleTextAttributes = titleTextAttributes
        }
    }
    
    //MARK: - Custom TabBar
    
    private func setTabBar() {
        libraryPageBar.libraryTabCollectionView
            .register(LibraryTabCollectionViewCell.self,
                      forCellWithReuseIdentifier: "LibraryTabCollectionViewCell")
        
        tabBarList.bind(to: libraryPageBar.libraryTabCollectionView.rx.items(
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
        
        Observable.just(Void())
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.libraryPageBar.libraryTabCollectionView.selectItem(at: IndexPath(item: 0, section: 0),
                                                                         animated: true,
                                                                         scrollPosition: [])
                self?.libraryPageBar.selectedTabIndex.onNext(0)
            })
            .disposed(by: disposeBag)
    }
    
    private func delegate() {
        libraryPageViewController.delegate = self
        libraryPageViewController.dataSource = self
    }
    
    private func setupPages() {
        for i in 0..<readStatusList.count {
            let viewController = LibraryBaseViewController(
                userNovelListRepository: DefaultUserNovelRepository(
                    userNovelService: DefaultUserNovelService()),
                readStatusData: readStatusList[i],
                lastUserNovelIdData: 999999,
                sizeData: 500,
                sortTypeData: sortTypeList[0])
            
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
        
        libraryDescriptionView.libraryNovelListButton.rx.tap
            .bind(with: self, onNext: { owner, _ in 
                owner.libraryListView.isHidden.toggle()
            })
            .disposed(by: disposeBag)
        
        libraryListView.libraryNewestButton.rx.tap
            .bind(with: self) { owner , _ in
                owner.updatePages(sort: owner.sortTypeList[0])
                owner.libraryDescriptionView.libraryNovelListButton.setTitle(StringLiterals.Library.newest, for: .normal)
                owner.libraryListView.isHidden.toggle()
            }
            .disposed(by: disposeBag)
        
        libraryListView.libraryOldesttButton.rx.tap
            .bind(with: self) { owner , _ in
                owner.updatePages(sort: owner.sortTypeList[1])
                owner.libraryDescriptionView.libraryNovelListButton.setTitle(StringLiterals.Library.oldest, for: .normal)
                owner.libraryListView.isHidden.toggle()
            }
            .disposed(by: disposeBag)
    }
    
    private func updatePages(sort: String) {
        for index in 0..<readStatusList.count {
            let viewController = libraryPages[index]
            viewController.reloadView(sortType: sort)
        }
    }
}

//MARK: - set PageController

extension LibraryViewController : UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) { 
        if completed, let currentViewController = pageViewController.viewControllers?.first, let index = libraryPages.firstIndex(of: currentViewController as! LibraryBaseViewController) {
            libraryPageBar.libraryTabCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
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
    
    //MARK: - set Design
    
    private func setUI() {
        self.view.backgroundColor = .White
        
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
    
    //MARK: - notification
    
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
            repository: DefaultUserNovelRepository(
                userNovelService: DefaultUserNovelService()
            ),
            userNovelId: userNovelId,
            selectedMenu: 1
        ), animated: true)
    }
    
    @objc
    func showNovelMemo(_ notification: Notification) {
        guard let userNovelId = notification.object as? Int else { return }
        self.navigationController?.pushViewController(NovelDetailViewController(
            repository: DefaultUserNovelRepository(
                userNovelService: DefaultUserNovelService()
            ),
            userNovelId: userNovelId,
            selectedMenu: 0
        ), animated: true)
    }
}


