//
//  OnboardingSuccessViewController.swift
//  WSSiOS
//
//  Created by YunhakLee on 10/4/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then
 
final class OnboardingSuccessViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = OnboardingSuccessView()
    private let disposeBag = DisposeBag()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
