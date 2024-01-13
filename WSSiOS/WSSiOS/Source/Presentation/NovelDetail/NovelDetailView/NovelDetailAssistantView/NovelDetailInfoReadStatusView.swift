//
//  NovelDetailInfoReadStatusView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/12/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoReadStatusView: UIView {
    
    // MARK: - UI Components
    
    private let dividerView = UIView()
    private let readStatusLabel = UILabel()
    private let readStatusTagView = NovelDetailInfoReadStatusTagView()
    
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
        dividerView.do {
            $0.backgroundColor = .Gray50
        }
        
        readStatusLabel.do {
            $0.text = "읽기 상태"
            $0.textColor = .Black
            $0.font = .Title1
        }
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(dividerView,
                         readStatusLabel,
                         readStatusTagView)
    }
    
    // MARK: - set Layout
    
    private func setLayout() {
        dividerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(7)
        }
        
        readStatusLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(35)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        readStatusTagView.snp.makeConstraints {
            $0.top.equalTo(readStatusLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    func bindData(status: String) {
        switch status {
        case "FINISH":
            self.readStatusTagView.bindData(.FINISH)
        case "READING":
            self.readStatusTagView.bindData(.READING)
        case "DROP":
            self.readStatusTagView.bindData(.DROP)
        case "WISH":
            self.readStatusTagView.bindData(.WISH)
        default:
            break
        }
    }
}
