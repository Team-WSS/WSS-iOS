//
//  LibraryViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/14/24.
//

import UIKit

import RxSwift
import RxCocoa

final class LibraryBaseViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let dummyData = libraryDummyData
    
    //MARK: - UI Components
    
    private var rootView = LibraryView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
        bindDataToLibraryCollectionView()
    }
    
    //MARK: - Custom TabBar
    
    private func register() {
        rootView.libraryCollectionView
            .register(LibraryCollectionViewCell.self,
                      forCellWithReuseIdentifier: "LibraryCollectionViewCell")
    }
    
    private func bindDataToLibraryCollectionView() {
        dummyData.bind(to: rootView.libraryCollectionView.rx.items(
            cellIdentifier: "LibraryCollectionViewCell",
            cellType: LibraryCollectionViewCell.self)) { (row, element, cell) in
                cell.novelImageView.image = element.Image
                cell.novelTitleLabel.text = element.title
                cell.novelAuthorLabel.text = element.author
                cell.novelRatingLabel.text = String(element.rating)
            }
            .disposed(by: disposeBag)
    }
}
