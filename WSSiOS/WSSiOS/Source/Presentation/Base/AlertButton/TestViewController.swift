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
                          titleText: "안녕하세요?",
                          contentText: "차단하면 서로의 피드, 댓글, 프로필을 볼 수 없어요",
                          cancelButtonTitle: "취소",
                          actionButtonTitle: "확인",
                          actionButtonBackgroundColor: UIColor.wssSecondary100.cgColor)
    }
}
