//
//  NovelDetailMemoView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailMemoView: UIView {

    // MARK: - UI Components
    
    private let novelDetailCreateMemoView = NovelDetailCreateMemoView()

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
        self.backgroundColor = .Gray70
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(novelDetailCreateMemoView)
    }
    
    // MARK: - set Layout
    
    private func setLayout() {
        novelDetailCreateMemoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
    }
}
