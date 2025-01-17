//
//  NovelDetailFeedListView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/27/24.
//

import UIKit

import SnapKit
import Then

final class FeedListView: UIView {
    
    //MARK: - Components
    
    let feedTableView = UITableView(frame: .zero, style: .plain)
    let dropdownView = FeedDetailDropdownView()
    
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
        feedTableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
            $0.isScrollEnabled = false
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
        feedTableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        dropdownView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    //MARK: - Custom Method
    
    func updateTableViewBottom() {
        feedTableView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(28)
        }
    }
    
    func updateTableViewHeight(height: CGFloat) {
        feedTableView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
    
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
