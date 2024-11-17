//
//  MyPageGenrePreferencesOtherView.swift
//  WSSiOS
//
//  Created by 신지원 on 11/16/24.
//

import UIKit

import SnapKit
import Then

final class MyPageGenrePreferencesOtherView: UIView {

    //MARK: - Components

    let genreTableView = UITableView(frame: .zero, style: .plain)
    
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
        self.backgroundColor = .wssWhite
        
        genreTableView.do {
            $0.rowHeight = 40
            $0.isScrollEnabled = false
            $0.separatorStyle = .none
            $0.delaysContentTouches = false
        }
    }
    
    private func setHierarchy() {
        self.addSubview(genreTableView)
    }
    
    private func setLayout() {
        genreTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}




