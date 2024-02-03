//
//  File.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/12/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

/// 1-3-1 RegisterNormal View
final class RegisterSuccessViewController: UIViewController {
    
    // MARK: - Properties
    
    private var userNovelId: Int
    private let rootView = RegisterSuccessView()
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    init(userNovelId: Int) {
        self.userNovelId = userNovelId
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
        bindNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - UI
    
    func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Actions
    
    func bindNavigation() {
        rootView.makeMemoButton.rx.tap.subscribe(with: self, onNext: { owner, _ in
            let tabBar = WSSTabBarController()
            tabBar.selectedIndex = 1
            let navigationController = UINavigationController(rootViewController: tabBar)
            navigationController.setNavigationBarHidden(true, animated: true)
            self.view.window?.rootViewController = navigationController
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                NotificationCenter.default.post(name: NSNotification.Name("ShowNovelMemo"), object: self.userNovelId)
            }
        })
        .disposed(by: disposeBag)
        
        rootView.returnHomeButton.rx.tap.subscribe(with: self, onNext: { owner, _  in
            owner.navigationController?.popToRootViewController(animated: true)
        })
        .disposed(by: disposeBag)
    }
}
