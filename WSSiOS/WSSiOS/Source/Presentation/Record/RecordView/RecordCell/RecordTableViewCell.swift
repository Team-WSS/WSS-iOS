//
//  RecordTableViewCell.swift
//  WSSiOS
//
//  Created by 최서연 on 1/12/24.
//

import UIKit

final class RecordTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "RecordTableViewCell"
    
    //MARK: - UI Components
    
    private let dateView = RecordDateView()
    private let novelTitleLabel = UILabel()
    private let recordContentLabel = UILabel()
    
    //MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - set UI
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .White
            $0.selectionStyle = .none
        }
        
        novelTitleLabel.do {
            $0.font = .Body2
            $0.textColor = .Gray200
        }
        
        recordContentLabel.do {
            $0.font = .Body2
            $0.textColor = .Black
        }
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(dateView,
                         novelTitleLabel,
                         recordContentLabel)
    }
    
    //MARK: - set Layout
    
    private func setLayout() {
        dateView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(10)
        }
        
        novelTitleLabel.snp.makeConstraints {
            $0.top.equalTo(dateView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        recordContentLabel.snp.makeConstraints {
            $0.top.equalTo(novelTitleLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().inset(21)
            $0.bottom.equalToSuperview().inset(48)
        }
    }
    
    func bindData(data: RecordMemo) {
        dateView.dateLabel.text = data.date

        novelTitleLabel.do {
            $0.makeAttribute(with: data.novelTitle)?
                .kerning(kerningPixel: -0.6)
                .lineSpacing(spacingPercentage: 150)
                .applyAttribute()
        }
        
        recordContentLabel.do {
            $0.makeAttribute(with: data.content)?
                .kerning(kerningPixel: -0.6)
                .lineSpacing(spacingPercentage: 150)
                .applyAttribute()
            $0.numberOfLines = 5
            $0.lineBreakStrategy = .hangulWordPriority
            $0.lineBreakMode = .byTruncatingTail
        }
    }
}
