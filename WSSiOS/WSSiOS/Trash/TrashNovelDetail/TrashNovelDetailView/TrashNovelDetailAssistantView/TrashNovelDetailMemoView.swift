//
//  TrashNovelDetailMemoView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class TrashNovelDetailMemoView: UIView {

    //MARK: - Components

    let novelDetailCreateMemoView = TrashNovelDetailCreateMemoView()
    let memoTableView = UITableView(frame: .zero, style: .plain)

    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - UI
    
    private func setUI() {
        memoTableView.do {
            $0.backgroundColor = .wssWhite
            $0.separatorStyle = .none
            $0.isScrollEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(novelDetailCreateMemoView,
                         memoTableView)
    }
    
    private func setLayout() {
        novelDetailCreateMemoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        memoTableView.snp.makeConstraints {
            $0.top.equalTo(novelDetailCreateMemoView.snp.bottom).offset(28)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(200)
        }
    }
    
    //MARK: - Data
    
    func bindData(memoCount: Int) {
        if memoCount == 0 {
            self.novelDetailCreateMemoView.createMemoLabel.do {
                $0.makeAttribute(with: StringLiterals.NovelDetail.Memo.noMemo)?
                    .lineSpacing(spacingPercentage: 150)
                    .kerning(kerningPixel: -0.6)
                    .applyAttribute()
            }
        } else {
            self.novelDetailCreateMemoView.createMemoLabel.do {
                $0.makeAttribute(with: StringLiterals.NovelDetail.Memo.newMemo)?
                    .lineSpacing(spacingPercentage: 150)
                    .kerning(kerningPixel: -0.6)
                    .applyAttribute()
            }
        }
    }
    
    //MARK: - Custom Method
    
    func updateTableViewHeight(height: CGFloat) {
        memoTableView.snp.updateConstraints {
            $0.height.equalTo(height + 82)
        }
    }
}
