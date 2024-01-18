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
    
    // MARK: - UI Components

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
        self.backgroundColor = .White
        
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
            $0.backgroundColor = .Black
            $0.setImage(ImageLiterals.icon.Memo.big, for: .normal)
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
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
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
    
    // MARK: - set Layout
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        createMemoButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(26)
            $0.bottom.equalToSuperview().inset(60)
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
    
    func changeCurrentMenu(menu: Int) {
        if menu == 0 {
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
        } else {
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
