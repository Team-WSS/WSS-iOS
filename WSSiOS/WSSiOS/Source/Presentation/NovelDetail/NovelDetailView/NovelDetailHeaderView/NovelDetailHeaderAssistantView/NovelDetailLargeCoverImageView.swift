//
//  NovelDetailLargeCoverImageView.swift
//  WSSiOS
//
//  Created by 이윤학 on 6/12/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailLargeCoverImageButton: UIButton {
    
    //MARK: - Components
    
    private let novelCoverImageView = UIImageView()
    let dismissButton = UIButton()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .wssBlack60
        }
        
        novelCoverImageView.do {
            $0.image = .imgLoadingThumbnail
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 14
            $0.isUserInteractionEnabled = true
        }
        
        dismissButton.do {
            $0.setImage(.icCacelModal.withTintColor(.wssWhite,
                                                      renderingMode: .alwaysOriginal),
                        for: .normal)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(novelCoverImageView,
                        dismissButton)
    }
    
    private func setLayout() {
        novelCoverImageView.snp.makeConstraints {
            $0.width.lessThanOrEqualToSuperview().inset(20)
            $0.height.lessThanOrEqualToSuperview().inset(60)
            $0.center.equalToSuperview()
        }
        
        dismissButton.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(-44)
            $0.trailing.equalToSuperview().inset(12)
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailHeaderResult) {
        novelCoverImageView.image = UIImage(named: data.novelImage)
    }
}
