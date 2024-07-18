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
    
    let detailSearchHeaderView = DetailSearchHeaderView()
    let detailSearchInfoView = DetailSearchInfoView()
    let detailSearchBottomView = DetailSearchBottomView()
    
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
    }
    
    private func setHierarchy() {
        
        backgroundView.addSubviews(cancelModalButton,
                                   detailSearchHeaderView,
                                   detailSearchInfoView,
                                   detailSearchBottomView)
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
            
            detailSearchHeaderView.snp.makeConstraints {
                $0.top.leading.equalToSuperview().inset(34)
            }
            
            detailSearchInfoView.snp.makeConstraints {
                $0.top.equalTo(detailSearchHeaderView.snp.bottom).offset(34)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(136)
            }
            
            detailSearchBottomView.snp.makeConstraints {
                $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(62)
            }
        }
    }
}
