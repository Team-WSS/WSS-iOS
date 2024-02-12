//
//  LibraryTabCollectionViewCell.swift
//  WSSiOS
//
//  Created by 신지원 on 1/15/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class LibraryTabCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier: String = "LibraryTabCollectionViewCell"
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let libraryTabLabel = UILabel()
    private let libraryTabUnderView = UIView()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            selectUI()
        }
    }
    
    //MARK: - UI
    
    private func setUI() {
        libraryTabLabel.do {
            $0.textColor = .Gray200
            $0.font = .Body1
            $0.backgroundColor = .clear
            $0.textAlignment = .center
        }
        
        libraryTabUnderView.do {
            $0.backgroundColor = .Primary100
            $0.isHidden = true
        }
    }

    private func setHierarchy() {
        self.addSubviews(libraryTabLabel,
                         libraryTabUnderView)
    }
    
    private func setLayout() {
        libraryTabLabel.snp.makeConstraints() {
            $0.center.equalToSuperview()
        }
        
        libraryTabUnderView.snp.makeConstraints() {
            $0.width.equalTo(libraryTabLabel.snp.width)
            $0.centerX.bottom.equalToSuperview()
            $0.height.equalTo(3)
        }
    }
    
    private func selectUI() {
        libraryTabLabel.textColor = isSelected ? .Primary100 : .Gray200
        libraryTabUnderView.isHidden = isSelected ? false : true
    }
    
    //MARK: - Data
    
    func bindData(data: String) {
        libraryTabLabel.text = data
    }
}
