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
    
    var isExist: Bool = true {
        didSet {
            updateView(isExist: isExist)
        }
    }
    
    //MARK: - Components
    
    let inventoryView = MyPageInventoryView()
    
    let preferencesEmptyView = MyPagePreferencesEmptyView()
    
    let genrePrefrerencesView = MyPageGenrePreferencesView()
    let novelPrefrerencesView = MyPageNovelPreferencesView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
        updateView(isExist: isExist)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.backgroundColor = .wssGray50
    }
    
    private func setHierarchy() {
        if !isExist {
            self.addSubviews(inventoryView,
                             preferencesEmptyView)
        } else {
            self.addSubviews(inventoryView,
                             genrePrefrerencesView,
                             novelPrefrerencesView)
        }
    }
    
    private func setLayout() {
        inventoryView.snp.remakeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(160)
        }
        
        if !isExist {
            preferencesEmptyView.snp.makeConstraints {
                $0.top.equalTo(inventoryView.snp.bottom).offset(3)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(363)
                $0.bottom.equalToSuperview()
            }
        } else {
            genrePrefrerencesView.snp.makeConstraints {
                $0.top.equalTo(inventoryView.snp.bottom).offset(3)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(221.5)
            }
            
            novelPrefrerencesView.snp.makeConstraints {
                $0.top.equalTo(genrePrefrerencesView.snp.bottom).offset(3)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(270)
                $0.bottom.equalToSuperview()
            }
        }
    }
    
    func updateView(isExist: Bool) {
        subviews.forEach { $0.removeFromSuperview() }
        
        setHierarchy()
        setLayout()
        
        layoutIfNeeded()
    }
}



