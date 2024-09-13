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
    }
    
    private func delegate() {
        rootView.novelReviewAttractivePointView.attractivePointCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Bind
    
    private func bindViewModel() {
        let input = NovelReviewViewModel.Input(
            viewDidLoadEvent: viewDidLoadEvent.asObservable(),
            backButtonDidTap: rootView.backButton.rx.tap
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
    }
}

extension NovelReviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var text: String?
        
        let attractivePointList = AttractivePoints.allCases.map { $0.koreanString }
        text = attractivePointList[indexPath.item]
        
        guard let unwrappedText = text else {
            return CGSize(width: 0, height: 0)
        }
        
        let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 26
        return CGSize(width: width, height: 37)
    }
}