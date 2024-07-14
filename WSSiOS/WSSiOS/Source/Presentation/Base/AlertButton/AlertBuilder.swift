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
    
    func setAlertView(iconImageView: UIImageView?,
                      titleText: String?,
                      contentText: String?,
                      cancelButtonTitle: String?,
                      actionButtonTitle: String?,
                      actionButtonBackgroundColor: CGColor?) -> AlertBuilder {
        
        self.alertIconImageView = iconImageView
        self.alertTitle = titleText
        self.alertContent = contentText
        self.cancelTitle = cancelButtonTitle
        self.actionTitle = actionButtonTitle
        self.actionBackgroundColor = actionButtonBackgroundColor
        
        show()
        
        return self
    }
    
    private func show() {
        
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        
        if let iconImageView = alertIconImageView {
            alertViewController.rootView.alertImageView.image = iconImageView.image
            alertViewController.rootView.alertImageView.isHidden = false
        } else {
            alertViewController.rootView.alertImageView.isHidden = true
        }
        
        if let title = alertTitle {
            alertViewController.rootView.alertTitleLabel.text = title
            alertViewController.rootView.alertTitleLabel.isHidden = false
        } else {
            alertViewController.rootView.alertTitleLabel.isHidden = true
        }
        
        if let content = alertContent {
            alertViewController.rootView.alertContentLabel.text = content
            alertViewController.rootView.alertContentLabel.isHidden = false
        } else {
            alertViewController.rootView.alertContentLabel.isHidden = true
        }
        
        if let cancelTitle = cancelTitle {
            alertViewController.rootView.cancelButton.setTitle(cancelTitle, for: .normal)
            alertViewController.rootView.cancelButton.isHidden = false
        } else {
            alertViewController.rootView.cancelButton.isHidden = true
        }
        
        if let actionTitle = actionTitle {
            alertViewController.rootView.actionButton.setTitle(actionTitle, for: .normal)
            if let bgColor = actionBackgroundColor {
                alertViewController.rootView.actionButton.layer.backgroundColor = bgColor
            }
            alertViewController.rootView.actionButton.isHidden = false
        } else {
            alertViewController.rootView.actionButton.isHidden = true
        }
        
        rootViewController.present(alertViewController, animated: true)
    }
}
