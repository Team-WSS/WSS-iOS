//
//  MyPageGenrePreferencesTopView.swift
//  WSSiOS
//
//  Created by 신지원 on 11/16/24.
//

import UIKit

import SnapKit
import Then

final class MyPageGenrePreferencesTopView: UIView {

    //MARK: - Components
    
    let topGenreImageView = UIImageView()
    let topGenreTitleLabel = UILabel()
    let topGenreCountLabel = UILabel()
    
    
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
        topGenreImageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(48)
        }
        
        topGenreTitleLabel.snp.makeConstraints {
            $0.top.equalTo(topGenreImageView.snp.bottom).offset(7)
            $0.centerX.equalToSuperview()
        }
        
        topGenreCountLabel.snp.makeConstraints {
            $0.top.equalTo(topGenreTitleLabel.snp.bottom).offset(2)
            $0.centerX.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindData(data: GenrePreference) {
        topGenreImageView.kfSetImage(url: makeBucketImageURLString(path: data.genreImage))
        let koreanGenre = NewNovelGenre.withKoreanRawValue(from: data.genreName)
        topGenreTitleLabel.applyWSSFont(.title3, with: koreanGenre.rawValue)
        topGenreCountLabel.applyWSSFont(.body5, with: String(data.genreCount) + "편")
    }
}



