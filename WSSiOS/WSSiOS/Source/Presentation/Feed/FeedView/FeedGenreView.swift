//
//  FeedGenreView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/14/24.
//

import UIKit

import SnapKit
import Then

final class FeedGenreView: UIView {
    
    //MARK: - Components
    
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
        self.addSubviews(feedTableView,
                         dropdownView)
    }
    
    private func setLayout() {
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
}
