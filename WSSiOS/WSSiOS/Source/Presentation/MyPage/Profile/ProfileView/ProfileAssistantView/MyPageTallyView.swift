//
//  MyPageTallyView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/10/24.
//

import UIKit

import SnapKit
import Then

final class MyPageTallyView: UIView {
    
    //MARK: - Components
    
    private let backGroundView = UIView()
    private let tallyView = UIView()
    private let shadowView = UIView()
    public lazy var myPageUserNameButton = UIButton()
    public lazy var myPageRegisterView = MyPageTallyReuseView()
    public lazy var myPageRecordView = MyPageTallyReuseView()
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
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        
        makeShadow()
    }
    
    //MARK: - set UI
    
    private func setUI() {
        self.backgroundColor = .wssWhite
        
        backGroundView.backgroundColor = .wssGray50
        
        tallyView.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 15

            myPageUserNameButton.do {
                var configuration = UIButton.Configuration.filled()
                configuration.image = .icRight
                configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0)
                configuration.imagePlacement = .trailing
                configuration.baseBackgroundColor = UIColor.clear
                $0.configuration = configuration
            }
            
            dividerView.do {
                $0.backgroundColor = .wssGray70
            }
            
            myPageRegisterView.do {
                $0.titleIconImageView.image = .register
                $0.titleLabel.text = StringLiterals.MyPage.Profile.registerNovel
            }
            
            myPageRecordView.do {
                $0.titleIconImageView.image = .record
                $0.titleLabel.text = StringLiterals.MyPage.Profile.record
            }
        }
    }
    
    //MARK: - set Hierachy
    
    private func setHierarchy() {
        self.addSubviews(backGroundView,
                         shadowView,
                         tallyView)
        tallyView.addSubviews(myPageUserNameButton,
                              dividerView,
                              myPageRegisterView,
                              myPageRecordView)
    }
    
    //MARK: - set Layout
    
    private func setLayout() {
        backGroundView.snp.makeConstraints() {
            $0.top.width.equalToSuperview()
            $0.bottom.equalTo(super.snp.centerY)
        }
        
        tallyView.snp.makeConstraints() {
            $0.centerX.centerY.equalToSuperview()
            $0.top.equalToSuperview().inset(27)
            $0.leading.equalToSuperview().inset(20)
            
            myPageUserNameButton.snp.makeConstraints() {
                $0.top.equalToSuperview().inset(18)
                $0.centerX.equalToSuperview()
            }
            
            dividerView.snp.makeConstraints() {
                $0.top.equalTo(myPageUserNameButton.snp.bottom).offset(20)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().inset(18)
                $0.width.equalTo(1)
            }
            
            myPageRegisterView.snp.makeConstraints() {
                $0.top.equalTo(dividerView.snp.top)
                $0.leading.equalToSuperview()
                $0.trailing.equalTo(dividerView.snp.leading)
                $0.bottom.equalToSuperview().inset(18)
            }
            
            myPageRecordView.snp.makeConstraints() {
                $0.top.equalTo(dividerView.snp.top)
                $0.trailing.equalToSuperview()
                $0.leading.equalTo(dividerView.snp.trailing)
                $0.bottom.equalToSuperview().inset(18)
            }
        }
    }
    
    private func makeShadow() {
        shadowView.do {
            $0.frame = tallyView.frame
            $0.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
            $0.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
            $0.layer.shadowOpacity = 1
            
            // 정확한 그림자 OffSet 을 모르겠어서 최대한 Figma 와 비슷하게 해놓음
            // 추후 디자이너 선생님들고 이야기하여 수정하겠음
            $0.layer.shadowOffset = CGSize(width: 10, height: 10)
            $0.layer.shadowRadius = 15
            $0.layer.masksToBounds = false
        }
    }
    
    //MARK: - Data
    
    func bindTallyViewData(_ data: UserResult) {
        let title = "\(data.userNickname)님"
        var attString = AttributedString(title)
        attString.font = UIFont.HeadLine1
        attString.foregroundColor = UIColor.wssBlack
        myPageUserNameButton.configuration?.attributedTitle = attString
        
        myPageRegisterView.tallyLabel.text = String(data.userNovelCount)
        myPageRecordView.tallyLabel.text = String(data.memoCount)
    }
}
