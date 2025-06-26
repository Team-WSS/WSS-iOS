//
//  LibraryFilterAttractivePointView.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/26/25.
//

import UIKit

import SnapKit
import Then

final class LibraryFilterAttractivePointView: UIView {
    
    //MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let attractivePointOptionStackView = UIStackView()
    private let attractivePointOptionButtons = AttractivePoint.allCases.map {
        LibraryFilterAttractivePointOptionButton($0)
    }
    
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
        titleLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.MyLibrary.Filter.attractivePoint)
            $0.textColor = .wssBlack
        }
        
        attractivePointOptionStackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.distribution = .fillEqually
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         attractivePointOptionStackView)
        
        attractivePointOptionButtons.forEach {
            attractivePointOptionStackView.addArrangedSubview($0)
        }
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        
        attractivePointOptionStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
}
