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
    
    func createDropdown(rootView: UIView,
                        mainView: WSSDropdown,
                        dropdownWidth: Double,
                        dropdownData: [String],
                        textColor: UIColor) {
        
        let dropdownView = WSSDropdownTableView()
        dropdownView.dropdownData.onNext(dropdownData)
        dropdownView.isHidden = true
        dropdownView.cellTextColor = textColor
        
        rootView.addSubviews(mainView,
                             dropdownView)
        
        dropdownView.snp.makeConstraints {
            $0.top.equalTo(mainView.snp.bottom)
            $0.trailing.equalTo(mainView.snp.trailing)
            $0.width.equalTo(dropdownWidth)
            
            let calculateHeight = CGFloat(dropdownData.count) * 51.0
            $0.height.equalTo(calculateHeight)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(dropdownTapped(_:)))
        mainView.addGestureRecognizer(tapGesture)
        dropdowns[mainView] = dropdownView
        tapCell(dropdownView: dropdownView)
    }
    
    @objc
    private func dropdownTapped(_ sender: UITapGestureRecognizer) {
        guard let mainView = sender.view, let dropdownView = dropdowns[mainView] else { return }
        dropdownView.isHidden.toggle()
    }
}

extension WSSDropdownManager {
    private func tapCell(dropdownView: WSSDropdownTableView) {
        
        //String 뱉고 싶을 때
        dropdownView.dropdownTableView.rx.modelSelected(String.self)
            .subscribe(onNext: { cell in
                print(cell)
                dropdownView.isHidden.toggle()
            })
            .disposed(by: disposeBag)
        
        //index 뱉고 싶을 때
//        dropdownView.dropdownTableView.rx.itemSelected
//            .subscribe(onNext: { indexPath in
//                print(indexPath.row)
//                dropdownView.isHidden.toggle()
//            })
//            .disposed(by: disposeBag)
    }
}
