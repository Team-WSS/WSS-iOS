//
//  HomeCharacterTagView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/10/24.
//

import UIKit

final class HomeCharacterTagView: UIView {
    
    //MARK: - UI Components
    
    private let tagLabel = UILabel()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - set UI
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .Primary50
            $0.layer.cornerRadius = 15
        }
        
        tagLabel.do {
            $0.text = "지나친 지원이는 못말려요"
            $0.font = .Title3
            $0.textColor = .Primary100
        }
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubview(tagLabel)
    }
    
    //MARK: - set Layout
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(tagLabel.snp.width).offset(26)
            $0.height.equalTo(tagLabel.snp.height).offset(16)
        }
        
        tagLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
