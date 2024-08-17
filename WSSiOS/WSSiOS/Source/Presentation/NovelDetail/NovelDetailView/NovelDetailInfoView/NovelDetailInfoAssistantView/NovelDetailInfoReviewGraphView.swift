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
            
            statusCountLabel.do {
                $0.applyWSSFont(.body5, with: "0")
                $0.textColor = .wssGray200
            }
            
            statusNameLabel.do {
                $0.applyWSSFont(.body2, with: "봤어요")
                $0.textColor = .wssGray200
            }
            
            graphBackgroundView.do {
                $0.layer.cornerRadius = 10
                $0.clipsToBounds = true
                $0.backgroundColor = .wssGray50
                
                graphValueView.do {
                    $0.backgroundColor = .wssGray70
                }
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
                    $0.top.equalToSuperview().inset(0)
                    $0.horizontalEdges.equalToSuperview()
                    $0.bottom.equalToSuperview()
                }
            }
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailInfoResult) {
        let statusCount = getReadStatusCount(data)
        let maxCount = getTopReadStatusCount(data)
        
        if determineTopReadStatus(data) {
            updateTopStatusUI(statusCount: statusCount)
        } else {
            updateBasicStatusUI(statusCount: statusCount,
                                maxCount: maxCount)
        }
    }
    
    private func getTopReadStatusCount(_ data: NovelDetailInfoResult) -> Int {
        return max(data.quitCount, data.watchedCount, data.watchingCount)
    }
    
    private func determineTopReadStatus(_ data: NovelDetailInfoResult) -> Bool {
        let maxCount = getTopReadStatusCount(data)
        
        switch maxCount {
        case data.quitCount:
            return readStatus == .quit
        case data.watchedCount:
            return readStatus == .watched
        case data.watchingCount:
            return readStatus == .watching
        default:
            return false
        }
    }
    
    private func getReadStatusCount(_ data: NovelDetailInfoResult) -> Int {
        switch readStatus {
        case .watched:
            data.watchedCount
        case .watching:
            data.watchingCount
        case .quit:
            data.quitCount
        }
    }
    
    //MARK: - Custom Method
    
    private func updateTopStatusUI(statusCount: Int) {
        statusCountLabel.do {
            $0.applyWSSFont(.body5, with: "\(statusCount)")
            $0.textColor = .wssPrimary200
        }
        
        statusNameLabel.do {
            $0.applyWSSFont(.body2, with: readStatus.tagText)
            $0.textColor = .wssPrimary200
        }
        
        graphValueView.do {
            $0.backgroundColor = .wssPrimary100
        }
    }
    
    private func updateBasicStatusUI(statusCount: Int, maxCount: Int) {
        guard maxCount != 0 else { return }
        let graphTopInset = (1-Double(statusCount)/Double(maxCount))*100
        
        statusCountLabel.do {
            $0.applyWSSFont(.body5, with: "\(statusCount)")
            $0.textColor = .wssGray200
        }
        
        statusNameLabel.do {
            $0.applyWSSFont(.body2, with: readStatus.tagText)
            $0.textColor = .wssGray200
        }
        
        graphValueView.do {
            $0.backgroundColor = .wssGray70
        }
        
        graphValueView.snp.remakeConstraints {
            $0.top.equalToSuperview().inset(graphTopInset)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        self.layoutIfNeeded()
    }
}
