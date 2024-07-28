//
//  MyPageViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 7/9/24.
//

import UIKit

import RxSwift
import RxCocoa

final class MyPageViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: MyPageViewModel
    
    private var isMyPageRelay: BehaviorRelay<Bool>
    private let headerViewHeightRelay = BehaviorRelay<Double>(value: 0)
    
    //MARK: - UI Components
    
    private var rootView = MyPageView()
    
    private lazy var settingButton = UIButton()
    private lazy var dropdownButton = WSSDropdownButton()
    
    // MARK: - Life Cycle
    
    init(viewModel: MyPageViewModel, isMyPage: Bool) {
        self.viewModel = viewModel
        self.isMyPageRelay = BehaviorRelay(value: isMyPage)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
        
        decideUI(isMyPage: isMyPageRelay.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerViewHeightRelay.accept(rootView.headerView.layer.frame.height)
    }

    //MARK: - Bind
    
    private func bindViewModel() {
        let input = MyPageViewModel.Input(
            isMyPage: isMyPageRelay.asDriver(),
            headerViewHeight: headerViewHeightRelay.asDriver(),
            scrollOffset: rootView.scrollView.rx.contentOffset.asDriver(),
            settingButtonDidTap: settingButton.rx.tap,
            dropdownButtonDidTap: dropdownButton.rx.tap)
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        output.profileData
            .bind(with: self, onNext: { owner, data in
                owner.rootView.headerView.bindData(data: data)
            })
            .disposed(by: disposeBag)
        
        output.updateNavigationEnabled
            .asDriver()
            .drive(with: self, onNext: { owner, update in 
                owner.rootView.scrolledStstickyHeaderView.isHidden = !update
                owner.rootView.mainStickyHeaderView.isHidden = update
                owner.rootView.headerView.isHidden = update
                
                if update {
                    owner.navigationItem.title = StringLiterals.Navigation.Title.myPage
                } else {
                    owner.navigationItem.title = ""
                }
            })
            .disposed(by: disposeBag)
    }
}

extension MyPageViewController {
    
    //MARK: - UI
    
    private func decideUI(isMyPage: Bool) {
        let button = setButton(isMyPage: isMyPage)
        
        //TODO: - 타인 프로필도 타이틀이 마이페이지인지 확인해야 함
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.myPage,
                                    left: nil,
                                    right: button)
        
        rootView.headerView.userImageChangeButton.isHidden = !isMyPage
    }
    
    private func setButton(isMyPage: Bool) -> UIButton {
        if isMyPage {
            settingButton.do {
                $0.setImage(UIImage(resource: .icSetting), for: .normal)
            }
            return settingButton
            
        } else {
            
            //TODO: - 드롭다운 에러,,, 🥹
            dropdownButton.do {
                $0.makeDropdown(dropdownRootView: self.view,
                                dropdownWidth: 120,
                                dropdownData: ["차단하기"],
                                textColor: .wssBlack)
            }
            self.view.addSubview(dropdownButton)
            dropdownButton.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(10)
                $0.size.equalTo(44)
            }
            return dropdownButton
        }
    }
}
