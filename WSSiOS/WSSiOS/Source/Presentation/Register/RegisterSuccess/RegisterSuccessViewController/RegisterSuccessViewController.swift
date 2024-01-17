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
    
    private let rootView = RegisterSuccessView()
    private let disposeBag = DisposeBag()
    
    private var userNovelId: Int
    
    // MARK: - View Life Cycle
    
    init(userNovelId: Int) {
        self.userNovelId = userNovelId
        super.init(nibName: nil, bundle: nil)
        print(userNovelId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
        self.view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindRx()
    }
    
    func bindRx() {
        rootView.makeMemoButton.rx.tap.subscribe(with: self, onNext: { owner, _ in
            owner.navigationController?.pushViewController(
                NovelDetailViewController(
                    repository: DefaultUserNovelRepository(
                        userNovelService: DefaultUserNovelService()),
                    userNovelId: self.userNovelId),
                animated: true)
        })
        .disposed(by: disposeBag)
        
        rootView.returnHomeButton.rx.tap.subscribe(with: self, onNext: { owner, _  in
            owner.navigationController?.popToRootViewController(animated: true)
        })
        .disposed(by: disposeBag)
    }
}
