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
        bindViewModel()
        
        viewDidLoadEvent.accept(())
    }
    
    //MARK: - UI
    
    private func setNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.rootView.backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.rootView.completeButton)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = .wssWhite
    }
    
    private func register() {
        rootView.novelReviewStatusView.statusCollectionView.register(NovelReviewStatusCollectionViewCell.self, forCellWithReuseIdentifier: NovelReviewStatusCollectionViewCell.cellIdentifier)
    }
    
    //MARK: - Bind
    
    private func bindViewModel() {
        let input = NovelReviewViewModel.Input(
            viewDidLoadEvent: viewDidLoadEvent.asObservable(),
            backButtonDidTap: rootView.backButton.rx.tap
        )
        
        let output = self.novelReviewViewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.novelReviewStatusData.bind(to: rootView.novelReviewStatusView.statusCollectionView.rx.items(cellIdentifier: NovelReviewStatusCollectionViewCell.cellIdentifier, cellType: NovelReviewStatusCollectionViewCell.self)) { item, element, cell in
            cell.bindData(status: element)
        }
        .disposed(by: disposeBag)
        
        output.popViewController
            .subscribe(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
