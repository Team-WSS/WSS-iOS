//
//  MyPageCustomModalView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/13/24.
//

import UIKit

import SnapKit
import Then

final class MyPageCustomModalView: UIView {

    //MARK: - UI Components
    
    public var modalAvatarFeatureLabelView = MyPageModalAvatarFeatureLabelView()
    public var modalAvaterImageView = UIImageView()
    public var modalTitleLabel = UILabel()
    public var modalExplanationLabel = UILabel()
    public var modalChangeButton = WSSMainButton(title: "대표 캐릭터 설정하기")
    public var modalContinueButton = UIButton()
    
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
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .White
            $0.layer.cornerRadius = 10
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.layer.masksToBounds = true
        }

        //뷰컨으로 뺄 예정
        modalAvaterImageView.backgroundColor = .Gray300
        
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
                         modalAvaterImageView,
                         modalTitleLabel,
                         modalExplanationLabel,
                         modalChangeButton,
                         modalContinueButton)
    }
    
    private func setLayout() {
        modalAvatarFeatureLabelView.snp.makeConstraints() {
            $0.top.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
//            $0.height.equalTo(52)
        }
        
        modalAvaterImageView.snp.makeConstraints() {
            $0.top.equalTo(modalAvatarFeatureLabelView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(220)
        }
        
        modalTitleLabel.snp.makeConstraints() {
            $0.top.equalTo(modalAvaterImageView.snp.bottom).offset(18)
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
    
    func bindData(_ data: AvatarResult) {
        modalAvatarFeatureLabelView.modalAvaterBadgeImageView.kfSetImage(url: data.avatarGenreBadgeImg)
        modalAvatarFeatureLabelView.modalAvaterTitleLabel.text = data.avatarTag
//        modalAvaterImageView.kfSetImage(url: data.)
        modalTitleLabel.text = data.avatarMent
        modalExplanationLabel.text = data.avatarCondition
    }
}
