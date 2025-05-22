//
//  FeedDetailAddImageView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/19/25.
//

import UIKit

import SnapKit
import Then

protocol FeedDetailAddImageViewDelegate: AnyObject {
    func addImageDidTap(_ view: FeedDetailAddImageView, didTapImageAt index: Int, imageURLs: [URL?])
}

final class FeedDetailAddImageView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: FeedDetailAddImageViewDelegate?
    
    private var imageURLs: [URL?] = []
    
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
            $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.spacing = 7
            $0.alignment = .fill
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
    
    @objc private func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else { return }
        let index = tappedImageView.tag
        delegate?.addImageDidTap(self, didTapImageAt: index, imageURLs: imageURLs)
    }
    
    func bindImages(imageURLs: [URL?]) {
        self.imageURLs = imageURLs
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let imageWidth = calculateImageWidth(for: imageURLs.count)
        
        for (index, imageURL) in imageURLs.enumerated() {
            let imageView = UIImageView().then {
                $0.kfSetImage(url: imageURL)
                $0.layer.cornerRadius = 8
                $0.clipsToBounds = true
                $0.contentMode = .scaleAspectFill
                $0.isUserInteractionEnabled = true
            }
            
            imageView.snp.makeConstraints {
                $0.size.equalTo(imageWidth)
            }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            imageView.addGestureRecognizer(tapGesture)
            imageView.tag = index
            
            stackView.addArrangedSubview(imageView)
        }
        
        scrollView.isScrollEnabled = imageURLs.count > 3
        
        stackView.snp.updateConstraints {
            $0.height.equalTo(imageWidth)
        }
        
        scrollView.snp.updateConstraints {
            $0.height.equalTo(imageWidth)
        }
    }
    
    // 이미지 개수에 따른 사이즈 계산 함수
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
