//
//  NovelDetailInfoReviewGraphView.swift
//  WSSiOS
//
//  Created by YunhakLee on 8/8/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoReviewGraphView: UIView {
    
    //MARK: - Properties
    
    let readStatus: ReadStatus
    
    //MARK: - UI Components
    
    private let stackView = UIStackView()
    
    private let statusCountLabel = UILabel()
    
    private let graphBackgroundView = UIView()
    private let graphValueView = UIView()
    
    private let statusNameLabel = UILabel()
    
    //MARK: - Life Cycle
    
    init(readStatus: ReadStatus) {
        self.readStatus = readStatus
        
        super.init(frame: .zero)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .center
            
            graphBackgroundView.do {
                $0.layer.cornerRadius = 10
                $0.clipsToBounds = true
                $0.backgroundColor = .wssGray50
                
                graphValueView.do {
                    $0.backgroundColor = .wssGray70
                }
            }
            
            statusNameLabel.do {
                $0.applyWSSFont(.body2, with: readStatus.statusName)
            }
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(stackView)
        stackView.addArrangedSubviews(statusCountLabel,
                                      graphBackgroundView,
                                      statusNameLabel)
        graphBackgroundView.addSubview(graphValueView)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            
            stackView.do {
                $0.setCustomSpacing(10, after: statusCountLabel)
                $0.setCustomSpacing(8, after: graphBackgroundView)
            }
            
            graphBackgroundView.snp.makeConstraints {
                $0.width.equalTo(50)
                $0.height.equalTo(100)
                
                graphValueView.snp.makeConstraints {
                    $0.top.equalToSuperview()
                    $0.horizontalEdges.equalToSuperview()
                    $0.bottom.equalToSuperview()
                }
            }
        }
    }
    
    //MARK: - Data
    
    func bindData(statusCount: Int, topStatusCount: Int) {
        guard topStatusCount != 0 else { return }
        let graphTopInset = (1-Double(statusCount)/Double(topStatusCount))*100
        let isTopReadStatus = statusCount == topStatusCount
        
        statusCountLabel.do {
            $0.applyWSSFont(.body5, with: "\(statusCount)")
            $0.textColor = isTopReadStatus ? .wssPrimary200 : .wssGray200
        }
        
        statusNameLabel.do {
            $0.textColor = isTopReadStatus ? .wssPrimary200 : .wssGray200
        }
        
        graphValueView.do {
            $0.backgroundColor = isTopReadStatus ? .wssPrimary100 : .wssGray70
        }
        
        graphValueView.snp.updateConstraints {
            $0.top.equalToSuperview().inset(graphTopInset)
        }
        
        self.layoutIfNeeded()
    }
}
