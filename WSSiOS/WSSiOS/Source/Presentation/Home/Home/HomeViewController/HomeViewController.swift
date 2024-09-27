//
//  HomeViewController.swift
//  WSSiOS
//
//  Created by 최서연 on 1/9/24.
//

import UIKit

import RxSwift
import RxCocoa
import Lottie

final class HomeViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    
    private let isLoggedIn: Bool
    
    //MARK: - UI Components
    
    private let rootView: HomeView
    
    //MARK: - Life Cycle
    
    init(viewModel: HomeViewModel, isLoggedIn: Bool) {
        self.viewModel = viewModel
        self.isLoggedIn = isLoggedIn
        self.rootView = HomeView(frame: .zero, isLoggedIn: isLoggedIn)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showTabBar()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        registerCell()
        setDelegate()
        bindViewModel()
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.view.backgroundColor = .wssWhite
    }
    
    //MARK: - Bind
    
    private func registerCell() {
        rootView.todayPopularView.todayPopularCollectionView.register(
            HomeTodayPopularCollectionViewCell.self,
            forCellWithReuseIdentifier: HomeTodayPopularCollectionViewCell.cellIdentifier)
        
        rootView.realtimePopularView.realtimePopularCollectionView.register(
            HomeRealtimePopularCollectionViewCell.self,
            forCellWithReuseIdentifier: HomeRealtimePopularCollectionViewCell.cellIdentifier)
        
        rootView.interestView.interestCollectionView.register(
            HomeInterestCollectionViewCell.self,
            forCellWithReuseIdentifier: HomeInterestCollectionViewCell.cellIdentifier)
        
        rootView.tasteRecommendView.tasteRecommendCollectionView.register(
            HomeTasteRecommendCollectionViewCell.self,
            forCellWithReuseIdentifier: HomeTasteRecommendCollectionViewCell.cellIdentifier)
    }
    
    private func setDelegate() {
        rootView.realtimePopularView.realtimePopularCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = HomeViewModel.Input(
            announcementButtonTapped: rootView.headerView.announcementButton.rx.tap,
            registerInterestNovelButtonTapped: rootView.interestView.unregisterView.registerButton.rx.tap,
            setPreferredGenresButtonTapped: rootView.tasteRecommendView.unregisterView.registerButton.rx.tap,
            induceModalViewLoginButtonTapped: rootView.induceLoginModalView.loginButton.rx.tap,
            induceModalViewCancelButtonTapped: rootView.induceLoginModalView.cancelButton.rx.tap,
            todayPopularCellSelected: rootView.todayPopularView.todayPopularCollectionView.rx.itemSelected,
            tasteRecommendCellSelected: rootView.tasteRecommendView.tasteRecommendCollectionView.rx.itemSelected
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.todayPopularList
            .bind(to: rootView.todayPopularView.todayPopularCollectionView.rx.items(
                cellIdentifier: HomeTodayPopularCollectionViewCell.cellIdentifier,
                cellType: HomeTodayPopularCollectionViewCell.self)) { row, element, cell in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        output.realtimePopularData
            .bind(to: rootView.realtimePopularView.realtimePopularCollectionView.rx.items(
                cellIdentifier: HomeRealtimePopularCollectionViewCell.cellIdentifier,
                cellType: HomeRealtimePopularCollectionViewCell.self)) { row, element, cell in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        output.realtimePopularData
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, realtimePopularItems in
                owner.rootView.realtimePopularView.configureDots(numberOfItems: realtimePopularItems.count)
            })
            .disposed(by: disposeBag)
        
        output.interestList
            .bind(to: rootView.interestView.interestCollectionView.rx.items(
                cellIdentifier: HomeInterestCollectionViewCell.cellIdentifier,
                cellType: HomeInterestCollectionViewCell.self)) { row, element, cell in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        output.tasteRecommendList
            .bind(to: rootView.tasteRecommendView.tasteRecommendCollectionView.rx.items(
                cellIdentifier: HomeTasteRecommendCollectionViewCell.cellIdentifier,
                cellType: HomeTasteRecommendCollectionViewCell.self)) { row, element, cell in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        output.navigateToAnnouncementView
            .bind(with: self, onNext: { owner, _ in
                let viewController = HomeNoticeViewController(viewModel: HomeNoticeViewModel(noticeRepository: DefaultNoticeRepository(noticeService: DefaultNoticeService() )))
                viewController.navigationController?.isNavigationBarHidden = false
                viewController.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.navigateToNormalSearchView
            .bind(with: self, onNext: { owner, _ in
                let normalSearchViewController = NormalSearchViewController(viewModel: NormalSearchViewModel(searchRepository: DefaultSearchRepository(searchService: DefaultSearchService())))
                normalSearchViewController.navigationController?.isNavigationBarHidden = false
                normalSearchViewController.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(normalSearchViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.navigateToLoginView
            .bind(with: self, onNext: { owner, _ in
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                    return
                }
                sceneDelegate.setRootToLoginViewController()
            })
            .disposed(by: disposeBag)
        
        output.showInduceLoginModalView
            .drive(with: self, onNext: { owner, isShow in
                owner.showInduceLoginModalView(isShow)
            })
            .disposed(by: disposeBag)
        
        output.navigateToNovelDetailInfoView
            .withLatestFrom(Observable.combineLatest(output.todayPopularList, output.tasteRecommendList)) { (indexPathSection, lists) in
                let (indexPath, section) = indexPathSection
                let (todayPopularList, tasteRecommendList) = lists

                switch section {
                case 0:
                    return todayPopularList[indexPath.row].novelId
                case 1:
                    return tasteRecommendList[indexPath.row].novelId
                default:
                    return nil
                }
            }
            .compactMap { $0 }
            .subscribe(with: self, onNext: { owner, novelId in
                owner.pushToDetailViewController(novelId: novelId)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Custom Method
    
    private func showInduceLoginModalView(_ isShow: Bool) {
        rootView.induceLoginModalView.isHidden = !isShow
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == rootView.realtimePopularView.realtimePopularCollectionView {
            let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
            let cellWidth: CGFloat = UIScreen.main.bounds.width - 40
            let index = round(scrolledOffsetX / cellWidth)
            targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == rootView.realtimePopularView.realtimePopularCollectionView {
            let pageWidth = scrollView.frame.width
            let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            rootView.realtimePopularView.updateDots(currentPage: currentPage)
        }
    }
}

