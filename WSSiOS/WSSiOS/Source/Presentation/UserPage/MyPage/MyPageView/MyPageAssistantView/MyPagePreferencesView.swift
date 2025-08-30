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
    
    private let myPageNovelPreferencesTitleLabel = UILabel()
    let myPageNovelPreferencesView = UserNovelPreferencesView()
    private let preferencesEmptyView = UserPreferencesEmptyView()
    
    private let dividerView = UIView()
    
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
            $0.alignment = .center
            $0.distribution = .fill
        }
        
        myPageGenrePreferencesCountLabel.do {
            $0.textAlignment = .center
            $0.textColor = .wssGray300
        }
        
        myPageNovelPreferencesTitleLabel.do {
            $0.textAlignment = .center
            $0.textColor = .wssGray300
            $0.applyWSSFont(.title2, with: StringLiterals.MyPage.Profile.myNovelPreferenceTitle)
        }

        preferencesEmptyView.isHidden = true
        
        dividerView.do {
            $0.backgroundColor = .wssGray50
        }
    }
    
    private func setHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubviews(myPageGenrePreferencesCountLabel,
                                      myPageGenrePreferencesView,
                                      dividerView,
                                      myPageNovelPreferencesTitleLabel,
                                      myPageNovelPreferencesView,
                                      preferencesEmptyView)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.do {
            $0.setCustomSpacing(9, after: myPageGenrePreferencesCountLabel)
            $0.setCustomSpacing(20, after: myPageGenrePreferencesView)
            $0.setCustomSpacing(20, after: dividerView)
            $0.setCustomSpacing(20, after: myPageNovelPreferencesTitleLabel)
        }
        
        myPageGenrePreferencesCountLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }
        
        myPageGenrePreferencesView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        dividerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(3)
        }
        
        myPageNovelPreferencesTitleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }
        
        myPageNovelPreferencesView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
        
        preferencesEmptyView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func updateGenreViewHeight(isExpanded: Bool) {
        myPageGenrePreferencesView.snp.updateConstraints {
            $0.height.equalTo(isExpanded ? 514 : 224.5)
        }
    }
    
    func updatePreferenceViews(genreEmpty: Bool, novelEmpty: Bool) {
        
        //장르뷰
        myPageGenrePreferencesCountLabel.isHidden = genreEmpty
        myPageGenrePreferencesView.isHidden = genreEmpty
        dividerView.isHidden = genreEmpty

        // 노벨뷰
        myPageNovelPreferencesView.isHidden = novelEmpty

        // Empty 뷰
        preferencesEmptyView.isHidden = !novelEmpty

        if novelEmpty {
            preferencesEmptyView.snp.remakeConstraints {
                $0.horizontalEdges.equalToSuperview()
                $0.height.equalTo(223)
            }
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
