//
//  AlertBuilder.swift
//  WSSiOS
//
//  Created by 신지원 on 7/14/24.
//

import UIKit

class AlertBuilder {
    
    private var rootViewController = UIViewController()
    private let alertViewController = TestViewController()
    
    private var alertIconImageView: UIImageView?
    private var alertTitle: String?
    private var alertContent: String?
    private var cancelTitle: String?
    private var actionTitle: String?
    private var actionBackgroundColor: CGColor?
    
    init(viewController: UIViewController) {
        rootViewController = viewController
    }
    
    func setIconImageView(_ image: UIImageView) -> AlertBuilder {
        alertIconImageView = image
        return self
    }
    
    func setTitle(_ text: String) -> AlertBuilder {
        alertTitle = text
        return self
    }
    
    func setContent(_ text: String) -> AlertBuilder {
        alertContent = text
        return self
    }
    
    func setCancelTitle(_ text: String) -> AlertBuilder {
        cancelTitle = text
        return self
    }
    
    func setActionTitle(_ text: String) -> AlertBuilder {
        actionTitle = text
        return self
    }
    
    func setActionColor(_ color: CGColor) -> AlertBuilder {
        actionBackgroundColor = color
        return self
    }
    
    func show() -> Self {
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
