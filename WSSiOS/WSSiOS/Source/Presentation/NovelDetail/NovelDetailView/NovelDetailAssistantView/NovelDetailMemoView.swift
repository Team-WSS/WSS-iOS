//
//  NovelDetailMemoView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailMemoView: UIView {
    
    //MARK: - set Properties
    
    public var memoList: [UserNovelMemo] = []

    // MARK: - UI Components
    
    public let novelDetailCreateMemoView = NovelDetailCreateMemoView()
    public let memoTableView = UITableView(frame: .zero, style: .plain)

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

    // MARK: - set UI
    
    private func setUI() {
        memoTableView.do {
            $0.separatorStyle = .none
        }
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(novelDetailCreateMemoView,
                         memoTableView)
    }
    
    // MARK: - set Layout
    
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
    
    func updateTableViewHeight(height: CGFloat) {
        memoTableView.snp.updateConstraints {
            $0.height.equalTo(height + 82)
        }
    }
    
    func bindData(memos: [UserNovelMemo]) {
        self.memoList = memos
        
        if self.memoList.count == 0 {
            self.novelDetailCreateMemoView.createMemoLabel.text = "아직 작성된 메모가 없어요"
        } else {
            self.novelDetailCreateMemoView.createMemoLabel.text = "새로운 메모를 작성해보세요"
        }
    }
}
