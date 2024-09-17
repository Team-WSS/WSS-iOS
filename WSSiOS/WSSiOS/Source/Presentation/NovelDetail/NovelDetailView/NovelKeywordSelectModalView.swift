//
//  NovelKeywordSelectModalView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/17/24.
//

import UIKit

import SnapKit
import Then

final class NovelKeywordSelectModalView: UIView {
    
    //MARK: - Components
    
    let contentView = UIView()
    let closeButton = UIButton()
    private let titleLabel = UILabel()
    let novelKeywordSelectSearchBarView = NovelKeywordSelectSearchBarView()
    let novelKeywordSelectSearchResultView = NovelKeywordSelectSearchResultView()
    let resetButton = UIButton()
    private let resetButtonTitleView = UIView()
    private let resetImageView = UIImageView()
    private let resetLabel = UILabel()
    let selectButton = UIButton()
    private let selectLabel = UILabel()
    
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
        contentView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.layer.maskedCorners = [.layerMinXMinYCorner,
                                      .layerMaxXMinYCorner]
        }
        
        closeButton.do {
            $0.setImage(.icCacelModal, for: .normal)
        }
        
        titleLabel.do {
            $0.applyWSSFont(.title1, with: StringLiterals.NovelReview.KeywordSearch.keywordSelect)
            $0.textColor = .wssBlack
        }
        
        resetButton.do {
            $0.backgroundColor = .wssGray50
        }
        
        resetImageView.do {
            $0.image = .icReset
        }
        
        resetLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.NovelReview.KeywordSearch.reset)
            $0.textColor = .wssGray300
        }
        
        selectButton.do {
            $0.backgroundColor = .wssPrimary100
        }
        
        selectLabel.do {
            $0.textColor = .wssWhite
        }
    }
    
    private func setHierarchy() {
        self.addSubview(contentView)
        contentView.addSubviews(closeButton,
                                titleLabel,
                                novelKeywordSelectSearchBarView,
                                novelKeywordSelectSearchResultView,
                                resetButton,
                                selectButton)
        resetButton.addSubview(resetButtonTitleView)
        resetButtonTitleView.addSubviews(resetImageView,
                                         resetLabel)
        selectButton.addSubview(selectLabel)
    }
    
    private func setLayout() {
        contentView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height - 81)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(25)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(25)
        }
        
        novelKeywordSelectSearchBarView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }
        
        novelKeywordSelectSearchResultView.snp.makeConstraints {
            $0.top.equalTo(novelKeywordSelectSearchBarView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }
        
        resetButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.width.equalTo(133)
            $0.height.equalTo(62)
            
            resetButtonTitleView.snp.makeConstraints {
                $0.center.equalToSuperview()
                
                resetImageView.snp.makeConstraints {
                    $0.leading.centerY.equalToSuperview()
                    $0.size.equalTo(14)
                }
                
                resetLabel.snp.makeConstraints {
                    $0.top.trailing.bottom.equalToSuperview()
                    $0.leading.equalTo(resetImageView.snp.trailing).offset(4)
                }
            }
        }
        
        selectButton.snp.makeConstraints {
            $0.leading.equalTo(resetButton.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(62)
            
            selectLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
    
    //MARK: - Custom Method
    
    func showSearchResultView(show: Bool) {
        novelKeywordSelectSearchResultView.do {
            $0.isHidden = !show
        }
    }
    
    func updateSelectLabelText(keywordCount: Int) {
        selectLabel.do {
            $0.applyWSSFont(.title2, with: "\(keywordCount)개 선택")
        }
    }
}
