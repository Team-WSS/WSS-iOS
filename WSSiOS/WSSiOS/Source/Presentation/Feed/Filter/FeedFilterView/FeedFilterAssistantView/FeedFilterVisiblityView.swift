//
//  FeedFilterVisiblityView.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/26/25.
//

import UIKit

import SnapKit
import Then

final class FeedFilterVisiblityView: UIView {
    
    //MARK: - UI Components
    
    private let titleLabel = UILabel()
    let publicOptionView = FeedFilterVisibilityOptionView(.public)
    let privateOptionView = FeedFilterVisibilityOptionView(.private)
    
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
            $0.applyWSSFont(.title2, with: StringLiterals.Feed.Filter.visibliltyOption)
            $0.textColor = .wssBlack
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         publicOptionView,
                         privateOptionView)
        
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        
        publicOptionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
        }
        
        privateOptionView.snp.makeConstraints {
            $0.top.equalTo(publicOptionView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func updateVisibilityOptionButtons(selectedOptions: [FeedVisibilityOption]) {
        publicOptionView.updateButton(selectedOptions: selectedOptions)
        privateOptionView.updateButton(selectedOptions: selectedOptions)
    }
}
