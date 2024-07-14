//
//  AlertBuilder.swift
//  WSSiOS
//
//  Created by 신지원 on 7/14/24.
//

import UIKit

class AlertBuilder {
    
    private var rootViewController = UIViewController()
    private let alertViewController = WSSAlertViewController()
    
    private var alertIconImageView: UIImageView?
    private var alertTitle: String?
    private var alertContent: String?
    private var cancelTitle: String?
    private var actionTitle: String?
    private var actionBackgroundColor: CGColor?
    
    init(viewController: UIViewController) {
        rootViewController = viewController
    }
    
    func setAlertView(iconImageView: UIImageView,
                      titleText: String,
                      contetnText: String,
                      cancelButtonTitle: String,
                      actionButtonTitle: String,
                      actionButtonBackgroundColor: CGColor) -> AlertBuilder {
        
        show(iconImageView: iconImageView,
             titleText: titleText,
             contetnText: contetnText,
             cancelButtonTitle: cancelButtonTitle,
             actionButtonTitle: actionButtonTitle,
             actionButtonBackgroundColor: actionButtonBackgroundColor)
        
        return self
    }
    
    private func show(iconImageView: UIImageView,
              titleText: String,
              contetnText: String,
              cancelButtonTitle: String,
              actionButtonTitle: String,
              actionButtonBackgroundColor: CGColor) -> Self {
        
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        
        alertViewController.rootView.do {
            if alertIconImageView == nil {
                $0.alertImageView.isHidden = true
            } else {
                $0.alertImageView = alertIconImageView!
            }
            
            if alertTitle == nil {
                $0.alertTitleLabel.isHidden = true
            } else {
                $0.alertTitleLabel.text = alertTitle
            }
            
            if alertContent == nil {
                $0.alertContentLabel.isHidden = true
            } else {
                $0.alertContentLabel.text = alertContent
            }
            
            if cancelTitle == nil {
                $0.cancelButton.isHidden = true
            } else {
                $0.cancelButton.setTitle(cancelTitle, for: .normal)
            }
            
            if actionTitle == nil {
                $0.actionButton.isHidden = true
            } else {
                $0.actionButton.setTitle(actionTitle, for: .normal)
                $0.actionButton.layer.backgroundColor = actionBackgroundColor
            }
        }
        
        rootViewController.present(alertViewController, animated: true)
        return self
    }
}
