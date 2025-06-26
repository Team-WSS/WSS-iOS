//
//  LibraryFilterViewController.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/26/25.
//

import UIKit

import RxCocoa
import RxSwift
import RxRelay
import SnapKit
import Then

final class LibraryFilterViewController: UIViewController {
    
    //MARK: - Components
    
    let rootView = LibraryFilterView()
    
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
