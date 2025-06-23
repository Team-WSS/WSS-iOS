//
//  FeedPageContentView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/14/24.
//

import UIKit

import SnapKit
import Then

final class FeedPageContentView: UIView {
    
    //MARK: - Components
    
    let myFeedFilterHeaderView = MyFeedFilterHeaderView()
    private let emptyView = NovelDetailFeedEmptyView()
    let feedTableView = UITableView(frame: .zero, style: .plain)
    let dropdownView = FeedDetailDropdownView()
    
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
        
        emptyView.do {
            $0.isHidden = true
        }
        
        feedTableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.refreshControl = UIRefreshControl()
            $0.separatorStyle = .none
        }
        
        dropdownView.do {
            $0.isHidden = true
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(emptyView,
                         feedTableView,
                         dropdownView)
    }
    
    private func setLayout() {
        emptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        feedTableView.snp.makeConstraints() {
            $0.edges.equalToSuperview()
        }
        
        dropdownView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    //MARK: - Custom Method
    
    func showDropdownView(indexPath: IndexPath, isMyFeed: Bool) {
        dropdownView.do {
            $0.configureDropdown(isMine: isMyFeed)
            $0.isHidden = false
        }
        updateDropdownViewLayout(indexPath: indexPath)
    }
    
    func hideDropdownView() {
        dropdownView.isHidden = true
    }
    
    func toggleDropdownView() {
        dropdownView.isHidden.toggle()
    }
    
    func updateDropdownViewLayout(indexPath: IndexPath) {
        guard let cell = feedTableView.cellForRow(at: indexPath) else { return }

        let cellFrameInSuperview = cell.convert(cell.bounds, to: self)
        
        dropdownView.snp.updateConstraints {
            $0.top.equalToSuperview().inset(cellFrameInSuperview.minY + 58)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    //MARK: - Data
    
    func bindData(isEmpty: Bool) {
        if isEmpty {
            emptyView.isHidden = false
            feedTableView.isHidden = true
        } else {
            emptyView.isHidden = true
            feedTableView.isHidden = false
        }
    }
    
    func setFeedPageContentView(pageType: FeedPageType) {
        if pageType == .my {
            addFilterHeaderView()
        }
    }
    
    func addFilterHeaderView() {
        self.insertSubview(myFeedFilterHeaderView, at: 0)
        
        myFeedFilterHeaderView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        feedTableView.snp.remakeConstraints {
            $0.top.equalTo(myFeedFilterHeaderView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
}
