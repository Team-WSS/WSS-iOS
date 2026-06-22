//
//  LibraryFilterReadStatusView.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/26/25.
//

import UIKit

import SnapKit
import Then

final class LibraryFilterReadStatusView: UIView {
    
    //MARK: - UI Components

    private let readStatusOptionStackView = UIStackView()
    let readStatusOptionButtons = ReadStatus.allCases.map {
        LibraryFilterReadStatusOptionButton($0)
    }
    private let dividerViews = [UIView(), UIView()]
    
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
        readStatusOptionStackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .center
            $0.distribution = .fillEqually
        }
        
        dividerViews.forEach {
            $0.backgroundColor = .wssGray70
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(readStatusOptionStackView)
        dividerViews.forEach {
            self.addSubview($0)
        }
        readStatusOptionButtons.forEach {
            readStatusOptionStackView.addArrangedSubview($0)
        }
    }
    
    private func setLayout() {
        readStatusOptionStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(54)
            $0.bottom.equalToSuperview()
        }
        
        dividerViews.enumerated().forEach { index, dividerView in
            dividerView.snp.makeConstraints {
                $0.height.equalTo(32)
                $0.width.equalTo(1)
                $0.centerY.equalTo(readStatusOptionStackView.snp.centerY)
                $0.centerX.equalTo(readStatusOptionButtons[index].snp.trailing)
            }
        }
    }
    
    //MARK: - Custom Method
    
    func updateButtons(selectedOptions: [ReadStatus]) {
        readStatusOptionButtons.forEach {
            $0.updateButton(selectedOptions: selectedOptions)
        }
    }
}
