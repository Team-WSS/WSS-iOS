//
//  RecordHeaderAlignmentView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/12/24.
//

import UIKit

final class RecordHeaderAlignmentView: UIView {
    
    //MARK: - UI Components
    private let stackView = UIStackView()
    private let recordAlignmentLabel = UILabel()
    private let dropDownImageView = UIImageView()
    
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
            $0.spacing = 8
        }
        
        recordAlignmentLabel.do {
            $0.text = "최신순"
            $0.font = .Label1
            $0.textColor = .Gray300
        }
        
        dropDownImageView.do {
            $0.image = ImageLiterals.icon.dropDown
        }
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(recordAlignmentLabel,
                                      dropDownImageView)
    }
    
    //MARK: - set Layout
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
