//
//  NovelDetailInfoGenreView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/12/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoGenreView: UIView {
    
    //MARK: - set Properties
    
    private let novelGenre = "로판"
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let genreLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - set UI
    
    private func setUI() {
        titleLabel.do {
            $0.text = "장르"
            $0.textColor = .Black
            $0.font = .Title1
        }
        
        genreLabel.do {
            $0.text = self.novelGenre
            $0.textColor = .Gray300
            $0.font = .Body2
        }
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(titleLabel,
                         genreLabel)
    }
    
    // MARK: - set Layout
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        genreLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
}
