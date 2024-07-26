//
//  WSSDivideView.swift
//  WSSiOS
//
//  Created by 신지원 on 7/26/24.
//

import UIKit

import SnapKit
import Then

final class WSSDivideView: UIView {
    
    //MARK: - Components
    
    private let divideView = UIView()
    
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
        self.backgroundColor = .clear
        
        divideView.backgroundColor = .wssGray50
    }
    
    private func setHierarchy() {
        self.addSubview(divideView)
    }
    
    private func setLayout() {
        divideView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    } 
}



