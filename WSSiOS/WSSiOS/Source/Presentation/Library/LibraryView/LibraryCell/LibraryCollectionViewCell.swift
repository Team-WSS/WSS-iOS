//
//  LibraryCollectionViewCell.swift
//  WSSiOS
//
//  Created by 신지원 on 1/14/24.
//

import UIKit

class LibraryCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier: String = "LibraryCollectionViewCell"
    
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
    
    //MARK: - Set UI
    
    private func setUI() {
    
    }
    
    //MARK: - Set Hierachy
    
    private func setHierachy() {
        
    }
    
    //MARK: - Set Layout
    
    private func setLayout() {
       
    }
    
}
