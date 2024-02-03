//
//  RegisterNormalView.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/6/24.
//

import UIKit

import SnapKit
import Then

final class RegisterNormalView: UIView {
    
    // MARK: - UI Components
    
    let statusBarView = UIView()
    let pageScrollView = UIScrollView()
    private let pageContentView = UIStackView()
    
    let divider = UIView()
    let bannerImageView = RegisterNormalBannerImageView()
    let infoWithRatingView = RegisterNormalNovelInfoWithRatingView()
    let readStatusView = RegisterNormalReadStatusView()
    let readDateView = RegisterNormalReadDateView()
    private let dividerView = RegisterNormalDividerView()
    let novelSummaryView = RegisterNormalNovelSummaryView()
    
    let registerButton = WSSMainButton(title: StringLiterals.Register.Normal.RegisterButton.new)
    private let registerButtonGradient = UIImageView()
    private let registerButtonBackgroundView = UIView()
    
    let customDatePicker = RegisterNormalDatePicker()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHieararchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .white
        }
        divider.do {
            $0.backgroundColor = .Gray70
        }
        statusBarView.do {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let statusBarManager = windowScene?.windows.first?.windowScene?.statusBarManager
            $0.frame = statusBarManager?.statusBarFrame ?? .zero
        }
        
        pageScrollView.do {
            $0.contentInsetAdjustmentBehavior = .never
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            
            pageContentView.do {
                $0.axis = .vertical
                $0.alignment = .fill
            }
        }
        
        registerButtonGradient.do {
            $0.image = .registerNormalButtonGradientDummy
        }
        
        registerButtonBackgroundView.do {
            $0.backgroundColor = .White
        }
    }
    
    private func setHieararchy() {
        self.addSubviews(pageScrollView,
                         divider,
                         statusBarView,
                         registerButtonGradient,
                         registerButtonBackgroundView,
                         registerButton,
                         customDatePicker)
        pageScrollView.addSubview(pageContentView)
        pageContentView.addArrangedSubviews(bannerImageView,
                                            infoWithRatingView,
                                            readStatusView,
                                            readDateView,
                                            novelSummaryView)
    }
    
    private func setLayout() {
        pageScrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(registerButton.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            
            pageContentView.do {
                $0.snp.makeConstraints {
                    $0.edges.equalTo(pageScrollView.contentLayoutGuide)
                    $0.width.equalToSuperview()
                }
                
                $0.spacing = 35
                $0.setCustomSpacing(-154, after: bannerImageView)
                $0.setCustomSpacing(56, after: infoWithRatingView)
            }
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(0.7)
            $0.horizontalEdges.equalToSuperview()
        }
        
        registerButton.snp.makeConstraints {
            if UIScreen.isSE {
                $0.bottom.equalTo(safeAreaLayoutGuide).inset(15)
            } else {
                $0.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            }
        }
        
        registerButtonGradient.snp.makeConstraints {
            $0.bottom.equalTo(registerButton.snp.top)
            $0.height.equalTo(34)
            $0.horizontalEdges.equalToSuperview()
        }
        
        registerButtonBackgroundView.snp.makeConstraints {
            $0.top.equalTo(registerButton.snp.top)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        customDatePicker.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bindNewData(_ newData: NewNovelResult) {
        bannerImageView.bindData(newData.novelImg)
        infoWithRatingView.bindData(coverImage: newData.novelImg,
                                             title: newData.novelTitle,
                                             author: newData.novelAuthor)
        novelSummaryView.bindData(plot: newData.novelDescription,
                                           genre: newData.novelGenre,
                                           platforms: newData.platforms)
        novelSummaryView.platformCollectionView.reloadData()
    }
    
    func bindUserData(_ userData: EditNovelResult) {
        bannerImageView.bindData(userData.userNovelImg)
        infoWithRatingView.bindData(coverImage: userData.userNovelImg,
                                             title: userData.userNovelTitle,
                                             author: userData.userNovelAuthor)
        novelSummaryView.bindData(plot: userData.userNovelDescription,
                                           genre: userData.userNovelGenre,
                                           platforms: userData.platforms)
        novelSummaryView.platformCollectionView.reloadData()
    }
}
