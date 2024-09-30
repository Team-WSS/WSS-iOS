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
                        textColor: UIColor) -> Observable<String> {
        
        let dropdownTableView = WSSDropdownTableView().then {
            $0.dropdownData.onNext(dropdownData)
            $0.isHidden = true
            $0.cellTextColor = textColor
        }
        
        dropdownRootView.addSubview(dropdownTableView)
        
        DispatchQueue.main.async {
            dropdownTableView.snp.makeConstraints {
                if let window = dropdownButton.window {
                    let buttonFrame = dropdownButton.convert(dropdownButton.bounds, to: window)
                    $0.top.equalTo(dropdownRootView.snp.top).offset(buttonFrame.maxY + 0.5)
                }
                $0.trailing.equalToSuperview().inset(20.5)
                $0.width.equalTo(dropdownWidth)
                
                let calculateHeight = CGFloat(dropdownData.count) * 51.0
                $0.height.equalTo(calculateHeight)
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(dropdownTapped(_:)))
        dropdownButton.addGestureRecognizer(tapGesture)
        dropdowns[dropdownButton] = dropdownTableView
        
        return tapCell(dropdownView: dropdownTableView)
    }
    
    @objc
    private func dropdownTapped(_ sender: UITapGestureRecognizer) {
        guard let mainView = sender.view, let dropdownView = dropdowns[mainView] else { return }
        dropdownView.isHidden.toggle()
    }
}

extension WSSDropdownManager {
    func tapCell(dropdownView: WSSDropdownTableView) -> Observable<String> {
        
        let tapCellIndex = BehaviorSubject<String>(value: "")
        
        dropdownView.dropdownTableView.rx.modelSelected(String.self)
            .subscribe(onNext: { cell in
                tapCellIndex.onNext(cell)
                dropdownView.isHidden.toggle()
            })
            .disposed(by: disposeBag)
        return tapCellIndex.asObservable()
    }
}
