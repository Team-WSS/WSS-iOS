//
//  TermsAgreementViewController.swift
//  WSSiOS
//
//  Created by YunhakLee on 2/11/25.
//

import UIKit

import RxSwift

class TermsAgreementViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = ServiceTermAgreementView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
}
