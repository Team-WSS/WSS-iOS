//
//  NovelDetailHeaderView.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/27/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailHeaderView: UIView {
    
    //MARK: - Components
    
    private let bannerBackgroundImageView = NovelDetailBannerBackgroundImageView()
    
    private let stackView = UIStackView()
    private let novelCoverImageView = NovelDetailNovelCoverImageView()
    private let novelInfoView = NovelDetailNovelInfoView()
    
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
            $0.alignment = .center
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(bannerBackgroundImageView,
                         stackView)
        stackView.addArrangedSubviews(novelCoverImageView,
                                      novelInfoView)
    }
    
    private func setLayout() {
        bannerBackgroundImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(248)
        }
        
        stackView.do {
            stackView.snp.makeConstraints {
                $0.top.equalTo(safeAreaLayoutGuide)
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.bottom.equalToSuperview()
            }
            
            $0.setCustomSpacing(20, after: novelCoverImageView)
        }
        
    }
    
    //MARK: - Data
    
    func bindData(_ data: DetailBasicResult) {
        bannerBackgroundImageView.bindData(data)
        novelCoverImageView.bindData(data)
        novelInfoView.bindData(data)
    }
}
