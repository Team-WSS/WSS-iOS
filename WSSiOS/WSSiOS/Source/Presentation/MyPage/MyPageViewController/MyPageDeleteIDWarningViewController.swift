//
//  MyPageDeleteIDWarningViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 7/24/24.
//

import UIKit

final class MyPageDeleteIDWarningViewController: UIViewController {
    
    //MARK: - Components
    
    private let rootView = MyPageDeleteIDWarningView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.bindData(count: UserNovelStatusResult(interestNovelCount: 1, watchingNovelCount: 100, watchedNovelCount: 333, quitNovelCount: 29))
    }
}
