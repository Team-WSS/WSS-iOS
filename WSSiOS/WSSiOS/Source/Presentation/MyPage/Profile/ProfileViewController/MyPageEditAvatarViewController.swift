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
    private let viewModel: MyPageEditAvatarViewModel
    
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
        
        delegate()
        register()
        bindViewModel()
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
    
    private func bindViewModel() {
        
        let input = MyPageEditAvatarViewModel.Input(
            avatarCellDidTap: rootView.avatarImageCollectionView.rx.itemSelected,
            changeButtonDidTap: rootView.changeButton.rx.tap,
            continueButtonDidTap: rootView.notChangeButton.rx.tap)
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.bindAvatarCell
            .bind(to: rootView.avatarImageCollectionView.rx.items(
                cellIdentifier: MyPageEditAvatarCollectionViewCell.cellIdentifier,
                cellType: MyPageEditAvatarCollectionViewCell.self)) { row, element, cell in
                    cell.bindData(element)
            }
            .disposed(by: disposeBag)
        
        output.dismissModalViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.dismissModalViewController()
            })
            .disposed(by: disposeBag)
        
        output.updateAvatarData
            .bind(with: self, onNext: { owner, data in
                owner.rootView.bindData(data)
            })
            .disposed(by: disposeBag)
        
    }
}
//
//extension MyPageEditAvatarViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        guard let unwrappedText = text else {
//            return CGSize(width: 0, height: 0)
//        }
//        
//        let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 26
//        return CGSize(width: 50, height: 50)
//    }
//    
//    func 
//}
