//
//  HomeRealtimePopularContentView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/21/24.
//

import UIKit

final class HomeRealtimePopularContentView: UIView {
    
    //MARK: - UI Components
    
    private let contentLabel = UILabel()
    private let likeImageView = UIImageView()
    private let likeCountLabel = UILabel()
    private let commentImageView = UIImageView()
    private let commendCountLabel = UILabel()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        contentLabel.do {
            
        }
    }
    
    private func setHierarchy() {
        
    }
    
    private func setLayout() {
        
    }
}
