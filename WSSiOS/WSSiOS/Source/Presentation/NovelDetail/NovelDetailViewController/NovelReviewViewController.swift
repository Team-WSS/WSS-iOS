//
//  NovelReviewViewController.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 8/28/24.
//

import UIKit

import RxSwift
import RxCocoa

final class NovelReviewViewController: UIViewController {
    
    //MARK: - Properties
    
    private let novelReviewViewModel: NovelReviewViewModel
    private let disposeBag = DisposeBag()
    
    private let viewDidLoadEvent = PublishRelay<Void>()
    
    //MARK: - Components
    
    private let rootView = NovelReviewView()
    
    //MARK: - Life Cycle
    
    init(viewModel: NovelReviewViewModel) {
        self.novelReviewViewModel = viewModel
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
        
        setNavigationBar()
        register()
        delegate()
        bindViewModel()
        
        viewDidLoadEvent.accept(())
    }
    
    //MARK: - UI
    
    private func setNavigationBar() {
        self.preparationSetNavigationBar(title: "당신의 이해를 돕기 위하여", left: rootView.backButton, right: rootView.completeButton)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = .wssWhite
    }
    
    private func register() {
        rootView.novelReviewStatusView.statusCollectionView.register(NovelReviewStatusCollectionViewCell.self, forCellWithReuseIdentifier: NovelReviewStatusCollectionViewCell.cellIdentifier)
        rootView.novelReviewAttractivePointView.attractivePointCollectionView.register(NovelReviewAttractivePointCollectionViewCell.self, forCellWithReuseIdentifier: NovelReviewAttractivePointCollectionViewCell.cellIdentifier)
        rootView.novelReviewKeywordView.selectedKeywordCollectionView.register(NovelReviewSelectedKeywordCollectionViewCell.self, forCellWithReuseIdentifier: NovelReviewSelectedKeywordCollectionViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.novelReviewAttractivePointView.attractivePointCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        rootView.novelReviewKeywordView.selectedKeywordCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Bind
    
    private func bindViewModel() {
        let input = NovelReviewViewModel.Input(
            viewDidLoadEvent: viewDidLoadEvent.asObservable(),
            backButtonDidTap: rootView.backButton.rx.tap,
            statusCollectionViewItemSelected: rootView.novelReviewStatusView.statusCollectionView.rx.itemSelected.asObservable(),
            selectedKeywordCollectionViewContentSize: rootView.novelReviewKeywordView.selectedKeywordCollectionView.rx.observe(CGSize.self, "contentSize"),
            selectedKeywordCollectionViewItemSelected: rootView.novelReviewKeywordView.selectedKeywordCollectionView.rx.itemSelected.asObservable()
        )
        
        let output = self.novelReviewViewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.popViewController
            .subscribe(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.novelReviewStatusData.bind(to: rootView.novelReviewStatusView.statusCollectionView.rx.items(cellIdentifier: NovelReviewStatusCollectionViewCell.cellIdentifier, cellType: NovelReviewStatusCollectionViewCell.self)) { item, element, cell in
            cell.bindData(status: element)
        }
        .disposed(by: disposeBag)
        
        output.attractivePointListData.bind(to: rootView.novelReviewAttractivePointView.attractivePointCollectionView.rx.items(cellIdentifier: NovelReviewAttractivePointCollectionViewCell.cellIdentifier, cellType: NovelReviewAttractivePointCollectionViewCell.self)) { item, element, cell in
            cell.bindData(attractivePoint: element)
        }
        .disposed(by: disposeBag)
        
        output.selectedKeywordListData.bind(to: rootView.novelReviewKeywordView.selectedKeywordCollectionView.rx.items(cellIdentifier: NovelReviewSelectedKeywordCollectionViewCell.cellIdentifier, cellType: NovelReviewSelectedKeywordCollectionViewCell.self)) { item, element, cell in
            cell.bindData(keyword: element)
        }
        .disposed(by: disposeBag)
        
        output.selectedKeywordCollectionViewHeight
            .subscribe(with: self, onNext: { owner, height in
                owner.rootView.novelReviewKeywordView.updateCollectionViewHeight(height: height)
            })
            .disposed(by: disposeBag)
    }
}

extension NovelReviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 1 {
            var text: String?
            
            let attractivePointList = AttractivePoints.allCases.map { $0.koreanString }
            text = attractivePointList[indexPath.item]
            
            guard let unwrappedText = text else {
                return CGSize(width: 0, height: 0)
            }
            
            let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 26
            return CGSize(width: width, height: 37)
        } else if collectionView.tag == 2 {
            var text: String?
            
            text = self.novelReviewViewModel.selectedKeywordList[indexPath.item]
            
            guard let unwrappedText = text else {
                return CGSize(width: 0, height: 0)
            }
            
            let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 52
            return CGSize(width: width, height: 37)
        } else {
            return CGSize()
        }
    }
}
