//
//  FeedDetailUnknownUserErrorViewController.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 12/30/24.
//

import UIKit

import RxSwift

final class FeedDetailUnknownUserErrorViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let popFeedDetailViewControllerNotificationName = Notification.Name("PopFeedDetailViewControllerNotificationName")
    
    //MARK: - UI Components
    
    private let rootView = FeedDetailUnknownUserErrorView()
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindAction()
    }
    
    private func bindAction() {
        rootView.confirmationButton.rx.tap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                NotificationCenter.default.post(name: owner.popFeedDetailViewControllerNotificationName,
                                                object: nil)
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
