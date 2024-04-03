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
    
    var titleUpdateSubject = PublishSubject<(UIView, String)>()
    
    private init() {
        setupBindings()
    }
    
    private func setupBindings() {
        titleUpdateSubject
            .subscribe(onNext: { [weak self] mainView, title in
                guard let dropdownView = self?.dropdowns[mainView] else { return }
                if let mainView = mainView as? WSSDropdown {
                    dropdownView.isHidden.toggle()
                }
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Create Dropdown
    
    func createDropdown(viewController: UIViewController,
                        dropdownWidth: CGSize,
                        dropdownData: [String]) {
        
        let mainView = WSSDropdown()
        let dropdownView = WSSDropdownTableView()
        dropdownView.dropdownData.onNext(dropdownData)
        dropdownView.isHidden = true
        
        viewController.view.addSubview(dropdownView)
        
        dropdownView.snp.makeConstraints {
            $0.top.equalTo(mainView.snp.bottom)
            $0.width.equalTo(dropdownWidth)
            
            let calculateHeight = CGFloat(dropdownData.count) * 51.0
            $0.height.equalTo(calculateHeight)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(dropdownTapped(_:)))
        mainView.addGestureRecognizer(tapGesture)
        
        dropdowns[mainView] = dropdownView
    }
    
    @objc
    private func dropdownTapped(_ sender: UITapGestureRecognizer) {
        print("🎈")
        guard let mainView = sender.view, let dropdownView = dropdowns[mainView] else { return }
        dropdownView.isHidden.toggle()
    }
}
