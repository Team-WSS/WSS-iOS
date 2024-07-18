//
//  DetailSearchView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/18/24.
//

import UIKit

import SnapKit
import Then

final class DetailSearchView: UIView {
    
    //MARK: - UI Components
    
    private let backgroundView = UIView()
    let cancelModalButton = UIButton()
    
    /// 정보
    let detailSearchInfoView = DetailSearchInfoView()
    
    /// 하단 버튼
    private let bottomStackView = UIStackView()
    
    let reloadButtonView = UIView()
    private let reloadImageView = UIImageView()
    private let reloadButtonLabel = UILabel()
    
    let searchButtonView = UIView()
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
        self.backgroundColor = .black.withAlphaComponent(0.6)
        
        backgroundView.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 15
            $0.clipsToBounds = true
        }
        
        cancelModalButton.do {
            $0.setImage(.icCacelModal.withRenderingMode(.alwaysOriginal).withTintColor(.wssGray300), for: .normal)
        }
        
        bottomStackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
        }
        
        reloadButtonView.do {
            $0.backgroundColor = .wssGray50
        }
        
        reloadImageView.do {
            $0.image = .icReload.withRenderingMode(.alwaysOriginal).withTintColor(.wssGray300)
            $0.contentMode = .scaleAspectFit
        }
        
        reloadButtonLabel.do {
            $0.applyWSSFont(.title2, with: "초기화")
            $0.textColor = .wssGray300
        }
        
        searchButtonView.do {
            $0.backgroundColor = .wssPrimary100
        }
        
        searchButtonLabel.do {
            $0.applyWSSFont(.title2, with: "작품 찾기")
            $0.textColor = .wssWhite
        }
    }
    
    private func setHierarchy() {
        reloadButtonView.addSubviews(reloadImageView,
                                     reloadButtonLabel)
        searchButtonView.addSubview(searchButtonLabel)
        bottomStackView.addArrangedSubviews(reloadButtonView
                                            ,searchButtonView)
        backgroundView.addSubviews(cancelModalButton,
                                   detailSearchInfoView,
                                   bottomStackView)
        self.addSubviews(backgroundView)
    }
    
    private func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(82)
            $0.leading.trailing.bottom.equalToSuperview()
            
            cancelModalButton.snp.makeConstraints {
                $0.size.equalTo(25)
                $0.top.trailing.equalToSuperview().inset(20)
            }
            
            detailSearchInfoView.snp.makeConstraints {
                $0.top.equalToSuperview().inset(97)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(136)
            }
        }
        
        bottomStackView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(62)
            
            reloadButtonView.snp.makeConstraints {
                $0.width.equalTo(133)
                
                reloadImageView.snp.makeConstraints {
                    $0.top.equalToSuperview().inset(24)
                    $0.leading.equalToSuperview().inset(37)
                    $0.size.equalTo(14)
                }
                
                reloadButtonLabel.snp.makeConstraints {
                    $0.top.equalToSuperview().inset(20)
                    $0.leading.equalTo(reloadImageView.snp.trailing).offset(4)
                }
            }
            
            searchButtonView.snp.makeConstraints {
                $0.width.equalTo(UIScreen.main.bounds.width - 133)
                
                searchButtonLabel.snp.makeConstraints {
                    $0.center.equalToSuperview()
                }
            }
        }
    }
}
