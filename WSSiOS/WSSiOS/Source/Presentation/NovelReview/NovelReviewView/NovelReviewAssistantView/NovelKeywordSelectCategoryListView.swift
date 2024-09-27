//
//  NovelKeywordSelectCategoryListView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/28/24.
//

import UIKit

import SnapKit
import Then

final class NovelKeywordSelectCategoryListView: UIView {
    
    //MARK: - Components
    
    private let scrollView = UIScrollView()
    let stackView = UIStackView()
    
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
        scrollView.do {
            $0.backgroundColor = .wssGray50
            $0.showsVerticalScrollIndicator = false
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 14
            $0.distribution = .equalSpacing
        }
    }
    
    private func setHierarchy() {
        self.addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
//            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(40)
            $0.width.equalToSuperview()
        }
    }
}
