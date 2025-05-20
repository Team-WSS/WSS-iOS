//
//  FeedDetailAddImageViewerCell.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/19/25.
//

import UIKit

import SnapKit
import Then

final class FeedDetailAddImageViewerCell: UICollectionViewCell {
    
    //MARK: - Components
    
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollView.zoomScale = 1.0
        imageView.image = nil
    }
    
    //MARK: - UI
    
    private func setUI() {
        scrollView.do {
            $0.minimumZoomScale = 1.0
            $0.maximumZoomScale = 3.0
            $0.frame = contentView.bounds
            $0.delegate = self
        }
        
        imageView.do {
            $0.frame = contentView.bounds
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
        }
    }
    
    private func setHierarchy() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
    }
    
    //MARK: - Bind
    
    func bindImage(url: URL?) {
        imageView.kfSetImage(url: url)
    }
}

extension FeedDetailAddImageViewerCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
