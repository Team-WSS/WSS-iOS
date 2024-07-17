//
//  DetailSearchViewController.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/18/24.
//

import UIKit

import RxSwift
import RxCocoa

final class DetailSearchViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: DetailSearchViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = DetailSearchView()
    
    //MARK: - Life Cycle
    
    init(viewModel: DetailSearchViewModel) {
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    //MARK: - Bind
    
    private func bindViewModel() {
        let input = DetailSearchViewModel.Input(cancelButtonDidTap: rootView.cancelModalButton.rx.tap)
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        input.cancelButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: false)
            })
            .disposed(by: disposeBag)
    }
}
