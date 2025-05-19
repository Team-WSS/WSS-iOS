//
//  FeedDetailAddImageView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/19/25.
//

import UIKit

import SnapKit
import Then

final class FeedDetailAddImageView: UIView {
    
    //MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
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
        scrollView.do {
            $0.showsHorizontalScrollIndicator = false
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.spacing = 7
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }
    }
    
    private func setHierarchy() {
        self.addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(0)
        }
    }
    
    func bindImages(images: [UIImage]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let imageWidth = calculateImageWidth(for: images.count)
        
        for image in images {
            let imageView = UIImageView().then {
                $0.image = image
                $0.layer.cornerRadius = 8
                $0.clipsToBounds = true
                $0.contentMode = .scaleAspectFill
                $0.snp.makeConstraints { $0.width.equalTo(imageWidth) }
            }
            stackView.addArrangedSubview(imageView)
        }
        
        scrollView.isScrollEnabled = images.count > 3
        
        stackView.snp.updateConstraints {
            $0.height.equalTo(imageWidth)
        }
        
        scrollView.snp.updateConstraints {
            $0.height.equalTo(imageWidth)
        }
    }
    
    private func calculateImageWidth(for count: Int) -> CGFloat {
        let horizontalPadding: CGFloat = 40
        let imageSpacing: CGFloat = 7
        let totalWidth = UIScreen.main.bounds.width - horizontalPadding

        switch count {
        case 1:
            return totalWidth
        case 2:
            return (totalWidth - imageSpacing) / 2
        case 3:
            return (totalWidth - imageSpacing * 2) / 3
        default:
            return 100
        }
    }
}
