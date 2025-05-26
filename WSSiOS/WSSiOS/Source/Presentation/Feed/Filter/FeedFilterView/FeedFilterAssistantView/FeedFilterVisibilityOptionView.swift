//
//  FeedFilterVisibilityOptionView.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/27/25.
//

import UIKit

import SnapKit
import Then

final class FeedFilterVisibilityOptionView: UIView {
    
    //MARK: - UI Components

    private let optionimageView = UIImageView()
    private let optionLabel = UILabel()
    let optionButton = UIButton()
    let dividerView = UIView()
    
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
        optionButton.setImage(.icSelectNovelSelected, for: .normal)
        dividerView.backgroundColor = .wssGray50
    }
    
    private func setHierarchy() {
        self.addSubviews(optionimageView,
                         optionLabel,
                         optionButton,
                         dividerView)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(55)
           
            optionimageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().inset(20)
                $0.size.equalTo(18)
            }
            
            optionLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(optionimageView.snp.trailing).offset(10)
            }
            
            optionButton.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().inset(10)
                $0.size.equalTo(44)
            }
            
            dividerView.snp.makeConstraints {
                $0.bottom.equalToSuperview()
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.height.equalTo(1)
            }
        }
    }
    
    //MARK: - Custom Method
    
    func setOptionView(option: FeedVisibilityOption) {
        optionLabel.applyWSSFont(.body2, with: option.optionText)
        optionimageView.image = option.optionImage
    }
    
    func updateButton(isSelected: Bool) {
        optionButton.setImage(isSelected ? .icSelectNovelSelected : .icSelectNovelDefault2, for: .normal)
    }
}
