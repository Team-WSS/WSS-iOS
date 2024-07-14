//
//  TestViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 7/14/24.
//

import UIKit

final class TestViewController: UIViewController {
    
    //MARK: - UI Components
    
    var rootView = UIView()
    private var alertViewController = WSSAlertViewController(iconImage: .icAlertWarningCircle,
                                                             titleText: "난 지원이얌",
                                                             contentText: "지원ㅇ지원지원이 지원지원 지운이 지원이지원\n지원이",
                                                             cancelButtonTitle: "취소",
                                                             actionButtonTitle: "차단",
                                                             actionButtonBackgroundColor: UIColor.wssSecondary100.cgColor)
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        
        self.present(alertViewController, animated: true)
    }
}
