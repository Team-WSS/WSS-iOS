//
//  MyPageEditCharacterView.swift
//  WSSiOS
//
//  Created by 신지원 on 11/25/24.
//

import UIKit

import Lottie
import SnapKit
import Then

final class MyPageEditAvatarView: UIView {
    
    //MARK: - Properties
    
    private let circleSize: CGSize = CGSize(width: 6, height: 6)
    private let profileSize: CGSize = CGSize(width: 50, height: 50)
    
    //MARK: - Components
    
    private let contentView = UIView()
    
    private let navigationLabel = UILabel()
    
    private let avatarCharacterImageView = UIImageView()
    private let avatarNameLabel = UILabel()
    private let avatarLineLabel = UILabel()
    
    let avatarImageCollectionView = UICollectionView(frame: .zero,
                                                     collectionViewLayout: UICollectionViewLayout())
    private let circleStackView = UIStackView()
    private let firstCircleView = UIView()
    private let secondCircleView = UIView()
    
    private let buttonStackView = UIStackView()
    let changeButton = UIButton()
    private let changeButtonLabel = UILabel()
    let notChangeButton = UIButton()
    private let notChangeButtonLabel = UILabel()
    
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
        contentView.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 12
            $0.layer.maskedCorners = [.layerMinXMinYCorner,
                                      .layerMaxXMinYCorner]
        }
        
        navigationLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.Navigation.Title.changeAvatar)
            $0.textColor = .wssBlack
        }
        
        avatarCharacterImageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        avatarNameLabel.do {
            $0.applyWSSFont(.headline1, with: StringLiterals.MyPage.EditProfile.defaultAvatarName)
            $0.textColor = .wssBlack
        }
        
        avatarLineLabel.do {
            $0.applyWSSFont(.title3, with: StringLiterals.MyPage.EditProfile.defaultAvatarDescription)
            $0.textColor = .wssGray200
        }
        
        avatarImageCollectionView.do {
            $0.collectionViewLayout = pagingCompositionalLayout()
            $0.alwaysBounceVertical = false
        }
        
        circleStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .center
            $0.distribution = .equalSpacing
        }
        
        [firstCircleView, secondCircleView].forEach { circle in
            circle.layer.cornerRadius = circleSize.height / 2
            circle.backgroundColor = .wssPrimary100
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.distribution = .fillEqually
        }
        
        changeButton.do {
            $0.backgroundColor = .wssPrimary100
            $0.layer.cornerRadius = 14
        }
        
        notChangeButton.do {
            $0.backgroundColor = .wssGray70
            $0.layer.cornerRadius = 14
        }
        
        changeButtonLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.MyPage.Modal.changeCharacter)
            $0.textColor = .wssWhite
        }
        
        notChangeButtonLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.MyPage.Modal.keepOriginally)
            $0.textColor = .wssGray300
        }
    }
    
    private func setHierarchy() {
        self.addSubview(contentView)
        contentView.addSubviews(navigationLabel,
                                avatarCharacterImageView,
                                avatarNameLabel,
                                avatarLineLabel,
                                avatarImageCollectionView,
                                circleStackView,
                                buttonStackView)
        circleStackView.addArrangedSubviews(firstCircleView,
                                            secondCircleView)
        buttonStackView.addArrangedSubviews(notChangeButton,
                                            changeButton)
        notChangeButton.addSubview(notChangeButtonLabel)
        changeButton.addSubview(changeButtonLabel)
    }
    
    private func setLayout() {
        contentView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(UIScreen.isSE ? 654 + 10 : 689)
        }
        
        navigationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(33)
            $0.centerX.equalToSuperview()
        }
        
        avatarCharacterImageView.snp.makeConstraints {
            $0.top.equalTo(navigationLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(250)
        }
        
        avatarNameLabel.snp.makeConstraints {
            $0.top.equalTo(avatarCharacterImageView.snp.bottom).offset(18)
            $0.centerX.equalToSuperview()
        }

        avatarLineLabel.snp.makeConstraints {
            $0.top.equalTo(avatarNameLabel.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        
        avatarImageCollectionView.snp.makeConstraints {
            $0.top.equalTo(avatarLineLabel.snp.bottom).offset(35)
            $0.leading.trailing.equalToSuperview().inset(39)
            $0.height.equalTo(115)
        }
        
        circleStackView.snp.makeConstraints {
            $0.top.equalTo(avatarImageCollectionView.snp.bottom).offset(18)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(6)
        }
        
        firstCircleView.snp.makeConstraints {
            $0.size.equalTo(self.circleSize)
        }
        
        secondCircleView.snp.makeConstraints {
            $0.size.equalTo(self.circleSize)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(53)
        }
        
        notChangeButtonLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        changeButtonLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindData(avatar: AvatarEntity, nickname: String) {
        avatarNameLabel.do {
            $0.applyWSSFont(.headline1, with: avatar.avatarName)
        }
        
        avatarCharacterImageView.do {
            $0.kfSetImage(url: avatar.avatarImageURL)
        }
        
        avatarLineLabel.do {
            let avatarLineText = avatar.avatarLine
            let formattedLineText = avatarLineText.replacingOccurrences(of: "%s", with: nickname)
            $0.applyWSSFont(.title3, with: formattedLineText)
        }
    }
    
    func bindInitialAvatarPage(for index: Int) {
        let itemsPerPage = 10
        let page = index / itemsPerPage
        
        let itemIndex = IndexPath(item: page * itemsPerPage,
                                  section: 0)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.avatarImageCollectionView.scrollToItem(
                at: itemIndex,
                at: .left,
                animated: false
            )
            
            self.updatePageIndicator(currentPage: page)
        }
    }
    
    func pagingCompositionalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(self.profileSize.width),
            heightDimension: .absolute(self.profileSize.height)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let rowGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(self.profileSize.height)
        )
        let rowGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: rowGroupSize,
            subitem: item,
            count: 5
        )
        rowGroup.interItemSpacing = .fixed(14)

        let pageGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let pageGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: pageGroupSize,
            subitem: rowGroup,
            count: 2
        )
        pageGroup.interItemSpacing = .fixed(14)

        let section = NSCollectionLayoutSection(group: pageGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        
        section.visibleItemsInvalidationHandler = { [weak self] _, contentOffset, environment in
            let pageWidth = environment.container.contentSize.width
            let currentPage = Int(round(contentOffset.x / pageWidth))
            self?.updatePageIndicator(currentPage: currentPage)
        }

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func updatePageIndicator(currentPage: Int) {
        let activeColor = UIColor.wssPrimary100
        let inactiveColor = UIColor.wssGray200

        firstCircleView.backgroundColor =
            currentPage == 0 ? activeColor : inactiveColor

        secondCircleView.backgroundColor =
            currentPage == 1 ? activeColor : inactiveColor
    }
}
