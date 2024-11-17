//
//  MyPageGenrePreferencesOtherTableViewCell.swift
//  WSSiOS
//
//  Created by 신지원 on 11/16/24.
//

import UIKit

import SnapKit
import Then

final class MyPageGenrePreferencesOtherTableViewCell: UITableViewCell {

    //MARK: - Components
    
    private var genreImageView = UIImageView()
    private var genreLabel = UILabel()
    private var countLabel = UILabel()
    
    //MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        genreLabel.textColor = .wssBlack
        
        countLabel.textColor = .Gray200
    }
    
    private func setHierarchy() {
        self.addSubviews(genreImageView,
                         genreLabel,
                         countLabel)
    }
    
    private func setLayout() {
        genreImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(40)
            $0.size.equalTo(27.27)
        }
        
        genreLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(genreImageView.snp.trailing).offset(21)
        }
        
        countLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(60)
        }
    }
    
    //MARK: - Data
    
    func bindData(data: GenrePreference) {
        genreImageView.kfSetImage(url: makeBucketImageURLString(path: data.genreImage))
        let koreanGenre = NewNovelGenre(rawValue: data.genreName)?.withKorean
        genreLabel.applyWSSFont(.title3, with: koreanGenre)
        countLabel.applyWSSFont(.body5, with: String(data.genreCount) + "편")
    }
}

