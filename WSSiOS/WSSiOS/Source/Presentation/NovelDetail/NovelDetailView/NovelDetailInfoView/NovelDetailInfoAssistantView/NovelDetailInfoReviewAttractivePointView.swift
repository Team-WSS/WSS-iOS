//
//  NovelDetailInfoReviewAttractivePointView.swift
//  WSSiOS
//
//  Created by 이윤학 on 7/3/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoReviewAttractivePointView: UIView {
    
    //MARK: - UI Components
    
    private let attractivePointBackgroundView = UIView()
    private let attractivePointStackView = UIStackView()
    private let attractivePointLabel = UILabel()
    private let attractivePointDescriptionLabel = UILabel()
    
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
        attractivePointBackgroundView.do {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 12
        }
        
        attractivePointStackView.do {
            $0.axis = .horizontal
        }
        
        attractivePointDescriptionLabel.do {
            $0.font = .Title3
            $0.applyWSSFont(.title3, with: StringLiterals.NovelDetail.Info.attractivePointDescription)
            $0.textColor = .wssBlack
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(attractivePointBackgroundView)
        attractivePointBackgroundView.addSubviews(attractivePointStackView)
        attractivePointStackView.addArrangedSubviews(attractivePointLabel,
                                                      attractivePointDescriptionLabel)
    }
    
    private func setLayout() {
        attractivePointBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(55)
        }
        
        attractivePointStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailInfoResult) {
        var attractivePoints = data.attractivePoints.reduce("") {
            return "\($0), \($1)"
        }
        attractivePoints.removeFirst(2)
        setAttractivePointLabelText(with: attractivePoints)
    }
    
    //MARK: - Custom Method
    
    private func setAttractivePointLabelText(with text: String) {
        attractivePointLabel.do {
            $0.font = .Title3
            $0.applyWSSFont(.title3, with: text)
            $0.textColor = .wssPrimary100
        }
    }
}
