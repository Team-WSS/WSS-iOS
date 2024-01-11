//
//  MyPageTallyView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/10/24.
//

import UIKit

class MyPageTallyView: UIView {
    
    //MARK: - UI Components
    
    private let backGroundView = UIView()
    private var tallyView = UIView()
    private var userNameButton = UIButton()
    private var registerView = MyPageTallyReuseView()
    private var recordView = MyPageTallyReuseView()
    private var dividerView = UIView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
        dataBind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - set UI
    
    private func setUI() {
        self.backgroundColor = .White
        
        backGroundView.backgroundColor = .Gray50
        
        tallyView.do {
            $0.backgroundColor = .White
            $0.layer.cornerRadius = 15
            
            userNameButton.do {
                $0.setTitle("신지원님", for: .normal)
                $0.setTitleColor(.Black, for: .normal)
                $0.titleLabel?.font = .HeadLine1
            }
            
            dividerView.do {
                $0.backgroundColor = .Gray70
            }
        }
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(backGroundView,
                         tallyView)
        tallyView.addSubviews(userNameButton,
                              dividerView,
                              registerView,
                              recordView)
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
            
            userNameButton.snp.makeConstraints() {
                $0.top.equalToSuperview().inset(18)
                $0.centerX.equalToSuperview()
            }
            
            dividerView.snp.makeConstraints() {
                $0.top.equalTo(userNameButton.snp.bottom).offset(20)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().inset(18)
                $0.width.equalTo(1)
            }
            
            registerView.snp.makeConstraints() {
                $0.top.equalTo(dividerView.snp.top)
                $0.leading.equalToSuperview()
                $0.trailing.equalTo(dividerView.snp.leading)
                $0.bottom.equalToSuperview().inset(18)
            }
            
            recordView.snp.makeConstraints() {
                $0.top.equalTo(dividerView.snp.top)
                $0.trailing.equalToSuperview()
                $0.leading.equalTo(dividerView.snp.trailing)
                $0.bottom.equalToSuperview().inset(18)
            }
        }
    }
    
    //MARK: - dataBind 
    //추후 수정 예정
    
    func dataBind() {
        registerView.titleIconImageView = UIImageView(image: ImageLiterals.icon.calender)
        registerView.titleLabel.text = "등록 작품"
        registerView.tallyLabel.text = "0"
        recordView.titleIconImageView = UIImageView(image: ImageLiterals.icon.calender)
        recordView.titleLabel.text = "기록"
        recordView.tallyLabel.text = "100"
    }
    
}
