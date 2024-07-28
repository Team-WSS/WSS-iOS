//
//  MyPageDeleteIDViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 7/24/24.
//

import UIKit

import RxSwift

final class MyPageDeleteIDViewController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel: MyPageDeleteIDViewModel
    
    //MARK: - Components
    
    private let disposeBag = DisposeBag()
    private let rootView = MyPageDeleteIDView()
    
    // MARK: - Life Cycle
    
    init(viewModel: MyPageDeleteIDViewModel) {
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
        
        register()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setNavigationBar()
        hideTabBar()
        swipeBackGesture()
    }
    
    //MARK: - Bind
    
    private func register() {
        rootView.reasonTableView.register(
            MyPageDeleteIDReasonTableViewCell.self,
            forCellReuseIdentifier: MyPageDeleteIDReasonTableViewCell.cellIdentifier)
        
        rootView.checkTableView.register(
            MyPageDeleteIDCheckTableViewCell.self, forCellReuseIdentifier: MyPageDeleteIDCheckTableViewCell.cellIdentifier)
    }
    
    private func bindViewModel() {
        let input = MyPageDeleteIDViewModel.Input(
            backButtonDidTap: rootView.backButton.rx.tap,
            agreeAllButtonDidTap: rootView.agreeDeleteIDButton.rx.tap,
            reasonCellDidTap: rootView.reasonTableView.rx.itemSelected,
            completeButtonDidTap: rootView.completeButton.rx.tap,
            viewDidTap: view.rx.tapGesture(),
            textUpdated: rootView.reasonTextView.rx.text.orEmpty.asObservable(),
            didBeginEditing: rootView.reasonTextView.rx.didBeginEditing,
            didEndEditing: rootView.reasonTextView.rx.didEndEditing)
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.bindReasonCell
            .bind(to: rootView.reasonTableView.rx.items(
                cellIdentifier: MyPageDeleteIDReasonTableViewCell.cellIdentifier,
                cellType: MyPageDeleteIDReasonTableViewCell.self)) { row, element, cell in
                    cell.bindData(text: element)
                    cell.selectionStyle = .none
                }
                .disposed(by: disposeBag)
        
        output.bindCheckCell
            .bind(to: rootView.checkTableView.rx.items(
                cellIdentifier: MyPageDeleteIDCheckTableViewCell.cellIdentifier,
                cellType: MyPageDeleteIDCheckTableViewCell.self)) { row, element, cell in
                    cell.bindData(title: element.0, description: element.1)
                    cell.selectionStyle = .none
                }
                .disposed(by: disposeBag)
        
        output.changeAgreeButtonColor
            .bind(with: self, onNext: { owner, isTap in
                owner.rootView.agreeDeleteIDButtonIsSeleted(isSeleted: isTap)
            })
            .disposed(by: disposeBag)
        
        
        output.tapReasonCell
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.rootView.reasonTableView.visibleCells.forEach { cell in
                    let cellIndexPath = self.rootView.reasonTableView.indexPath(for: cell)
                    if let cell = cell as? MyPageDeleteIDReasonTableViewCell {
                        cell.isSeleted(isSeleted: cellIndexPath == indexPath)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.popViewController
            .bind(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        output.beginEditing
            .bind(with: self, onNext: { owner, beginEditing in
                owner.rootView.placeholderIsHidden(isHidden: true)
                output.tapReasonCell.accept(MyPageDeleteIDViewModel.exceptionIndexPath)
            })
            .disposed(by: disposeBag)
        
        output.endEditing
            .bind(with: self, onNext: { owner, endEditing in
                owner.view.endEditing(endEditing)
                let text = output.containText.value
                if text.textIsEmpty() {
                    owner.rootView.placeholderIsHidden(isHidden: false)
                    output.containText.accept("")
                }
            })
            .disposed(by: disposeBag)
        
        output.textCountLimit
            .bind(with: self, onNext: { owner, count in
                owner.rootView.bindTextCount(count: count)
            })
            .disposed(by: disposeBag)
        
        output.containText
            .bind(with: self, onNext: { owner, text in
                owner.rootView.bindText(text: text)
            })
            .disposed(by: disposeBag)
        
        output.completeButtonIsAble
            .bind(with: self, onNext: { owner, isAble in
                owner.rootView.completeButtonIsAble(isAble: isAble)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - UI

extension MyPageDeleteIDViewController {
    private func setNavigationBar() {
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.deleteID,
                                    left: self.rootView.backButton,
                                    right: nil)
    }
}

