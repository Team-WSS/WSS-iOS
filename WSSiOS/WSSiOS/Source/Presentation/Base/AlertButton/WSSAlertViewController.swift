//
//  TestViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 7/14/24.
//

import UIKit

import RxSwift
import RxCocoa

enum AlertButtonType {
    case left
    case right
}

final class WSSAlertViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    private var alertIconImage: UIImage?
    private var alertTitle: String?
    private var alertContent: String?
    private var leftTitle: String?
    private var rightTitle: String?
    private var rightBackgroundColor: CGColor?
    
    private var isDismissable: Bool
    
    private let leftButtonTapSubject = PublishSubject<Void>()
    var leftButtonTap: Observable<Void> {
        return leftButtonTapSubject.asObservable()
    }
    
    private let rightButtonTapSubject = PublishSubject<Void>()
    var rightButtonTap: Observable<Void> {
        return rightButtonTapSubject.asObservable()
    }
    
    //MARK: - UI Components
    
    var rootView = WSSAlertButtonView()
    
    // MARK: - Life Cycle
    
    init(iconImage: UIImage?,
         titleText: String?,
         contentText: String?,
         leftTitle: String?,
         rightTitle: String?,
         rightBackgroundColor: CGColor?,
         isDismissable: Bool) {
        
        self.alertIconImage = iconImage
        self.alertTitle = titleText
        self.alertContent = contentText
        self.leftTitle = leftTitle
        self.rightTitle = rightTitle
        self.rightBackgroundColor = rightBackgroundColor
        self.isDismissable = isDismissable
        
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
                              leftTitle: leftTitle,
                              rightTitle: rightTitle,
                              rightBackgroundColor: rightBackgroundColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindGesture()
    }
    
    private func bindGesture() {
        rootView.leftButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                print("\(String(describing: owner.leftTitle))Button Tap 💖")
                if owner.isDismissable {
                    owner.dismiss(animated: true, completion: {
                        owner.leftButtonTapSubject.onNext(())
                    })
                } else {
                    owner.leftButtonTapSubject.onNext(())
                }
            })
            .disposed(by: disposeBag)
        
        rootView.rightButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                print("\(String(describing: owner.rightTitle))Button Tap 💖")
                if owner.isDismissable {
                    owner.dismiss(animated: true, completion: {
                        owner.rightButtonTapSubject.onNext(())
                    })
                } else {
                    owner.rightButtonTapSubject.onNext(())
                }
            })
            .disposed(by: disposeBag)
    }
}

