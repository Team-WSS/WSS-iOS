//
//  MyLibraryViewController.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/26/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class MyLibraryViewController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - Components
    
    let rootView = MyLibraryView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
