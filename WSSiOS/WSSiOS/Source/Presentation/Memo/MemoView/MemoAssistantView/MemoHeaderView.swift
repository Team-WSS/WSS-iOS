//
//  MemoHeaderView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/13/24.
//

import UIKit

import SnapKit
import Then
import UIImageViewAlignedSwift

final class MemoHeaderView: UIView {
    
    // MARK: - UI Components
    
    private let novelTitleLabel = UILabel()
    private let novelAuthorLabel = UILabel()
    private let novelCoverImageView = UIImageViewAligned()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - set UI
    
    private func setUI() {
        self.backgroundColor = .white
        
        novelTitleLabel.do {
            $0.textColor = .Black
            $0.font = .Title1
        }
        
        novelAuthorLabel.do {
            $0.textColor = .Gray200
            $0.font = .Body2
        }
        
        novelCoverImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 4
            $0.alignment = .top
        }
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(novelTitleLabel,
                         novelAuthorLabel,
                         novelCoverImageView)
    }
    
    // MARK: - set Layout
    
    private func setLayout() {
        novelTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(122)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(novelCoverImageView.snp.leading).offset(-18)
        }
        
        novelAuthorLabel.snp.makeConstraints {
            $0.top.equalTo(novelTitleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(novelCoverImageView.snp.leading).offset(-18)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        novelCoverImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(122)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(68)
            $0.height.equalTo(49)
        }
    }
    
    func bindData(novelTitle: String, novelAuthor: String, novelImage: String) {
        self.novelTitleLabel.text = novelTitle
        self.novelAuthorLabel.text = novelAuthor
        self.novelCoverImageView.kf.setImage(with: URL(string: novelImage))
    }
}
