//
//  FeedViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 5/14/24.
//

import UIKit

import RxSwift

final class FeedViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private var rootView = FeedView()
    private var viewModel: FeedViewModel
    
    // MARK: - Life Cycle
    
    init(viewModel: FeedViewModel) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    
    //MARK: - Bind
    
    private func bindViewModel() {
        
    }
}
