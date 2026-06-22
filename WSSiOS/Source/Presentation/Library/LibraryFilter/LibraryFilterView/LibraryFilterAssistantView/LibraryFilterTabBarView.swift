//
//  LibraryFilterTabBarView.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/21/26.
//

import UIKit

import SnapKit
import Then

final class LibraryFilterTabBarView: UIView {
    
    //MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    let tabButtons = LibraryFilterTab.allCases.map {
        LibraryFilterTabButton($0)
    }
    
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
        scrollView.do {
            $0.showsHorizontalScrollIndicator = false
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.alignment = .center
        }
    }

    private func setHierarchy() {
        self.addSubviews(scrollView)
        scrollView.addSubview(stackView)
        tabButtons.forEach {
            stackView.addArrangedSubview($0)
        }
    }

    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(30)
        }

        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.verticalEdges.equalTo(scrollView.contentLayoutGuide)
            $0.leading.equalTo(scrollView.contentLayoutGuide).inset(20)
            $0.trailing.equalTo(scrollView.contentLayoutGuide).inset(20)
            $0.height.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func updateSelectedTab(_ tab: LibraryFilterTab) {
        tabButtons.forEach {
            $0.setSelected($0.tab == tab)
        }
    }
    
    func updateDots(_ activeTabs: Set<LibraryFilterTab>) {
        tabButtons.forEach {
            $0.setDot(activeTabs.contains($0.tab))
        }
    }
}
