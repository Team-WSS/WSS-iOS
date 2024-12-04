//
//  MyPageFeedDetailView.swift
//  WSSiOS
//
//  Created by 신지원 on 12/3/24.
//

import UIKit

import SnapKit
import Then

final class MyPageFeedDetailView: UIView {
    
    //MARK: - Components
    
    let myPageFeedDetailTableView = UITableView(frame: .zero, style: .plain)
    let dropdownView = FeedDetailDropdownView()
    
    //In VC
    let backButton = UIButton()

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
        myPageFeedDetailTableView.do {
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
        }
        
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    private func setHierarchy() {
        self.addSubview(myPageFeedDetailTableView)
    }
    
    private func setLayout() {
        myPageFeedDetailTableView.snp.makeConstraints() {
            $0.edges.equalToSuperview()
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
        guard let cell = myPageFeedDetailTableView.cellForRow(at: indexPath) else { return }

        let cellFrameInSuperview = cell.convert(cell.bounds, to: self)
        
        dropdownView.snp.updateConstraints {
            $0.top.equalToSuperview().inset(cellFrameInSuperview.minY + 58)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}

