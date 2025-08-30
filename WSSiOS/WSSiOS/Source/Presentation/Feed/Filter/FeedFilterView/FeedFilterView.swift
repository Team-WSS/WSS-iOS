//
//  FeedFilterView.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/26/25.
//

import UIKit

import SnapKit
import Then

final class FeedFilterView: UIView {
    
    //MARK: - UI Components
    
    private let contentView = UIView()
    private let titleLabel = UILabel()
    let dismissButton = UIButton()
    let genreView = FeedFilterGenreView()
    let visibilityView = FeedFilterVisiblityView()
    
    let bottomButton = UIButton()
    private let bottomButtonLabel = UILabel()
    
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
        contentView.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 16
            $0.layer.maskedCorners = [.layerMinXMinYCorner,
                                      .layerMaxXMinYCorner]
        }
        
        titleLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.Feed.Filter.title)
            $0.textColor = .wssGray200
        }
        
        dismissButton.setImage(.icCancelModal.withTintColor(.wssGray300),
                               for: .normal)
        
        bottomButton.do {
            $0.backgroundColor = .wssPrimary100
            $0.layer.cornerRadius = 14
            
            bottomButtonLabel.do {
                $0.applyWSSFont(.title1, with: StringLiterals.Feed.Filter.bottomButton)
                $0.textColor = .wssWhite
                $0.isUserInteractionEnabled = false
            }
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(contentView)
        contentView.addSubviews(titleLabel,
                                dismissButton,
                                genreView,
                                visibilityView,
                                bottomButton)
        bottomButton.addSubview(bottomButtonLabel)
    }
    
    private func setLayout() {
        contentView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.isSE ? 487 : 522)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        dismissButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.size.equalTo(65)
        }
        
        genreView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(22)
            $0.horizontalEdges.equalToSuperview()
        }
        
        visibilityView.snp.makeConstraints {
            $0.top.equalTo(genreView.snp.bottom).offset(36)
            $0.horizontalEdges.equalToSuperview()
        }
        
        bottomButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.height.equalTo(53)
            $0.horizontalEdges.equalToSuperview().inset(16)
            
            bottomButtonLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
}
