//
//  LibraryViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/14/24.
//

import UIKit

import RxSwift
import RxCocoa

class LibraryViewController: UIViewController {
    
    //MARK: - Properties

    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components

    private var rootView = LibraryView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
    }
    
    private func setUI() {
       
    }
    
    //MARK: - Custom TabBar
    
    private func register() {
        rootView.libraryCollectionView
            .register(LibraryCollectionViewCell.self,
                      forCellWithReuseIdentifier: "LibraryCollectionViewCell")
    }
}
