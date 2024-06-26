//
//  NovelDetailInfoView.swift
//  WSSiOS
//
//  Created by 이윤학 on 6/23/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoView: UIView {
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    
    //MARK: - Life Cycle
    
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
        self.backgroundColor = .wssGray50
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .center
        }
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
    }
    
    private func setLayout() {
        stackView.do {
            $0.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.bottom.equalToSuperview().inset(16)
                $0.horizontalEdges.equalToSuperview()
            }
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailHeaderResult) {
        
    }
}
