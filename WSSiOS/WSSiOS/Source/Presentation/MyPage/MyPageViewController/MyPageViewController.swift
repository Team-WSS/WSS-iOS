//
//  MyPageViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/8/24.
//

import UIKit

import RxSwift
import RxCocoa

class MyPageViewController: UIViewController {
    
    //MARK: - Set Properties
    
    //DummyData
    private let items = Observable.just([UIImage(named: "exampleAvater"),
                                         UIImage(named: "exampleAvater"),
                                         UIImage(named: "exampleAvater"),
                                         UIImage(named: "exampleAvater")])
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private var rootView = MyPageView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
        bind()
        delegate()
    }
    
    //MARK: - UI Components
    
    private func register() {
        rootView.myPageInventoryView.avaterCollectionView.register(MyPageInventoryCollectionViewCell.self, forCellWithReuseIdentifier: "MyPageInventoryCollectionViewCell")
        
    }
    
    //MARK: - Custom Method
    
    private func bind() {
        items.bind(to: rootView.myPageInventoryView.avaterCollectionView.rx.items(
            cellIdentifier: "MyPageInventoryCollectionViewCell",
            cellType: MyPageInventoryCollectionViewCell.self)) { (row, element, cell) in
                cell.avaterImageView.image = element
                
            }
            .disposed(by: disposeBag)
    }
    
    private func delegate() {
        rootView.myPageInventoryView.avaterCollectionView.rx.setDelegate(self) 
            .disposed(by: disposeBag)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        return CGSize(width: 84.0, height: 96.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
}
