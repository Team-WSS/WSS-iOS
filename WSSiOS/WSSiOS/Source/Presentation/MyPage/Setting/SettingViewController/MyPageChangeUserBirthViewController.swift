//
//  MyPageChangeUserBirthViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 9/23/24.
//

import UIKit

import RxSwift

final class MyPageChangeUserBirthViewController: UIViewController {
    
    //MARK: - Properties

    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = MyPageChangeUserBirthView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    //MARK: - Bind
    

}
