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

class LibraryTabCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier: String = "LibraryTabCollectionViewCell"
    let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    public var libraryTabButton = UIButton()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
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
    
    private func selectUI() {
        libraryTabButton.titleLabel?.textColor = isSelected ? .Primary100 : .Gray200
    }
    
    //MARK: - Set UI
    
    private func setUI() {
        libraryTabButton.do {
            $0.setTitleColor(.Gray200, for: .normal)
            $0.titleLabel?.font = .Body1
            $0.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    //MARK: - Set Hierachy
    
    private func setHierachy() {
        self.addSubview(libraryTabButton)
    }
    
    //MARK: - Set Layout
    
    private func setLayout() {
        libraryTabButton.snp.makeConstraints() {
            $0.edges.equalToSuperview()
        }
    }
}
