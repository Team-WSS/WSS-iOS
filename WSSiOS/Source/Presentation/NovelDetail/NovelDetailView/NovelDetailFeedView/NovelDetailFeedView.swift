//
//  NovelDetailFeedView.swift
//  WSSiOS
//
//  Created by 이윤학 on 6/23/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailFeedView: UIButton {
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    private let emptyView = NovelDetailFeedEmptyView()
    let feedListView = FeedListView()
    
    //MARK: - Life Cycle
    
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
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
        }
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(feedListView)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(28)
        }
    }
    
    //MARK: - Data
    
    func bindData(isEmpty: Bool) {
        if isEmpty {
            feedListView.removeFromSuperview()
            stackView.addArrangedSubview(emptyView)
        } else {
            emptyView.removeFromSuperview()
            stackView.addArrangedSubview(feedListView)
        }
    }
}
