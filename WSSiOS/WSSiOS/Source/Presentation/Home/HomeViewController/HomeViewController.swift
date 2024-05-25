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
    
    //MARK: - UI Components
    
    private let rootView = HomeView()
    
    //MARK: - Life Cycle

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
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
        bindViewModel()
    }
    
    private func setUI() {
        self.view.do {
            $0.backgroundColor = .White
        }
    }
    
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
    
    private func bindViewModel() {
        let input = HomeViewModel.Input(
            announcementButtonTapped: rootView.headerView.announcementButton.rx.tap
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)

        output.todayPopularList
            .bind(to: rootView.todayPopularView.todayPopularCollectionView.rx.items(
                cellIdentifier: HomeTodayPopularCollectionViewCell.cellIdentifier,
                cellType: HomeTodayPopularCollectionViewCell.self)) { row, element, cell in
                cell.bindData(data: element)
            }
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
        
        output.navigateToAnnoucementView
            .bind(with: self, onNext: { owner, _ in
                owner.navigationController?.pushViewController(
                    HomeNoticeViewController(
                        viewModel: HomeNoticeViewModel(
                            noticeRepository: DefaultNoticeRepository()
                        )
                    ), animated: true)
            })
            .disposed(by: disposeBag)
    }
}
