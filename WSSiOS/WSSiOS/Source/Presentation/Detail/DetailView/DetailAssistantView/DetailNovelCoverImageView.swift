//
//  DetailNovelCoverView.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/27/24.
//

import UIKit

import SnapKit
import Then

final class DetailNovelCoverImageView: UIView {
    
    //MARK: - Components
    
    private let novelCoverImageView = UIImageView()
    private let novelGenreLabelImageView = UIImageView()
    
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
        novelCoverImageView.do {
            $0.image = .imgLoadingThumbnail
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
            
            novelGenreLabelImageView.do {
                $0.image = .imgGenreLabelBackgroundDummy
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
            }
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(novelCoverImageView,
                        novelGenreLabelImageView)
    }
    
    private func setLayout() {
        novelCoverImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(217)
            $0.width.equalTo(148)
        }
        
        novelGenreLabelImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.size.equalTo(71)
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: DetailBasicResult) {
        novelCoverImageView.image = UIImage(named: data.novelImage)
        novelGenreLabelImageView.image = UIImage(named: data.novelGenreURL)
    }
}
