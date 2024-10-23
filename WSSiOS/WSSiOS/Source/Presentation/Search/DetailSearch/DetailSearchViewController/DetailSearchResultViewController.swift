//
//  DetailSearchResultViewController.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 10/23/24.
//

import UIKit

final class DetailSearchResultViewController: UIViewController {
    
    //MARK: - Properties

    
    //MARK: - Components
    
    private let rootView = DetailSearchResultView()
    
    //MARK: - Life Cycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
