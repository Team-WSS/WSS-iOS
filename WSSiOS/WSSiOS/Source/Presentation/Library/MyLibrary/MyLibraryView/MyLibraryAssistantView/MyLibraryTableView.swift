//
//  MyLibraryTableView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 6/27/25.
//

import UIKit

import SnapKit
import Then

final class MyLibraryTableView: UIView {
    
    //MARK: - Components
    
    let libraryTableView = UITableView(frame: .zero, style: .plain)
    
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
        libraryTableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
        }
    }
    
    private func setHierarchy() {
        self.addSubview(libraryTableView)
    }
    
    private func setLayout() {
        libraryTableView.snp.makeConstraints() {
            $0.edges.equalToSuperview()
        }
    }
    
    func updateTableViewHeight(height: CGFloat) {
        libraryTableView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
}
