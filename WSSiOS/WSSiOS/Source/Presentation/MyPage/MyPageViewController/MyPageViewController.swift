//
//  MyPageViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/8/24.
//

import UIKit

import RxSwift
import Then

final class MyPageViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let userRepository: UserRepository
    
    //MARK: - UI Components
    
    private var rootView = MyPageView()
    
    private lazy var settingButton = UIButton()
    
    // MARK: - Life Cycle
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository 
        
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
        
        setUI()
        preparationSetNavigationBar(title: "",
                                    left: nil,
                                    right: settingButton)
        rootView.scrollView.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showTabBar()
    }
    
    //MARK: - Actions
    
    private func bindAction() {
        
    }
    
    private func updateNavigationTitle(isShown: Bool) {
        if isShown {
            preparationSetNavigationBar(title: "마이페이지",
                                        left: nil,
                                        right: settingButton)
        } else {
            preparationSetNavigationBar(title: "",
                                        left: nil,
                                        right: settingButton)
        }
    }
}

extension MyPageViewController: UIScrollViewDelegate {
    
    //TODO: - headerViewHeight 초기값 0으로 잡히는 에러 수정
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerViewHeight = rootView.headerView.frame.height
        let scrollOffset = scrollView.contentOffset.y
        
        print(scrollOffset, " ", headerViewHeight)
        if scrollOffset >= headerViewHeight {
            rootView.stickyHeaderView2.isHidden = false
            rootView.stickyHeaderView.isHidden = true
            rootView.headerView.isHidden = true
            
            updateNavigationTitle(isShown: true)
            
        } else {
            rootView.stickyHeaderView2.isHidden = true
            rootView.stickyHeaderView.isHidden = false
            rootView.headerView.isHidden = false
            
            updateNavigationTitle(isShown: false)
        }
    }
}

extension MyPageViewController {
    
    //MARK: - UI
    
    private func setUI() {
        settingButton.do {
            $0.setImage(UIImage(resource: .setting), for: .normal)
        }
    }
}

