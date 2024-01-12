//
//  RecordDateView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/12/24.
//

import UIKit

import SnapKit
import Then

final class RecordDateView: UIView {
    
    //MARK: UI Components
    
    private let dateStackView = UIStackView()
    private let leftLine = UIView()
    private let rightLine = UIView()
    private let dateLabel = UILabel()
    
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
        dateStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        
        leftLine.do {
            $0.layer.borderWidth = 1.5
            $0.layer.borderColor = UIColor.Gray70.cgColor
        }
        
        rightLine.do {
            $0.layer.borderWidth = 1.5
            $0.layer.borderColor = UIColor.Gray70.cgColor
        }
        
        dateLabel.do {
            $0.text = "2023-12-23 오전 10:12"
            $0.font = .Label2
            $0.textColor = .Gray200
        }
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubview(dateStackView)
        
        dateStackView.addArrangedSubviews(leftLine,
                                          dateLabel,
                                          rightLine)
    }
    
    //MARK: - set Layout
    
    private func setLayout() {
        dateStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
