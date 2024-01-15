//
//  DeletePopupViewController.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/14/24.
//

import UIKit

final class DeletePopupViewController: UIViewController {

    // MARK: - UI Components
    
    private let rootView = DeletePopupView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
