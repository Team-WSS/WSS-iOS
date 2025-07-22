//
//  UserNovelPreferencesView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/23/25.
//

import UIKit

import SnapKit
import Then

final class UserNovelPreferencesView: UIView {
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    private let preferencesView = UIView()
    private let preferencesLabel = UILabel()
    lazy var preferencesCollectionView = UICollectionView(frame: .zero,
                                                          collectionViewLayout: UICollectionViewLayout())
    
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
        }
  
        preferencesView.do {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 14
        }
        
        preferencesLabel.do {
            $0.textColor = .wssGray300
        }
        
        preferencesCollectionView.do {
            let layout = LeftAlignedCollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 6
            layout.minimumLineSpacing = 6
            
            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(preferencesView,
                                      preferencesCollectionView)
        preferencesView.addSubview(preferencesLabel)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.setCustomSpacing(20, after: preferencesView)

        preferencesView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(55)
            
            preferencesLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
        preferencesCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0)
        }
    }
    
    //MARK: - Data
    
    func bindPreferencesDetailData(data: [String]) {
        let isEmpty = data.isEmpty
        preferencesView.isHidden = isEmpty
        
        guard !isEmpty else { return }
        let koreanStrings = data.compactMap { AttractivePoint(rawValue: $0)?.koreanString }
        let attractiveString = koreanStrings.joined(separator: ", ")
        let fullText = attractiveString + StringLiterals.MyPage.Profile.novelPreferenceLabel
        preferencesLabel.applyWSSFontPartialColor(.title3, with: fullText, rangeText: attractiveString, color: .wssPrimary100)
    }
    
    func updateKeywordViewHeight(height: CGFloat) {
        preferencesCollectionView.do {
            $0.isHidden = height == 0
            $0.snp.updateConstraints {
                $0.height.equalTo(height)
            }
        }
    }
}
