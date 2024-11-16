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
    
    // MARK: - Properties
    
    var isExist: Bool = true {
        didSet {
            updateView(isExist: isExist)
        }
    }
    
    // MARK: - Components
    
    let stackView = UIStackView()
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
    
    private func setUI() {
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 3
            $0.alignment = .fill
            $0.distribution = .fill
        }
    }
    
    private func setHierarchy() {
         self.addSubview(stackView)
     }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        inventoryView.snp.makeConstraints {
            $0.height.equalTo(160)
        }
        
        genrePrefrerencesView.snp.makeConstraints {
            $0.height.equalTo(221.5)
        }
        
        novelPrefrerencesView.snp.makeConstraints {
            $0.height.equalTo(270)
        }
    }
    
    func updateGenreViewHeight(isExpanded: Bool) {
        genrePrefrerencesView.snp.updateConstraints {
            $0.height.equalTo(isExpanded ? 514 : 224.5)
        }
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func updateView(isExist: Bool) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if isExist {
            stackView.addArrangedSubviews(inventoryView,
                                          genrePrefrerencesView,
                                          novelPrefrerencesView)
        } else {
            stackView.addArrangedSubviews(inventoryView,
                                          preferencesEmptyView)
            
            preferencesEmptyView.snp.remakeConstraints {
                $0.height.equalTo(363)
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}


