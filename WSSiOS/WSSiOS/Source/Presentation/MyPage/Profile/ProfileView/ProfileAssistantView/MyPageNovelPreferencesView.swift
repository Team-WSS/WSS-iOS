//
//  MyPageNovelPreferencesView.swift
//  WSSiOS
//
//  Created by 신지원 on 11/16/24.
//

import UIKit

import SnapKit
import Then

final class MyPageNovelPreferencesView: UIView {
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    
    private let paddingView = UIView()
    private let paddingView2 = UIView()
    private let titleLabel = UILabel()
    private let preferencesView = UIView()
    private let preferencesLabel = UILabel()
    
    private let preferencesEmptyView = MyPagePreferencesEmptyView()
    
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
        
        [paddingView, paddingView2].forEach { view in
            view.do {
                $0.backgroundColor = .wssWhite
            }
        }
        
        titleLabel.do {
            $0.applyWSSFont(.title1, with: StringLiterals.MyPage.Profile.novelPreferenceTitle)
            $0.textColor = .wssBlack
        }
        
        preferencesView.do {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 14
        }
        
        preferencesCollectionView.do {
            let layout = LeftAlignedCollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 6
            layout.minimumLineSpacing = 6
            
            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
        }
        
        preferencesEmptyView.isHidden = true
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(paddingView,
                                      titleLabel,
                                      preferencesView,
                                      preferencesCollectionView,
                                      paddingView2,
                                      preferencesEmptyView)
        preferencesView.addSubview(preferencesLabel)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.setCustomSpacing(10, after: titleLabel)
        stackView.setCustomSpacing(20, after: preferencesView)
        
        paddingView.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        paddingView2.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.equalToSuperview().inset(20)
        }
        
        preferencesView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(55)
            
            preferencesLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
        preferencesCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.width.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        preferencesEmptyView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(363)
        }
    }
    
    //MARK: - Data
    
    func updatePreferencesView(isExist: Bool, data: [String]) {
        [paddingView,
         titleLabel,
         preferencesView,
         preferencesCollectionView,
         paddingView2].forEach { view in
            view.do {
                $0.isHidden = !isExist
            }
        }
        
        [preferencesEmptyView].forEach { view in
            view.do {
                $0.isHidden = isExist
            }
        }
        
        bindPreferencesDetailData(data: data)
    }
    
    private func bindPreferencesDetailData(data: [String]) {
        if data.isEmpty {
            preferencesView.isHidden = true
        } else {
            let koreanStrings = data.compactMap { AttractivePoint(rawValue: $0)?.koreanString }
            let attaractiveString = koreanStrings.joined(separator: ", ")
            preferencesLabel.do {
                $0.font = .Title3
                $0.textColor = .wssGray300
                $0.makeAttribute(with: attaractiveString + StringLiterals.MyPage.Profile.novelPreferenceLabel)?
                    .lineHeight(1.5)
                    .kerning(kerningPixel: -0.6)
                    .partialColor(color: .wssPrimary100, rangeString: attaractiveString)
                    .applyAttribute()
            }
        }
    }
    
    func updateKeywordViewHeight(height: CGFloat) {
        [preferencesCollectionView,
         paddingView2].forEach { view in
            view.do {
                $0.isHidden = height == 0
            }
        }
        preferencesCollectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
}
