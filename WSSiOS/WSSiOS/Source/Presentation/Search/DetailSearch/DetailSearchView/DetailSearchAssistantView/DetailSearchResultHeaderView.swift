//
//  DetailSearchResultHeaderView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 10/23/24.
//

import UIKit

final class DetailSearchResultHeaderView: UIView {
    
    //MARK: - UI Components
    
    private let backButton = UIButton()
    
    private let backgroundView = UIView()
    private let headerLabel = UILabel()
    private let controllerImageView = UIImageView()
    
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
    
    private func setUI() {
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal).withTintColor(.wssBlack), for: .normal)
        }
        
        backgroundView.do {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 14
            
            headerLabel.do {
                $0.applyWSSFont(.body4, with: "장르, 연재상태, 별점, 키워드 적용")
                $0.textColor = .wssGray200
            }
            
            controllerImageView.do {
                $0.image = .icController.withRenderingMode(.alwaysOriginal).withTintColor(.wssBlack)
            }
        }
    }
    
    private func setHierarchy() {
        backgroundView.addSubviews(headerLabel,
                                   controllerImageView)
        self.addSubviews(backButton,
                         backgroundView)
    }
    
    private func setLayout() {
        backButton.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(6)
        }
        
        backgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(backButton.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
            $0.bottom.equalToSuperview().inset(12)
            
            headerLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().inset(16)
            }
            
            controllerImageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().inset(20)
            }
        }
    }
}
