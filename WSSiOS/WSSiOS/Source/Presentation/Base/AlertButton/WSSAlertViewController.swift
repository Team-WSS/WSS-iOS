//
//  TestViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 7/14/24.
//

import UIKit

import RxSwift
import RxCocoa

final class WSSAlertViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    private var alertIconImage: UIImage?
    private var alertTitle: String?
    private var alertContent: String?
    private var cancelTitle: String?
    private var actionTitle: String?
    private var actionBackgroundColor: CGColor?
    
    private let actionButtonTapSubject = PublishSubject<Void>()
    var actionButtonTap: Observable<Void> {
        return actionButtonTapSubject.asObservable()
    }
    
    //MARK: - UI Components
    
    var rootView = WSSAlertButtonView()
    
    // MARK: - Life Cycle
    
    init(iconImage: UIImage?,
         titleText: String?,
         contentText: String?,
         cancelTitle: String?,
         actionTitle: String?,
         actionBackgroundColor: CGColor?) {
        
        self.alertIconImage = iconImage
        self.alertTitle = titleText
        self.alertContent = contentText
        self.cancelTitle = cancelTitle
        self.actionTitle = actionTitle
        self.actionBackgroundColor = actionBackgroundColor
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
        rootView.updateLayout(alertImage: alertIconImage,
                              alertTitle: alertTitle,
                              alertContent: alertContent,
                              cancelTitle: cancelTitle,
                              actionTitle: actionTitle,
                              actionBackgroundColor: actionBackgroundColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindGesture()
    }
    
    private func bindGesture() {
        rootView.cancelButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                print("\(String(describing: owner.cancelTitle))Button Tap 💖")
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.actionButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.actionButtonTapSubject.onNext(())
                print("\(String(describing: owner.actionTitle))Button Tap 💖")
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

