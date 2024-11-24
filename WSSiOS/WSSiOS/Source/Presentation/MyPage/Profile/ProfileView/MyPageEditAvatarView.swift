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
    
    private let lottieList: [() -> LottieAnimationView] = [
        { [Lottie.Home.Sosocat.tail, Lottie.Home.Sosocat.bread].randomElement()! },
        { [Lottie.Home.Villainess.fan, Lottie.Home.Villainess.tea].randomElement()! },
        { [Lottie.Home.Regressor.sword, Lottie.Home.Regressor.greeting].randomElement()! }
    ]
    
    //MARK: - Components
    
    private let navigationLabel = UILabel()
    
    private var avatarLottieView = LottieAnimationView()
    private let avatarNameLabel = UILabel()
    private let avatarLineLabel = UILabel()
    
    let avatarImageCollectionView = UICollectionView(frame: .zero,
                                                             collectionViewLayout: UICollectionViewLayout())
    private let changeButton = UIButton()
    private let notChangeButton = UIButton()
    
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
        navigationLabel.do {
            $0.applyWSSFont(.headline1, with: StringLiterals.Navigation.Title.changeAvatar)
            $0.textColor = .wssBlack
        }
        
        avatarImageCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 16
            layout.itemSize = CGSize(width: 50, height: 50)
            
            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
            $0.showsHorizontalScrollIndicator = false
        }
        
        changeButton.do {
            $0.setTitle(StringLiterals.MyPage.Modal.changeCharacter, for: .normal)
            $0.setTitleColor(.wssWhite, for: .normal)
            $0.backgroundColor = .wssPrimary100
            $0.layer.cornerRadius = 14
        }
        
        notChangeButton.do {
            $0.setTitle(StringLiterals.MyPage.Modal.keepOriginally, for: .normal)
            $0.setTitleColor(.wssGray300, for: .normal)
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 14
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(navigationLabel,
                         avatarLottieView,
                         avatarNameLabel,
                         avatarLineLabel,
                         avatarImageCollectionView,
                         changeButton,
                         notChangeButton)
    }
    
    private func setLayout() {
        navigationLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(33)
        }
        
        avatarLottieView.snp.makeConstraints {
            $0.top.equalTo(navigationLabel.snp.bottom).offset(36)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(250)
        }
        
        avatarNameLabel.snp.makeConstraints {
            $0.top.equalTo(avatarLottieView.snp.bottom).offset(28)
            $0.centerX.equalToSuperview()
        }
        
        avatarLineLabel.snp.makeConstraints {
            $0.top.equalTo(avatarNameLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        avatarImageCollectionView.snp.makeConstraints {
            $0.top.equalTo(avatarLineLabel.snp.bottom).offset(33)
            $0.centerX.equalToSuperview()
        }
        
        changeButton.snp.makeConstraints {
            $0.top.equalTo(avatarImageCollectionView.snp.bottom).offset(43)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(53)
        }
        
        notChangeButton.snp.makeConstraints {
            $0.top.equalTo(changeButton.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(53)
            if UIScreen.isSE {
                $0.bottom.equalToSuperview().inset(10)
            } else {
                $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            }
        }
    }
    
    //MARK: - Data
    
    private func bindData(_ avatar: Avatar) {
        avatarNameLabel.do {
            $0.applyWSSFont(.headline1, with: avatar.avatarName)
            $0.textColor = .wssBlack
        }
        
        avatarLineLabel.do {
            $0.applyWSSFont(.headline1, with: avatar.avatarLine)
            $0.textColor = .wssBlack
        }
        
        //Lottie 적용
        let lottieId = avatar.avatarId - 1
        avatarLottieView = lottieList[lottieId]()
        avatarLottieView.do {
            $0.contentMode = .scaleAspectFit
        }
        self.addSubview(avatarLottieView)
        avatarLottieView.snp.makeConstraints {
            $0.top.equalTo(navigationLabel.snp.bottom).offset(36)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(250)
        }
        
        playLottie()
    }
    
    //MARK: - Custom Method
    
    private func playLottie() {
        avatarLottieView.play()
        avatarLottieView.loopMode = .playOnce
    }
}
