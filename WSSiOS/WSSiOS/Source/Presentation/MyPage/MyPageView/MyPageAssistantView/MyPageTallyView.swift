//
//  MyPageTallyView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/10/24.
//

import UIKit

final class MyPageTallyView: UIView {
    
    //MARK: - UI Components
    
    private let backGroundView = UIView()
    private var tallyView = UIView()
    var myPageUserNameButton = UIButton()
    var myPageRegisterView = MyPageTallyReuseView()
    var myPageRecordView = MyPageTallyReuseView()
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
            
            myPageUserNameButton.do {
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
    
    //MARK: - dataBind 
    //추후 수정 예정
    
    func dataBind() {
        myPageRegisterView.titleIconImageView = UIImageView(image: ImageLiterals.icon.calender)
        myPageRegisterView.titleLabel.text = "등록 작품"
        myPageRegisterView.tallyLabel.text = "0"
        myPageRecordView.titleIconImageView = UIImageView(image: ImageLiterals.icon.calender)
        myPageRecordView.titleLabel.text = "기록"
        myPageRecordView.tallyLabel.text = "100"
    }
    
}
