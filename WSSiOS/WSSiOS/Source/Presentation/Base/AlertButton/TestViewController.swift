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
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        AlertBuilder(viewController: self)
            .setAlertView(iconImageView: UIImageView(image: .icAlertWarningCircle),
                          titleText: "안ㄴㅇ?",
                          contetnText: "방갑수다",
                          cancelButtonTitle: "ㅎㅇ",
                          actionButtonTitle: "취소",
                          actionButtonBackgroundColor: UIColor.wssSecondary100.cgColor)
    }
}
