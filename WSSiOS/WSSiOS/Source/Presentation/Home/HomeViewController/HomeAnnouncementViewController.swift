//
//  HomeAnnouncementViewController.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/12/24.
//

import UIKit

final class HomeAnnouncementViewController: UIViewController {
    
    //MARK: - Properties

    
    //MARK: - UI Components
    
    private let rootView = HomeAnnouncementView()
    
    //MARK: - Life Cycle


    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // setUI()
    }
    
    private func setUI() {
        
    }

}
