//
//  DetailHeaderView.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/27/24.
//

import UIKit

import SnapKit
import Then

final class DetailHeaderView: UIView {
    
    //MARK: - Components
    
    private let bannerBackgroundImageView = DetailBannerBackgroundImageView()
    
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
    }
    
    private func setHierarchy() {
        self.addSubview(bannerBackgroundImageView)
    }
    
    private func setLayout() {
        bannerBackgroundImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(248)
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: DetailBasicResult) {
        bannerBackgroundImageView.bindData(data.novelImage)
    }
}
