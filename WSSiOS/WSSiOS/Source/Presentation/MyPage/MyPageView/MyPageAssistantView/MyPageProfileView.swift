//
//  myPageProfileView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/10/24.
//

import UIKit

import SnapKit
import Then

class MyPageProfileView: UIView {
    
    //MARK: - set Properties
    
    private let myBadgeImageView = UIImageView()
    private let avaterNameLabel = UILabel()
    private var avaterPhraseLabel = UILabel()
    private var avarterImageView = UIImageView()
    
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
        self.backgroundColor = .Gray50
        
        avaterNameLabel.do {
            $0.font = .Title1
            $0.textColor = .Gray300
            $0.textAlignment = .center
        }
        
        avaterPhraseLabel.do {
            $0.font = .Body2
            $0.textColor = .Gray300
            $0.textAlignment = .center
        }
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(myBadgeImageView,
                         avaterNameLabel,
                         avaterPhraseLabel,
                         avarterImageView)
    }
    
    //MARK: - set Layout
    
    private func setLayout() {
        myBadgeImageView.snp.makeConstraints() {
            $0.top.equalTo(super.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(40)
        }
        
        avaterNameLabel.snp.makeConstraints() {
            $0.top.equalTo(myBadgeImageView.snp.bottom).offset(13)
            $0.centerX.equalToSuperview()
        }
        
        avaterPhraseLabel.snp.makeConstraints() {
            $0.top.equalTo(avaterNameLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        avarterImageView.snp.makeConstraints() {
            $0.top.equalTo(avaterPhraseLabel.snp.bottom).offset(23)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(220)
        }
    }
    
    func dataBind() {
        avaterNameLabel.text = "추락한 악역영애"
        avaterPhraseLabel.text = "김명진 영애, 오늘도 왔구나?"
        avarterImageView.image = UIImage(named: "avaterExample")
        myBadgeImageView.image = ImageLiterals.icon.icBadge.RF
    }
}
