//
//  MyPageEditAvatarViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 11/25/24.
//

import UIKit

import RxSwift
import RxGesture

final class MyPageEditAvatarViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    //    private let viewModel: MyPageEditCharacterViewModel
    
    //MARK: - Components
    
    private let rootView = MyPageEditAvatarView()
    
    // MARK: - Life Cycle
    
    //    init(viewModel: MyPageEditCharacterViewModel) {
    //
    //        self.viewModel = viewModel
    //        super.init(nibName: nil, bundle: nil)
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate()
        register()
    }
    
    //MARK: - Bind
    
    private func delegate() {
        self.rootView.avatarImageCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func register() {
        self.rootView.avatarImageCollectionView
            .register(MyPageEditAvatarCollectionViewCell.self, forCellWithReuseIdentifier: MyPageEditAvatarCollectionViewCell.cellIdentifier)
    }
}
