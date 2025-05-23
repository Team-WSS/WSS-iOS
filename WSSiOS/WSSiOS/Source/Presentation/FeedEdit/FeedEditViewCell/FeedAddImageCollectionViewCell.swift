//
//  FeedAddImageCollectionViewCell.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/13/25.
//

import UIKit

import SnapKit
import Then
import RxSwift

protocol FeedAddImageCollectionDelegate: AnyObject {
    func cancelButtonDidTap()
}

final class FeedAddImageCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    weak var delegate: FeedAddImageCollectionDelegate?
    
    //MARK: - Components
    
    private let feedImageView = UIImageView()
    private let cancelButton = UIButton()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
        
        bindAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        feedImageView.do {
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }
        
        cancelButton.do {
            $0.setImage(.icCancel, for: .normal)
        }
    }
    
    private func setHierarchy() {
        self.addSubview(feedImageView)
        feedImageView.addSubview(cancelButton)
    }
    
    private func setLayout() {
        feedImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.size.equalTo(38)
            $0.top.trailing.equalToSuperview()
        }
    }
    
    //MARK: - Bind
    
    private func bindAction() {
        cancelButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.delegate?.cancelButtonDidTap()
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Data
    
    func bindData(image: UIImage) {
        feedImageView.image = image
    }
}
