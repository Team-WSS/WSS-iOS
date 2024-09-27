//
//  LoginCLoginbannerCollectionViewCellell.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/18/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class LoginbannerCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UI Components
    
    private let bannerImageView = UIImageView()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        bannerImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
        }
    }
    
    private func setHierarchy() {
        contentView.addSubview(bannerImageView)
    }
    
    private func setLayout() {
        bannerImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bindData(image: nil)
      }
    
    func bindData(image: UIImage?) {
        bannerImageView.image = image
    }
}
