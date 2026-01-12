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
    var cellTextColor: UIColor = .red
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    let dropdownTableView = UITableView()
    var dropdownShadowView = UIView()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        setDropdown()
        
        setRegister()
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dropdownShadowView.frame = dropdownTableView.frame
        setShadowView()
    }
    
    // MARK: - UI
    
    private func setRegister() {
        dropdownTableView.register(WSSDropdownTableViewCell.self,
                                   forCellReuseIdentifier: WSSDropdownTableViewCell.cellIdentifier)
    }
    
    private func setUI() {
        dropdownTableView.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 14
            $0.layer.masksToBounds = true
            $0.isScrollEnabled = false
            $0.separatorStyle = .none
            $0.rowHeight = 51.0
        }
        
        dropdownShadowView.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 14
            $0.clipsToBounds = false
        }
        
        setShadowView()
    }
    
    private func setHierarchy() {
        addSubview(dropdownTableView)
        insertSubview(dropdownShadowView, belowSubview: dropdownTableView)
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
                    cell.bindText(text: text, color: self.cellTextColor)
                    cell.selectionStyle = .none
                }
                .disposed(by: disposeBag)
    }
    
    private func setShadowView() {
        let shadowPath = UIBezierPath(roundedRect: dropdownShadowView.bounds, cornerRadius: 0)
        let shadowLayer = CALayer()
        shadowLayer.do {
            $0.shadowPath = shadowPath.cgPath
            $0.shadowColor = UIColor(resource: .wssBlack).withAlphaComponent(0.11).cgColor
            $0.shadowOpacity = 1
            $0.shadowRadius = 15
            $0.shadowOffset = CGSize(width: 0, height: 2)
        }
        
        dropdownShadowView.layer.insertSublayer(shadowLayer, at: 0)
    }
}
