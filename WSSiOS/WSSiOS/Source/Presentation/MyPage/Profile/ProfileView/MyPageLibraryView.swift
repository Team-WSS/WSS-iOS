//
//  MyPageLibraryView.swift
//  WSSiOS
//
//  Created by 신지원 on 11/16/24.
//

import UIKit

import SnapKit
import Then

final class MyPageLibraryView: UIView {
    
    //MARK: - Properties
    
    let isEmpty: Bool
    
    //MARK: - Components
    
    let inventoryView = MyPageInventoryView()
    let preferencesEmptyView = MyPagePreferencesEmptyView()
    
    // MARK: - Life Cycle
    
    init(isEmpty: Bool) {
        self.isEmpty = isEmpty
        super.init(frame: .zero)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.backgroundColor = .wssGray50
    }
    
    private func setHierarchy() {
        if isEmpty {
            self.addSubviews(inventoryView,
                             preferencesEmptyView)
        } else {
            self.addSubviews(inventoryView,
                             preferencesEmptyView)
        }
    }
    
    private func setLayout() {
        inventoryView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(160)
        }
        
        if isEmpty {
            preferencesEmptyView.snp.makeConstraints {
                $0.top.equalTo(inventoryView.snp.bottom).offset(3)
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(363)
            }
        } else {
            preferencesEmptyView.snp.makeConstraints {
                $0.top.equalTo(inventoryView.snp.bottom).offset(3)
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(363)
            }
        }
    }
}



