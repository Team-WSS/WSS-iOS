//
//  MemoCreateViewController.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/13/24.
//

import UIKit

final class MemoCreateViewController: UIViewController {

    // MARK: - UI Components

     private let rootView = MemoCreateView()

     // MARK: - Life Cycle

     override func loadView() {
         self.view = rootView
     }

     override func viewDidLoad() {
         super.viewDidLoad()
     }
}
