//
//  NovelDetailView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailView: UIView {
    
    //MARK: - Components

    let statusBarView = UIView()
    let scrollView = UIScrollView()
    let contentView = UIStackView()
    let novelDetailHeaderView = NovelDetailHeaderView()
    let novelDetailTabView = NovelDetailTabView()
    let novelDetailMemoView = NovelDetailMemoView()
    let novelDetailInfoView = NovelDetailInfoView()
    let createMemoButton = DifferentRadiusButton()
    let stickyNovelDetailTabView = NovelDetailTabView()
    let novelDetailMemoSettingButtonView = NovelDetailMemoSettingButtonView()

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
        self.backgroundColor = .wssWhite
        
        statusBarView.do {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let statusBarManager = windowScene?.windows.first?.windowScene?.statusBarManager
            $0.frame = statusBarManager?.statusBarFrame ?? .zero
        }
        
        scrollView.do {
            $0.contentInsetAdjustmentBehavior = .never
            $0.showsVerticalScrollIndicator = false
        }
        
        contentView.do {
            $0.alignment = .fill
            $0.axis = .vertical
        }
        
        createMemoButton.do {
            $0.backgroundColor = .wssBlack
            $0.setImage(.icCreateMemoBig, for: .normal)
            $0.topLeftRadius = 32.5
            $0.topRightRadius = 32.5
            $0.bottomLeftRadius = 32.5
            $0.bottomRightRadius = 10.0
        }
        
        stickyNovelDetailTabView.do {
            $0.isHidden = true
        }
        
        novelDetailMemoSettingButtonView.do {
            $0.isHidden = true
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(scrollView,
                         statusBarView,
                         createMemoButton,
                         stickyNovelDetailTabView,
                         novelDetailMemoSettingButtonView)
        scrollView.addSubview(contentView)
        contentView.addArrangedSubviews(novelDetailHeaderView,
                                        novelDetailTabView,
                                        novelDetailMemoView)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        createMemoButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(26)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(25)
            $0.size.equalTo(65)
        }
        
        stickyNovelDetailTabView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        novelDetailMemoSettingButtonView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func changeCurrentMenu(menu: SelectedMenu) {
        switch menu {
        case .memo:
            self.novelDetailInfoView.removeFromSuperview()
            self.contentView.addArrangedSubview(self.novelDetailMemoView)
            self.novelDetailTabView.do {
                $0.memoButton.isSelected = true
                $0.infoButton.isSelected = false
                $0.highlightMemoButton()
            }
            self.stickyNovelDetailTabView.do {
                $0.memoButton.isSelected = true
                $0.infoButton.isSelected = false
                $0.highlightMemoButton()
            }
        case .info:
            self.novelDetailMemoView.removeFromSuperview()
            self.contentView.addArrangedSubview(self.novelDetailInfoView)
            self.novelDetailTabView.do {
                $0.memoButton.isSelected = false
                $0.infoButton.isSelected = true
                $0.highlightInfoButton()
            }
            self.stickyNovelDetailTabView.do {
                $0.memoButton.isSelected = false
                $0.infoButton.isSelected = true
                $0.highlightInfoButton()
            }
        }
    }
}
