//
//  MyPagePreferencesView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/23/25.
//

import UIKit

import SnapKit
import Then

final class MyPagePreferencesView: UIView {
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    private let myPageGenrePreferencesCountLabel = UILabel()
    let myPageGenrePreferencesView = UserGenrePreferencesView()
    let myPageNovelPreferencesView = UserPageNovelPreferencesView()
    private let preferencesEmptyView = UserPagePreferencesEmptyView()
    
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
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
        }
        
        //preferencesEmptyView.isHidden = true
        
        myPageGenrePreferencesCountLabel.do {
            $0.textAlignment = .center
            $0.textColor = .wssGray300
        }
    }
    
    private func setHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubviews(myPageGenrePreferencesCountLabel,
                                      myPageGenrePreferencesView,
                                      myPageNovelPreferencesView)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.do {
            $0.setCustomSpacing(9, after: myPageGenrePreferencesCountLabel)
            $0.setCustomSpacing(20, after: myPageGenrePreferencesView)
        }
        
        myPageGenrePreferencesCountLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }
        
        myPageGenrePreferencesView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    //MARK: - Custom Method
    
    func updateGenreViewHeight(isExpanded: Bool) {
        myPageGenrePreferencesView.snp.updateConstraints {
            $0.height.equalTo(isExpanded ? 514 : 224.5)
        }
    }
    
    //MARK: - Data
    
    func bindData(genreTotalCountText: Int) {
        let rangeText = String(genreTotalCountText)
        let fullText = rangeText + StringLiterals.MyPage.Profile.genreTotalCount
        myPageGenrePreferencesCountLabel.applyWSSFontPartialColor(.title2,
                                                                  with: fullText,
                                                                  rangeText: rangeText,
                                                                  color: .wssPrimary100)
    }
}
