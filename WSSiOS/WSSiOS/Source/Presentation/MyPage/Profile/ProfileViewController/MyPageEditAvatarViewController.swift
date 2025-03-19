//
//  MyPageEditAvatarViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 11/25/24.
//

import UIKit

import RxSwift

final class MyPageEditAvatarViewController: UIViewController{
    
    //MARK: - Properties
    
    private let viewModel: MyPageEditAvatarViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = MyPageEditAvatarView()
    
    // MARK: - Life Cycle
    
    init(viewModel: MyPageEditAvatarViewModel) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
        bindViewModel()
    }
    
    //MARK: - Delegate
    
    private func register() {
        self.rootView.avatarImageCollectionView
            .register(MyPageEditAvatarCollectionViewCell.self, forCellWithReuseIdentifier: MyPageEditAvatarCollectionViewCell.cellIdentifier)
    }
    
    //MARK: - Bind
    
    private func bindViewModel() {
        let input = MyPageEditAvatarViewModel.Input(
            avatarCellDidTap: rootView.avatarImageCollectionView.rx.itemSelected,
            changeButtonDidTap: rootView.changeButton.rx.tap,
            continueButtonDidTap: rootView.notChangeButton.rx.tap)
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.bindAvatarImageCell
            .bind(to: rootView.avatarImageCollectionView.rx.items(
                cellIdentifier: MyPageEditAvatarCollectionViewCell.cellIdentifier,
                cellType: MyPageEditAvatarCollectionViewCell.self)) { (row, data, cell) in
                    let (avatarImage, isRepresentive) = data
                    cell.bindData(avatarImage: avatarImage, isRepresentative: isRepresentive)
                }
                .disposed(by: disposeBag)
        
        output.bindAvatarImageCell
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, avatarList in
                let cellCount = avatarList.count
                owner.rootView.updateCollectionViewWidth(cellCount: cellCount)
            })
            .disposed(by: disposeBag)
        
        output.dismissModalViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.dismissModalViewController()
            })
            .disposed(by: disposeBag)
        
        output.updateAvatarData
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, data in
                let (avatarData, nickname) = data
                owner.rootView.bindData(avatar: avatarData, nickname: nickname)
            })
            .disposed(by: disposeBag)
    }
}
