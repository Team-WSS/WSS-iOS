//
//  NovelDetailHeaderReadStatusButton.swift
//  WSSiOS
//
//  Created by YunhakLee on 8/20/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailHeaderReadStatusButton: UIButton {
    
    //MARK: - Properties
    
    let readStatus: ReadStatus
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    private let statusImageView = UIImageView()
    private let statusLabel = UILabel()
    
    //MARK: - Life Cycle
    
    init(readStatus: ReadStatus) {
        self.readStatus = readStatus
        super.init(frame: .zero)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        stackView.do {
            $0.axis = .vertical
            $0.alignment =  .center
        }
        
        statusImageView.do {
            
        }
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        
        stackView.addArrangedSubview(dummyLabel)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(15)
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailHeaderResult) {
        
    }
    
    //MARK: - Custom Method
    
    // 별점으로 디자인이 유지되면 사용예정인 메서드
    private func createStars() -> [UIImageView] {
        return (0..<5).map { _ in
            let starImageView = UIImageView().then {
                $0.isUserInteractionEnabled = true
                $0.image = .icStarEmpty
                $0.contentMode = .scaleToFill
                $0.clipsToBounds = true
            }
            return starImageView
        }
    }
}
