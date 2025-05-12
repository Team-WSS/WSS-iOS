//
//  FeedDetailUnknownFeedErrorViewController.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 12/30/24.
//

import UIKit

import RxSwift

final class FeedDetailUnknownFeedErrorViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
   
    //MARK: - UI Components
    
    private let rootView = FeedDetailUnknownFeedErrorView()
    
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
                NotificationCenter.default.post(name: NotificationName.popFeedDetailViewController,
                                                object: nil)
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
