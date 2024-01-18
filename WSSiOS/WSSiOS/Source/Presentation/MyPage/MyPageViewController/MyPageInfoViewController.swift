//
//  MyPageInfoViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/17/24.
//

import UIKit

import RxSwift

final class MyPageInfoViewController: UIViewController {

    //MARK: - Set Properties

    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    var rootView = MyPageInfoView()
    private let backButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNavigationBar()
    }
    
    //MARK: - Custom Method
    
    private func setUI() {
        backButton.do {
            $0.setImage(ImageLiterals.icon.navigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.rx.tap
                .subscribe(with: self, onNext: { owner, _ in 
                    owner.navigationController?.popViewController(animated: true)
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func setNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "계정정보 확인"
        
        if let navigationBar = self.navigationController?.navigationBar {
            let titleTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.Title2
            ]
            navigationBar.titleTextAttributes = titleTextAttributes
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
    }
    
}
