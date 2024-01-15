//
//  LibraryListView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/15/24.
//

import UIKit

import SnapKit
import Then

final class LibraryListView: UIView {
    
    //MARK: - UI Components
    
    private let libraryStackView = UIStackView()
    
    //추후 양이 많아지면 collectionView 로 빼겠습니당
    public let libraryNewestButton = UIButton()
    public let libraryOldesttButton = UIButton()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - set UI
    
    private func setUI() {
        self.backgroundColor = .White
        
        libraryStackView.do {
            $0.axis = .vertical
            $0.alignment = .center
            $0.distribution = .fillEqually
            $0.spacing = 0
        }
        
        libraryNewestButton.setTitle("오래된 순", for: .normal)
        libraryOldesttButton.setTitle("최신 순", for: .normal)
        [libraryNewestButton,libraryOldesttButton].forEach {
            $0.do {
                $0.setTitleColor(.Black, for: .normal)
                $0.titleLabel?.font = .Body2
            }
        }
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubview(libraryStackView)
        libraryStackView.addArrangedSubviews(libraryNewestButton,
                                             libraryOldesttButton)
    }
    
    //MARK: - set Layout
    
    private func setLayout() {
        libraryStackView.snp.makeConstraints() {
            $0.edges.equalToSuperview()
        }
    }
}
