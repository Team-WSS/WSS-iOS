//
//  RecordViewController.swift
//  WSSiOS
//
//  Created by 최서연 on 1/12/24.
//

import UIKit

final class RecordViewController: UIViewController {
    
    private let rootView = RecordResultView()
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNavigationBar()
    }
    
    private func setUI() {
        self.view.do {
            $0.backgroundColor = .White
        }
    }
    
    private func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.title = "내 기록"
        
        // Navigation Bar의 title 폰트 설정
        if let navigationBar = self.navigationController?.navigationBar {
            let titleTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.Title2
            ]
            navigationBar.titleTextAttributes = titleTextAttributes
        }
    }
}
