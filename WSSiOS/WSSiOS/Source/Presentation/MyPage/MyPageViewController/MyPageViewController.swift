//
//  MyPageViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/8/24.
//

import UIKit

import RxSwift
import RxCocoa

final class MyPageViewController: UIViewController {
    
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
        bindDataToMyPageCollectionView()
    }
    
    //MARK: - UI Components
    
    private func register() {
        rootView.myPageInventoryView.myPageAvaterCollectionView.register(MyPageInventoryCollectionViewCell.self, forCellWithReuseIdentifier: "MyPageInventoryCollectionViewCell")
        
        rootView.myPageSettingView.myPageSettingCollectionView.register(MyPageSettingCollectionViewCell.self, forCellWithReuseIdentifier: "MyPageSettingCollectionViewCell")
    }
    
    //MARK: - Custom Method
    
    private func bindDataToMyPageCollectionView() {
        items.bind(to: rootView.myPageInventoryView.myPageAvaterCollectionView.rx.items(
            cellIdentifier: "MyPageInventoryCollectionViewCell",
            cellType: MyPageInventoryCollectionViewCell.self)) { (row, element, cell) in
                cell.myPageAvaterImageView.image = element
            }
            .disposed(by: disposeBag)
        
        items2.bind(to: rootView.myPageSettingView.myPageSettingCollectionView.rx.items(
            cellIdentifier: "MyPageSettingCollectionViewCell",
            cellType: MyPageSettingCollectionViewCell.self)) { (row, element, cell) in
                cell.myPageSettingCellLabel.text = element
            }
            .disposed(by: disposeBag)
    }
}
