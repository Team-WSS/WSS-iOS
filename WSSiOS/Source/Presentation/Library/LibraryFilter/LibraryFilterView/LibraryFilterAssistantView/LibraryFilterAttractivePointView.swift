//
//  LibraryFilterAttractivePointView.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/26/25.
//

import UIKit

import SnapKit
import Then

final class LibraryFilterAttractivePointView: UIView {
    
    //MARK: - UI Components

    private let attractivePointOptionStackView = UIStackView()
    let attractivePointOptionButtons = AttractivePoint.allCases.map {
        LibraryFilterAttractivePointOptionButton($0)
    }
    
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
    
    private func setUI() {
        attractivePointOptionStackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.distribution = .fillEqually
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(attractivePointOptionStackView)

        attractivePointOptionButtons.forEach {
            attractivePointOptionStackView.addArrangedSubview($0)
        }
    }
    
    private func setLayout() {
        attractivePointOptionStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func updateButtons(selectedOptions: [AttractivePoint]) {
        attractivePointOptionButtons.forEach {
            $0.updateButton(selectedOptions: selectedOptions)
        }
    }
}
