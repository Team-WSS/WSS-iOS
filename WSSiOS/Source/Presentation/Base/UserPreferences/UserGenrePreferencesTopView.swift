//
//  UserPageGenrePreferencesTopView.swift
//  WSSiOS
//
//  Created by 신지원 on 11/16/24.
//

import UIKit

import SnapKit
import Then

final class UserGenrePreferencesTopView: UIView {
    
    //MARK: - Components
    
    private let topGenreImageView = UIImageView()
    private let topGenreTitleLabel = UILabel()
    private let topGenreCountLabel = UILabel()
    
    // MARK: - Life Cycle
    
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
        self.backgroundColor = .wssWhite
        
        topGenreTitleLabel.textColor = .wssBlack
        topGenreCountLabel.textColor = .wssGray200
    }
    
    private func setHierarchy() {
        self.addSubviews(topGenreImageView,
                         topGenreTitleLabel,
                         topGenreCountLabel)
    }
    
    private func setLayout() {
        //TODO: 이미지 크기 조절하여 소수점 제거
        topGenreImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6.55)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(37.09)
        }
        
        topGenreTitleLabel.snp.makeConstraints {
            $0.top.equalTo(topGenreImageView.snp.bottom).offset(7)
            $0.centerX.equalToSuperview()
        }
        
        topGenreCountLabel.snp.makeConstraints {
            $0.top.equalTo(topGenreTitleLabel.snp.bottom).offset(2)
            $0.centerX.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindData(data: UserGenrePreferencesEntity) {
        topGenreImageView.kfSetImage(url: data.genreImageURL)
        let koreanGenre = NovelGenre(rawValue: data.genreName)?.withKorean
        topGenreTitleLabel.applyWSSFont(.title3, with: koreanGenre)
        topGenreCountLabel.applyWSSFont(.body5, with: String(data.genreCount) + "편")
    }
}
