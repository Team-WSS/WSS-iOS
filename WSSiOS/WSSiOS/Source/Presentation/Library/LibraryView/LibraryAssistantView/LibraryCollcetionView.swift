//
//  View.swift
//  WSSiOS
//
//  Created by 신지원 on 1/14/24.
//

import UIKit

class LibraryCollcetionView: UIView {

    //MARK: - UI Components

    
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
    
    //MARK: - set UI
    
    private func setUI() {
        
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews()
    }
    
    //MARK: - set Layout
    
    private func setLayout() {

    }
}
