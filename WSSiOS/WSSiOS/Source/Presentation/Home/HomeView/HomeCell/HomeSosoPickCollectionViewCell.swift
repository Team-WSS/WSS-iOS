//
//  HomeSosoPickCollectionViewCell.swift
//  WSSiOS
//
//  Created by 최서연 on 1/11/24.
//

import UIKit

final class HomeSosoPickCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier: String = "HomeSosoPickCollectionViewCell"
    
    //MARK: - UI Components
    
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .Primary80
            $0.layer.cornerRadius = 12
        }
    }
    
    private func setHierachy() {
        
    }
    
    private func setLayout() {
        
    }
}


