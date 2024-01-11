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
    private let items2 = Observable.just(["계정정보 확인",
                                          "로그아웃",
                                          "웹소소 인스타 보러가기",
                                          "서비스 이용약관"])
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
        
        rootView.myPageSettingView.myPageSettingCollectionView.register(MyPageSettingCollectionViewCell.self, forCellWithReuseIdentifier: "MyPageSettingCollectionViewCell")
    }
    
    //MARK: - Custom Method
    
    private func bind() {
        items.bind(to: rootView.myPageInventoryView.avaterCollectionView.rx.items(
            cellIdentifier: "MyPageInventoryCollectionViewCell",
            cellType: MyPageInventoryCollectionViewCell.self)) { (row, element, cell) in
                cell.avaterImageView.image = element
            }
            .disposed(by: disposeBag)
        
        items2.bind(to: rootView.myPageSettingView.myPageSettingCollectionView.rx.items(
            cellIdentifier: "MyPageSettingCollectionViewCell",
            cellType: MyPageSettingCollectionViewCell.self)) { (row, element, cell) in
                cell.myPageSettingCellLabel.text = element
            }
            .disposed(by: disposeBag)
    }
    
    private func delegate() {
        rootView.myPageInventoryView.avaterCollectionView.rx.setDelegate(self) 
            .disposed(by: disposeBag)
        
        rootView.myPageSettingView.myPageSettingCollectionView.rx.setDelegate(self) 
            .disposed(by: disposeBag)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case rootView.myPageInventoryView.avaterCollectionView:
            return CGSize(width: 84.0, height: 96.0)
        case rootView.myPageSettingView.myPageSettingCollectionView:
            return CGSize(width: super.view.bounds.width, height: 64.0)
        default:
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        switch collectionView {
        case rootView.myPageInventoryView.avaterCollectionView:
            return 0.0
        case rootView.myPageSettingView.myPageSettingCollectionView:
            return 1.0
        default:
            return 0.0
        }
    }
}
