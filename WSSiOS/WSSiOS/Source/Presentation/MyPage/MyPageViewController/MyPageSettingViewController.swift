//
//  MyPageSettingViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 7/10/24.
//

import UIKit
import RxSwift

final class MyPageSettingViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: MyPageViewModel
    
    //MARK: - UI Components
    
    private var rootView = MyPageView()
    
    
    // MARK: - Life Cycle
    
    init(viewModel: MyPageViewModel) {
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
        
    }
    
    //MARK: - Delegate
    
    
    
    //MARK: - Bind
    
    
}
