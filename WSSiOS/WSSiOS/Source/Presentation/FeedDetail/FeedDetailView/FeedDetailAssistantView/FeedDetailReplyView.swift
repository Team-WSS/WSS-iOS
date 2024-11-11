//
//  FeedDetailReplyView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 6/24/24.
//

import UIKit

import SnapKit
import Then

final class FeedDetailReplyView: UIView {
    
    //MARK: - UI Components
    
    let replyCollectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: UICollectionViewLayout())
    private let replyCollectionViewLayout = UICollectionViewFlowLayout()
    let dropdownView = FeedDetailDropdownView()
    
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
        replyCollectionView.do {
            $0.showsVerticalScrollIndicator = false
        }
        
        replyCollectionViewLayout.do {
            $0.scrollDirection = .vertical
            $0.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 45)
            $0.minimumLineSpacing = 22
            $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
            replyCollectionView.setCollectionViewLayout($0, animated: true)
        }
        
        dropdownView.do {
            $0.isHidden = true
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(replyCollectionView,
                         dropdownView)
    }
    
    private func setLayout() {
        replyCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(20)
        }
        
        dropdownView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    //MARK: - Custom Method
    
    func updateCollectionViewHeight(height: CGFloat) {
        replyCollectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
    
    func showDropdownView(indexPath: IndexPath, isMyComment: Bool) {
        dropdownView.do {
            $0.configureDropdown(isMine: isMyComment)
            $0.isHidden = false
        }
        updateDropdownViewLayout(indexPath: indexPath)
    }
    
    func hideDropdownView() {
        dropdownView.isHidden = true
    }
    
    func toggleDropdownView() {
        dropdownView.isHidden.toggle()
    }
    
    func updateDropdownViewLayout(indexPath: IndexPath) {
        guard let cell = replyCollectionView.cellForItem(at: indexPath) else { return }
        
        let cellFrameInSuperview = cell.convert(cell.bounds, to: self)
        let isLastTwoCells = indexPath.item >= replyCollectionView.numberOfItems(inSection: indexPath.section) - 2
        
        dropdownView.snp.updateConstraints {
            $0.top.equalToSuperview().inset(isLastTwoCells ? cellFrameInSuperview.minY - dropdownView.frame.height : cellFrameInSuperview.minY + 40)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
