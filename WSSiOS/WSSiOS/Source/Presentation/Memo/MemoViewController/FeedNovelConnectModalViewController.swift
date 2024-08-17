//
//  FeedNovelConnectModalViewController.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 8/17/24.
//

import UIKit

import RxSwift
import RxCocoa

final class FeedNovelConnectModalViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = FeedNovelConnectModalView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindAction()
    }
    
    //MARK: - Bind
    
    private func bindAction() {
        rootView.closeButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
