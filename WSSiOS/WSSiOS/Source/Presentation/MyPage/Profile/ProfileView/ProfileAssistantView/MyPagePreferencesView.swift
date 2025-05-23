//
//  MyPagePreferencesView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/23/25.
//

import UIKit

import SnapKit
import Then

final class MyPagePreferencesView: UIView {
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    let myPageGenrePreferencesView = UserGenrePreferencesView()
    let myPageNovelPreferencesView = UserPageNovelPreferencesView()
    private let preferencesEmptyView = UserPagePreferencesEmptyView()
    
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
        self.backgroundColor = .wssWhite
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
        }
        
        //preferencesEmptyView.isHidden = true
    }
    
    private func setHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubviews(myPageGenrePreferencesView,
                                      myPageNovelPreferencesView)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        myPageGenrePreferencesView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func updateGenreViewHeight(isExpanded: Bool) {
        myPageGenrePreferencesView.snp.updateConstraints {
            $0.height.equalTo(isExpanded ? 514 : 224.5)
        }
    }
}
