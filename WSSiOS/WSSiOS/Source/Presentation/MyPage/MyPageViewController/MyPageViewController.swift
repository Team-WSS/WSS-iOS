//
//  MyPageViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/8/24.
//

import UIKit

import RxSwift
import RxRelay
import Then

final class MyPageViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: MyPageViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private var rootView = MyPageView()
    
    private lazy var settingButton = UIButton()
    
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
        
        preparationSetNavigationBar(title: "",
                                    left: nil,
                                    right: settingButton)
        setUI()
        rootView.scrollView.delegate = self
        bindViewModel()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showTabBar()
    }

    //MARK: - Bind
    
    private func bindViewModel() {
        self.rootView.headerView.bindData(data: MyProfileResult.dummyData)
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
        
        //        print(scrollOffset, " ", headerViewHeight)
        if scrollOffset >= headerViewHeight {
            rootView.scrolledStstickyHeaderView.isHidden = false
            rootView.mainStickyHeaderView.isHidden = true
            rootView.headerView.isHidden = true
            
            updateNavigationTitle(isShown: true)
            
        } else {
            rootView.scrolledStstickyHeaderView.isHidden = true
            rootView.mainStickyHeaderView.isHidden = false
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

