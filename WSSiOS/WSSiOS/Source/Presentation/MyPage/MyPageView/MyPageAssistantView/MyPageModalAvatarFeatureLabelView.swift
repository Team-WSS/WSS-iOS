//
//  MyPageCustomModalLabelView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/13/24.
//

import UIKit

import SnapKit
import Then

class MyPageModalAvatarFeatureLabelView: UIView {
    
    //MARK: - UI Components
    
    private var stackView = UIStackView()
    public var modalAvaterBadgeImageView = UIImageView()
    public var modalAvaterTitleLabel = UILabel()
    private let emptylabel1 = UILabel()
    private let emptylabel2 = UILabel()
    
    
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
    
    //MARK: - set UI
    
    private func setUI() {
        stackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 6
            $0.backgroundColor = .clear
            $0.layer.borderColor = UIColor.Gray100.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 26
            
            modalAvaterBadgeImageView.image = ImageLiterals.icon.Badge.HF
            
            modalAvaterTitleLabel.do {
                $0.text = "회귀자"
                $0.font = .HeadLine1
                $0.textColor = .Black
            }
        }
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(emptylabel1,
                                      modalAvaterBadgeImageView,
                                      modalAvaterTitleLabel,
                                      emptylabel2)
    }
    
    //MARK: - set Layout
    
    private func setLayout() {
        stackView.snp.makeConstraints() {
            $0.edges.equalToSuperview()
        }
        
        [emptylabel1, emptylabel2].forEach {
            $0.snp.makeConstraints() {
                $0.height.equalTo(52)
                $0.width.equalTo(10)
            }     
        }
    }
}
