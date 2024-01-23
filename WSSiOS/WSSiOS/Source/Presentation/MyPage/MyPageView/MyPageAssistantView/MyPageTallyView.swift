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
    
    //MARK: - UI Components
    
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
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        makeShadow()
    }
    
    //MARK: - set UI
    
    private func setUI() {
        self.backgroundColor = .White
        
        backGroundView.backgroundColor = .Gray50
        
        tallyView.do {
            $0.backgroundColor = .White
            $0.layer.cornerRadius = 15
            
            myPageUserNameButton.do {
                $0.setTitleColor(.Black, for: .normal)
                $0.titleLabel?.font = .HeadLine1
                $0.titleLabel?.adjustsFontSizeToFitWidth = true
                $0.setImage(ImageLiterals.icon.MyPage.right, for: .normal)
                $0.semanticContentAttribute = .forceRightToLeft
                
                var config = UIButton.Configuration.plain()
                config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0)
                $0.configuration = config
            }
            
            dividerView.do {
                $0.backgroundColor = .Gray70
            }
            
            myPageRegisterView.do {
                $0.titleIconImageView.image = ImageLiterals.icon.MyPage.register
                $0.titleLabel.text = StringLiterals.MyPage.Profile.registerNovel
            }
            
            myPageRecordView.do {
                $0.titleIconImageView.image = ImageLiterals.icon.MyPage.record
                $0.titleLabel.text = StringLiterals.MyPage.Profile.record
            }
        }
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
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
            $0.layer.shadowOffset = CGSize(width: 0, height: -2)
            $0.layer.shadowRadius = 15
            $0.layer.masksToBounds = false
        }
    }
    
    func tallyViewDataBind(_ data: UserResult) {
        myPageUserNameButton.setTitle("\(data.userNickname)님", for: .normal)
        myPageRegisterView.tallyLabel.text = String(data.userNovelCount)
        myPageRecordView.tallyLabel.text = String(data.memoCount)
    }
}
