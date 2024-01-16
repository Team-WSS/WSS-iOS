//
//  NovelDetailMemoSettingButtonView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/16/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailMemoSettingButtonView: UIView {
    
    // MARK: - UI Components
    
    public let backgroundView = UIView()
    private let containerView = UIView()
    private let dividerView = UIView()
    public let novelDeleteButton = UIButton()
    public let novelEditButon = UIButton()
    
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
            $0.layer.shadowColor = UIColor.Black.cgColor
            $0.layer.shadowOpacity = 0.11
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowRadius = 15
        }
        
        containerView.do {
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }
        
        dividerView.do {
            $0.backgroundColor = .Gray50
        }
        
        novelDeleteButton.do {
            $0.backgroundColor = .white
            $0.setButtonAttributedTitle(text: "작품을 서재에서 삭제", font: .Body2, color: .Black)
        }
        
        novelEditButon.do {
            $0.backgroundColor = .white
            $0.setButtonAttributedTitle(text: "작품 정보 수정", font: .Body2, color: .Black)
        }
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubview(backgroundView)
        self.backgroundView.addSubview(containerView)
        self.containerView.addSubviews(novelDeleteButton,
                                       novelEditButon,
                                       dividerView)
    }
    
    // MARK: - set Layout
    
    private func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(14)
            $0.trailing.equalToSuperview().inset(18)
        }
        
        novelDeleteButton.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.width.equalTo(193)
            $0.height.equalTo(51)
        }
        
        novelEditButon.snp.makeConstraints {
            $0.top.equalTo(novelDeleteButton.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.width.equalTo(193)
            $0.height.equalTo(51)
        }
        
        dividerView.snp.makeConstraints {
            $0.centerY.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.7)
        }
    }
}
