//
//  MyPageInfoViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/17/24.
//

import UIKit

import RxSwift
import Then

final class MyPageInfoViewController: UIViewController {

    //MARK: - Components
    
    private let disposeBag = DisposeBag()
    public let rootView = MyPageInfoView()
    private lazy var backButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.myPageInfo,
                                    left: self.backButton,
                                    right: nil)
        setUI()
    }
    
    //MARK: - UI
    
    private func setUI() {
        backButton.do {
            $0.setImage(ImageLiterals.icon.navigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.rx.tap
                .throttle(.seconds(3), scheduler: MainScheduler.instance)
                .subscribe(with: self, onNext: { owner, _ in 
                    owner.navigationController?.popViewController(animated: true)
                })
                .disposed(by: disposeBag)
        }
    }
}
