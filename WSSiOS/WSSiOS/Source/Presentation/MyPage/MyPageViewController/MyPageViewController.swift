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
    
    //MARK: - UI Components
    
    private var rootView = MyPageView()
    private let dropdownView = WSSDropdownButton()
    
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
        bindViewModel()
    }
    
    //MARK: - Bind
    
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

extension MyPageViewController {
    
    //MARK: - UI
    
    private func decideUI(isMyPage: Bool) {
        let button = setButton(isMyPage: isMyPage)
        preparationSetNavigationBar(title: "",
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
            lazy var dropdownButton = UIButton().then {
                $0.setImage(UIImage(resource: .badgeLogo), for: .normal)
            }
            return dropdownButton
        }
    }
}
