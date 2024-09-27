//
//  WSSDropdownManager.swift
//  WSSiOS
//
//  Created by 신지원 on 4/1/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class WSSDropdownManager {
    
    // MARK: - Properties
    
    static let shared = WSSDropdownManager()
    private var dropdowns: [UIView: WSSDropdownTableView] = [:]
    private let disposeBag = DisposeBag()
    
    // MARK: - Create Dropdown
    
    func createDropdown(dropdownRootView: UIView,
                        dropdownButton: WSSDropdownButton,
                        dropdownWidth: Double,
                        dropdownData: [String],
                        textColor: UIColor) {
        
        let dropdownTableView = WSSDropdownTableView()
        dropdownTableView.dropdownData.onNext(dropdownData)
        dropdownTableView.isHidden = true
        dropdownTableView.cellTextColor = textColor

        dropdownRootView.addSubview(dropdownTableView)
        
        dropdownTableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(100)
            $0.trailing.equalToSuperview().inset(20.5)
            $0.width.equalTo(dropdownWidth)
            
            let calculateHeight = CGFloat(dropdownData.count) * 51.0
            $0.height.equalTo(calculateHeight)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(dropdownTapped(_:)))
        dropdownButton.addGestureRecognizer(tapGesture)
        dropdowns[dropdownButton] = dropdownTableView
        tapCell(dropdownView: dropdownTableView)
    }
    
    @objc
    private func dropdownTapped(_ sender: UITapGestureRecognizer) {
        guard let mainView = sender.view, let dropdownView = dropdowns[mainView] else { return }
        dropdownView.isHidden.toggle()
    }
}

extension WSSDropdownManager {
    private func tapCell(dropdownView: WSSDropdownTableView) {
        dropdownView.dropdownTableView.rx.modelSelected(String.self)
            .subscribe(onNext: { cell in
                print(cell)
                dropdownView.isHidden.toggle()
            })
            .disposed(by: disposeBag)
    }
}
