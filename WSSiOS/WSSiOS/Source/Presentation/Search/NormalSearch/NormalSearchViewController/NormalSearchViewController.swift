//
//  NormalSearchViewController.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/27/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture
import Then

final class NormalSearchViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: NormalSearchViewModel
    private let disposeBag = DisposeBag()
    
    private let viewWillAppearEvent = BehaviorRelay(value: false)
    
    //MARK: - Components
    
    private let rootView = NormalSearchView()
    private let emptyView = NormalSearchEmptyView()
    
    //MARK: - Life Cycle
    
    init(viewModel: NormalSearchViewModel) {
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
        
        viewWillAppearEvent.accept(true)
        swipeBackGesture()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        registerCell()
        bindViewModel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.view.do {
            $0.backgroundColor = .White
        }
    }
    
    //MARK: - Bind
    
    private func registerCell() {
        rootView.resultView.normalSearchCollectionView.register(
            NormalSearchCollectionViewCell.self,
            forCellWithReuseIdentifier: NormalSearchCollectionViewCell.cellIdentifier)
    }
    
    private func bindViewModel() {
        let input = NormalSearchViewModel.Input(
            searchTextUpdated: rootView.headerView.searchTextField.rx.text.orEmpty,
            searchTextReturnKeyPressed: rootView.headerView.searchTextField.rx.controlEvent(.editingDidEndOnExit),
            backButtonDidTap: rootView.headerView.backButton.rx.tap,
            inquiryButtonDidTap: rootView.emptyView.inquiryButton.rx.tap,
            normalSearchCollectionViewContentSize: rootView.resultView.normalSearchCollectionView.rx.observe(CGSize.self, "contentSize"))
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.resultCount
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, data in
                self.rootView.resultView.resultCountView.bindData(data: data)
            })
            .disposed(by: disposeBag)
        
        output.normalSearchList
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.resultView.normalSearchCollectionView.rx.items(
                cellIdentifier: NormalSearchCollectionViewCell.cellIdentifier,
                cellType: NormalSearchCollectionViewCell.self)) { row, element, cell in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        output.normalSearchList
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext: { owner, novels in
                if novels.isEmpty && !(owner.rootView.headerView.searchTextField.text ?? "").isEmpty {
                    owner.view.addSubview(owner.emptyView)
                    owner.emptyView.snp.makeConstraints {
                        $0.top.equalTo(owner.rootView.headerView.snp.bottom)
                        $0.horizontalEdges.bottom.equalToSuperview()
                    }
                    owner.rootView.resultView.resultCountView.isHidden = true
                } else {
                    owner.emptyView.removeFromSuperview()
                    owner.rootView.resultView.resultCountView.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        rootView.resultView.normalSearchCollectionView.rx.swipeGesture(.up)
            .when(.recognized)
            .subscribe(with: self, onNext: { owner, _ in
                self.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        rootView.resultView.normalSearchCollectionView.rx.swipeGesture(.down)
            .when(.recognized)
            .subscribe(with: self, onNext: { owner, _ in
                self.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        output.backButtonEnabled
            .bind(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        output.inquiryButtonEnabled
            .bind(with: self, onNext: { owner, _ in
                if let url = URL(string: StringLiterals.Search.Empty.kakaoChannelUrl) {
                    UIApplication.shared.open(url, options: [:])
                }
            })
            .disposed(by: disposeBag)
        
        output.normalSearchCollectionViewHeight
            .drive(with: self, onNext: { owner, height in
                owner.rootView.resultView.updateCollectionViewHeight(height: height)
            })
            .disposed(by: disposeBag)
        
        rootView.headerView.backButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
    }
}
