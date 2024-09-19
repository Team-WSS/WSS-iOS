//
//  LoginViewController.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/17/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class LoginViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: LoginViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = LoginView()
    
    //MARK: - Life Cycle
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        delegate()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        rootView.carouselView.bannerCollectionView.setContentOffset(CGPoint(x: LoginCarouselMetric.collectionViewWidth, y: 0), animated: false)
    }
    
    private func registerCell() {
        rootView.carouselView.bannerCollectionView.register(
            LoginbannerCollectionViewCell.self,
            forCellWithReuseIdentifier: LoginbannerCollectionViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.carouselView.bannerCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = createViewModelInput()
        let output = viewModel.transform(from: input,
                                         disposeBag: disposeBag)
        bindViewModelOutput(output)
    }
    
    private func bindViewModelOutput(_ output: LoginViewModel.Output) {
        output.bannerImages
            .drive(rootView.carouselView.bannerCollectionView.rx.items(
                cellIdentifier: LoginbannerCollectionViewCell.cellIdentifier,
                cellType: LoginbannerCollectionViewCell.self)) { _, element, cell in
                    cell.bindData(image: element)
                }
                .disposed(by: disposeBag)
        
        rootView.carouselView.bannerCollectionView.rx.itemSelected
            .withLatestFrom(output.bannerImages) {(indexPath: $0, platformList: $1)}
            .subscribe(with: self, onNext: { owner, data in
                print(data.indexPath.row)
            })
            .disposed(by: disposeBag)
    }
    
    private func createViewModelInput() -> LoginViewModel.Input {
        return LoginViewModel.Input(
           
        )
    }
}

extension LoginViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let maxIndex = 5
        
        if scrollView.contentOffset.x == 0 {
            scrollView.setContentOffset(CGPoint(x: LoginCarouselMetric.collectionViewWidth * Double(maxIndex-1), y: 0), animated: false)
        }
        if scrollView.contentOffset.x == LoginCarouselMetric.collectionViewWidth * Double(maxIndex) {
            scrollView.setContentOffset(CGPoint(x: LoginCarouselMetric.collectionViewWidth, y: 0), animated: false)
        }
    }
}
