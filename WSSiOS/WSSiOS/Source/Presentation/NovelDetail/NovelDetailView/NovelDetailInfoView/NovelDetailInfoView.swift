//
//  NovelDetailInfoView.swift
//  WSSiOS
//
//  Created by 이윤학 on 6/23/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoView: UIView {
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    let descriptionSection = NovelDetailInfoDescriptionSection()
    
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
        self.backgroundColor = .wssGray50
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
        }
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(descriptionSection)
    }
    
    private func setLayout() {
        stackView.do {
            $0.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.bottom.equalToSuperview().inset(1)
                $0.horizontalEdges.equalToSuperview()
            }
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailInfoResult) {
        descriptionSection.bindData(data)
    }
}
