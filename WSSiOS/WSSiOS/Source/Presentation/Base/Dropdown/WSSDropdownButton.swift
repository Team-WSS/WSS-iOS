//
//  WSSDropdownButton.swift
//  WSSiOS
//
//  Created by 신지원 on 4/3/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class WSSDropdownButton: UIButton { 
    
    // MARK: - UI Components
    
    private let disposeBag = DisposeBag()
    private let dropdownImageView = UIImageView()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        dropdownImageView.do {
            $0.image = .icThreedots.withRenderingMode(.alwaysOriginal).withTintColor(.wssBlack)
        }
    }
    
    private func setHierarchy() {
        addSubview(dropdownImageView)
    }
    
    private func setLayout() {
        dropdownImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.size.equalTo(18)
        }
    }
    
    func makeDropdown(dropdownRootView: UIView,
                      dropdownWidth: Double,
                      dropdownLayout: SelfLayout = .autoInNavigationBar,
                      dropdownData: [String],
                      textColor: UIColor,
                      customLayout: @escaping (UIView) -> Void = { _ in }) -> Observable<String> {
        
        let tapCellIndex = WSSDropdownManager.shared.createDropdown(dropdownButton: self,
                                                                    dropdownRootView: dropdownRootView,
                                                                    dropdownLayout: dropdownLayout,
                                                                    dropdownWidth: dropdownWidth,
                                                                    dropdownData: dropdownData,
                                                                    textColor: textColor,
                                                                    customLayout: customLayout)
       
        return tapCellIndex
    }
}
