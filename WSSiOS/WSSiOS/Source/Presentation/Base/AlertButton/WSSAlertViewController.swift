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
    
    //MARK: - UI Components
    
    var rootView = WSSAlertButtonView()
    
    private var alertIconImage: UIImage?
    private var alertTitle: String?
    private var alertContent: String?
    private var cancelTitle: String?
    private var actionTitle: String?
    private var actionBackgroundColor: CGColor?
    
    // MARK: - Life Cycle
    
    init(iconImage: UIImage?,
         titleText: String?,
         contentText: String?,
         cancelButtonTitle: String?,
         actionButtonTitle: String?,
         actionButtonBackgroundColor: CGColor?) {
        
        self.alertIconImage = iconImage
        self.alertTitle = titleText
        self.alertContent = contentText
        self.cancelTitle = cancelButtonTitle
        self.actionTitle = actionButtonTitle
        self.actionBackgroundColor = actionButtonBackgroundColor
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
        rootView.do {
            $0.alertImageView.image = alertIconImage ?? UIImage()
            $0.alertTitleLabel.text = alertTitle ?? nil
            $0.alertContentLabel.text = alertContent ?? nil
            $0.cancelButtonEnable = cancelTitle ?? ""
            $0.actionButtonEnable.0 = actionTitle ?? ""
            $0.actionButtonEnable.1 = actionBackgroundColor ?? UIColor.clear.cgColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

