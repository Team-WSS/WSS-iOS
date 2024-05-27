//
//  NormalSearchViewController.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/27/24.
//

import UIKit

import RxSwift
import RxCocoa
import Then

final class NormalSearchViewController: UIViewController {
    
    //MARK: - Properties
    
    
    //MARK: - Components
    
    private let rootView = NormalSearchView()
    
    //MARK: - Life Cycle

    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        registerCell()
        
        bindViewModel()
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.view.do {
            $0.backgroundColor = .White
        }
    }
    
    //MARK: - Bind
    
    private func registerCell() {
        
    }
    
    private func bindViewModel() {
        
    }
}
