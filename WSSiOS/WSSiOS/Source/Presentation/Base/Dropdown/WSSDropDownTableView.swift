//
//  WSSDropDownTableView.swift
//  WSSiOS
//
//  Created by 신지원 on 4/1/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class WSSDropdownTableView: UIView {
    
    // MARK: - Properties
    
    var dropdownData: BehaviorSubject<[String]> = BehaviorSubject(value: [])
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    let dropdownTableView = UITableView()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        setDropdown()
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setUI() {
        dropdownTableView.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 12
            $0.layer.masksToBounds = true
            $0.register(WSSDropdownTableViewCell.self,
                        forCellReuseIdentifier: WSSDropdownTableViewCell.cellIdentifier)
            $0.isScrollEnabled = false
            $0.separatorStyle = .none
            $0.rowHeight = 51.0
        }
    }
    
    private func setHierarchy() {
        addSubview(dropdownTableView)
    }
    
    private func setLayout() {
        dropdownTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    private func setDropdown() {
        dropdownData
            .bind(to: dropdownTableView.rx.items(
                cellIdentifier: WSSDropdownTableViewCell.cellIdentifier,
                cellType: WSSDropdownTableViewCell.self)) { row, text, cell in
                    cell.bindText(text: text)
                }
                .disposed(by: disposeBag)
    }
}

