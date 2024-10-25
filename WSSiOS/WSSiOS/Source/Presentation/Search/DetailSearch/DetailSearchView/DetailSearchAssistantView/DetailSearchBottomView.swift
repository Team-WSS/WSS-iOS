//
//  DetailSearchBottomView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/19/24.
//

import UIKit

import SnapKit
import Then

final class DetailSearchBottomView: UIView {
    
    //MARK: - UI Components
    
    private let bottomStackView = UIStackView()
    
    let resetButton = UIButton()
    private let resetImageView = UIImageView()
    private let resetButtonLabel = UILabel()
    
    let searchButton = UIButton()
    private let searchButtonLabel = UILabel()
    
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
        bottomStackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
        }
        
        resetButton.do {
            $0.backgroundColor = .wssGray50
        }
        
        resetImageView.do {
            $0.image = .icReload.withRenderingMode(.alwaysOriginal).withTintColor(.wssGray300)
            $0.contentMode = .scaleAspectFit
        }
        
        resetButtonLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.DetailSearch.reload)
            $0.textColor = .wssGray300
        }
        
        searchButton.do {
            $0.backgroundColor = .wssPrimary100
        }
        
        searchButtonLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.DetailSearch.searchNovel)
            $0.textColor = .wssWhite
        }
    }
    
    private func setHierarchy() {
        resetButton.addSubviews(resetImageView,
                                resetButtonLabel)
        searchButton.addSubview(searchButtonLabel)
        bottomStackView.addArrangedSubviews(resetButton,
                                            searchButton)
        self.addSubview(bottomStackView)
    }
    
    private func setLayout() {
        bottomStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(62)
            
            resetButton.snp.makeConstraints {
                $0.width.equalTo(133)
                
                resetImageView.snp.makeConstraints {
                    $0.top.equalToSuperview().inset(24)
                    $0.leading.equalToSuperview().inset(37)
                    $0.size.equalTo(14)
                }
                
                resetButtonLabel.snp.makeConstraints {
                    $0.top.equalToSuperview().inset(20)
                    $0.leading.equalTo(resetImageView.snp.trailing).offset(4)
                }
            }
            
            searchButton.snp.makeConstraints {
                $0.width.equalTo(UIScreen.main.bounds.width - 133)
                
                searchButtonLabel.snp.makeConstraints {
                    $0.center.equalToSuperview()
                }
            }
        }
    }
}
