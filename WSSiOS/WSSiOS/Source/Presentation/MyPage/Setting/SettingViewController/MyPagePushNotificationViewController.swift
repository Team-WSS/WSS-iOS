//
//  MyPagePushNotificationViewController.swift
//  WSSiOS
//
//  Created by YunhakLee on 1/22/25.
//

import UIKit

import RxSwift

final class MyPagePushNotificationViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: MyPagePushNotificationViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = MyPageProfileVisibilityView()
    
    // MARK: - Life Cycle
    
    init(viewModel: MyPagePushNotificationViewModel) {
        
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
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideTabBar()
        swipeBackGesture()
    }
    
    //MARK: - Bind
    
    private func bindViewModel() {
       
    }
}
