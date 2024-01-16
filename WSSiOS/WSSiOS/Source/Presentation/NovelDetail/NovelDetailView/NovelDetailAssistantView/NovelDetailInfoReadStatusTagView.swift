//
//  NovelDetailInfoReadStatusTagView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/12/24.
//

import UIKit

import SnapKit
import Then


final class NovelDetailInfoReadStatusTagView: UIView {
    
    //MARK: - set Properties
    
    var readStatus: ReadStatus?
    
    // MARK: - UI Components
    
    private let tagImageView = UIImageView()
    private let tagLabel = UILabel()
    
    
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
        self.do {
            $0.layer.borderColor = UIColor.Primary100.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 18.5
        }
        
        tagImageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        tagLabel.do {
            $0.textColor = .Primary100
            $0.font = .Body2
        }
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(tagImageView,
                         tagLabel)
    }
    
    // MARK: - set Layout
    
    private func setLayout() {
        tagImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10.5)
            $0.leading.equalToSuperview().inset(13)
            $0.size.equalTo(16)
        }
        
        tagLabel.snp.makeConstraints {
            $0.centerY.equalTo(tagImageView.snp.centerY)
            $0.leading.equalTo(tagImageView.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().inset(13)
        }
    }
    
    func bindData(_ status: ReadStatus) {
        self.tagImageView.image = status.tagImage
        self.tagLabel.text = status.tagText
    }
}
