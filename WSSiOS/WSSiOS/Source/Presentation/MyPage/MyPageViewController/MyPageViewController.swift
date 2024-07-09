//
//  MyPageViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 7/9/24.
//

import UIKit

import RxSwift
import RxRelay
import RxCocoa

final class MyPageViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: MyPageViewModel
    private var isMyPageRelay: BehaviorRelay<Bool>
    private var updateNavigationTitle = BehaviorRelay<Bool>(value: true)
    private var scrollOffsetRelay = BehaviorRelay<Double>(value: 0)
    
    //MARK: - UI Components
    
    private var rootView = MyPageView()
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        delegate()
        bindAction()
        bindViewModel()
    }
    
    //MARK: - Bind
    
    private func delegate() {
        rootView.scrollView.delegate = self
    }
    
    private func bindAction() {
        updateNavigationTitle
            .subscribe(with: self, onNext: { owner, isShown in
                self.navigationItem.title = isShown ? StringLiterals.Navigation.Title.myPage :  ""
            })

        rootView.headerView.layoutIfNeeded()
        let headerViewHeight = rootView.headerView.layer.frame.height
        
        scrollOffsetRelay
            .subscribe(with: self, onNext: { owner, isHeight in
                let isHiddenMainHeader = isHeight > headerViewHeight
                print(isHeight, " ", headerViewHeight )
                owner.rootView.scrolledStstickyHeaderView.isHidden = !isHiddenMainHeader
                owner.rootView.mainStickyHeaderView.isHidden = isHiddenMainHeader
                owner.rootView.headerView.isHidden = isHiddenMainHeader
                
                owner.updateNavigationTitle.accept(isHiddenMainHeader)
            })
    }
    
    private func bindViewModel() {
        let input = MyPageViewModel.Input(
            isMyPage: self.isMyPageRelay.asDriver()
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.isMyPage
            .drive(with: self, onNext: { owner, isMyPage  in
                owner.decideUI(isMyPage: isMyPage)
            })
            .disposed(by: disposeBag)
    }
}

extension MyPageViewController: UIScrollViewDelegate {
    
    //TODO: - headerViewHeight 초기값 0으로 잡히는 에러 수정
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y
        scrollOffsetRelay.accept(scrollOffset)
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
        
        if isMyPage {
        } else {
        }
    }
    
    private func setButton(isMyPage: Bool) -> UIButton {
        if isMyPage {
            lazy var settingButton = UIButton().then {
                $0.setImage(UIImage(resource: .setting), for: .normal)
            }
            return settingButton
            
        } else {
            
            //TODO: - 드롭다운 에러,,, 🥹
            lazy var dropdownButton = WSSDropdownButton().then {
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
