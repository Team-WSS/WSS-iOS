//
//  MyPageCustomModalView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/13/24.
//

import UIKit

import Lottie
import SnapKit
import Then

final class MyPageCustomModalView: UIView {

    //MARK: - Components
    
    public let modalBackgroundView = UIView()
    public let modalAvatarFeatureLabelView = MyPageModalAvatarFeatureLabelView()
    public lazy var modalAvaterLottieView = LottieAnimationView()
    public let modalTitleLabel = UILabel()
    public let modalExplanationLabel = UILabel()
    public lazy var modalChangeButton = WSSMainButton(title: "대표 캐릭터 설정하기")
    public lazy var modalContinueButton = UIButton()
    private let lottieList = [LottieLiterals.Home.Sosocat.bread,
                              LottieLiterals.Home.Regressor.sword,
                              LottieLiterals.Home.Villainess.fan]
    
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
    
    //MARK: - UI
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .White
            $0.layer.cornerRadius = 10
            $0.layer.maskedCorners = [.layerMinXMinYCorner,
                                      .layerMaxXMinYCorner]
            $0.layer.masksToBounds = true
        }
        
        modalTitleLabel.do {
            //text 뷰컨으로 뺄 예정
            $0.text = "오늘 당신을 만날 걸 알고 있었어"
            $0.font = .HeadLine1
            $0.textColor = .Black
        }
        
        modalExplanationLabel.do {
            //text 뷰컨으로 뺄 예정
            $0.text = "메모를 작성해서 잠금해제 됐어요!"
            $0.font = .Title1
            $0.textColor = .Gray200
        }
        
        modalContinueButton.do {
            $0.setTitle("원래대로 유지하기", for: .normal)
            $0.setTitleColor(.Gray300, for: .normal)
            $0.titleLabel?.font = .Body2
            $0.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    private func setHierachy() {
        self.addSubviews(modalAvatarFeatureLabelView,
                         modalAvaterLottieView,
                         modalTitleLabel,
                         modalExplanationLabel,
                         modalChangeButton,
                         modalContinueButton)
    }
    
    private func setLayout() {
        modalAvatarFeatureLabelView.snp.makeConstraints() {
            $0.top.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
        }
        
        modalTitleLabel.snp.makeConstraints() {
            $0.top.equalTo(modalAvatarFeatureLabelView.snp.bottom).offset(268)
            $0.centerX.equalToSuperview()
        }
        
        modalExplanationLabel.snp.makeConstraints() {
            $0.top.equalTo(modalTitleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        modalChangeButton.snp.makeConstraints() {
            $0.top.equalTo(modalExplanationLabel.snp.bottom).offset(30)
            $0.height.equalTo(53)
        }
        
        modalContinueButton.snp.makeConstraints() {
            $0.top.equalTo(modalChangeButton.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(53)
        }
    }
    
    //MARK: - Data
    
    func bindData(id: Int, data: AvatarResult) {
        modalAvatarFeatureLabelView.modalAvaterBadgeImageView.kfSetImage(url: data.avatarGenreBadgeImg)
        modalAvatarFeatureLabelView.modalAvaterTitleLabel.text = data.avatarTag
        modalTitleLabel.text = data.avatarMent
        modalExplanationLabel.text = data.avatarCondition
        
        modalAvaterLottieView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        modalAvaterLottieView = lottieList[id - 1] 
        self.addSubview(modalAvaterLottieView)
        
        modalAvaterLottieView.snp.makeConstraints() {
            $0.top.equalTo(modalAvatarFeatureLabelView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(220)
        }
    
        playLottie()
    }
    
    //MARK: - Custom Method
    
    private func playLottie() {
        modalAvaterLottieView.play()
        modalAvaterLottieView.loopMode = .playOnce
    }
}
