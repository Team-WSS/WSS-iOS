//
//  NovelDetailInfoDescriptionView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/12/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoDescriptionView: UIView {
    
    //MARK: - set Properties

    private let novelDescription = "왕실에는 막대한 빚이 있었고, 그들은 빚을 갚기 위해 왕녀인 바이올렛을 막대한 돈을 지녔지만 공작의 사생/아인 윈터에게 시집보낸다.  '태어나서 이렇게 멋있는 남자는 처음 봐…….' 왕실에는 막대한 빚이 있었고, 그들은 빚을 갚기 위해 왕녀인 바이올렛을 막대한 돈을 지녔지만 공작의 사생/아인 윈터에게 시집보낸다."

    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
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
            $0.text = "작품 소개"
            $0.textColor = .Black
            $0.font = .Title1
        }
        
        descriptionLabel.do {
            $0.text = self.novelDescription
            $0.textColor = .Gray300
            $0.font = .Body2
            $0.numberOfLines = 0
            $0.lineBreakStrategy = .hangulWordPriority
        }
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(titleLabel,
                        descriptionLabel)
    }
    
    // MARK: - set Layout
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
}
