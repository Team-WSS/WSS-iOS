//
//  MyPageTallyView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/10/24.
//

import UIKit

class MyPageTallyView: UIView {

    //MARK: - set Properties
    
    private var userNameButton = UIButton()
    private var register
    private var dividerView = UIView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
        dataBind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - set UI
    
    private func setUI() {
        self.backgroundColor = .Gray50
        
        
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        
    }
    
    //MARK: - set Layout
    
    private func setLayout() {
        
    }
    
    func dataBind() {
    }

}
