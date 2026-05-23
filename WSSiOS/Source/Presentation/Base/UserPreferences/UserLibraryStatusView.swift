//
//  UserLibraryStatusView .swift
//  WSSiOS
//
//  Created by 신지원 on 5/23/25.
//

import UIKit

import SnapKit
import Then

final class UserLibraryStatusView: UIView {
    
    //MARK: - Components
    
    private let userLibraryStatusStackView = UIStackView()
    var readStatusButtons = [UIButton()]
    
    private let interestCountLabel = UILabel()
    private let watchingCountLabel = UILabel()
    private let watchedCountLabel = UILabel()
    private let quitCountLabel = UILabel()
    
    // MARK: - Life Cycle
    
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
        userLibraryStatusStackView.do {
            $0.backgroundColor = .wssPrimary20
            $0.layer.cornerRadius = 14
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 2
        }
        
        let countLabels: [UILabel] = [
            interestCountLabel,
            watchingCountLabel,
            watchedCountLabel,
            quitCountLabel
        ]
        
        readStatusButtons = StringLiterals.ReviewerStatus.allCases.enumerated().map { index, status in
            createLibraryStatusSectionView (
                countLabel: countLabels[index],
                text: status.rawValue
            )
        }
    }
    
    private func setHierarchy() {
        self.addSubview(userLibraryStatusStackView)
        readStatusButtons.forEach {
            userLibraryStatusStackView.addArrangedSubviews($0)
        }
    }
    
    private func setLayout() {
        userLibraryStatusStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(70)
        }
    }
    
    //MARK: - Custom Method
    
    private func createLibraryStatusSectionView(countLabel: UILabel, text: String) -> UIButton {
        let statusButton = UIButton()
        let textLabel = UILabel()
        
        countLabel.do {
            $0.applyWSSFont(.title2, with: "0")
            $0.textColor = .wssPrimary100
            $0.textAlignment = .center
        }
        
        textLabel.do {
            $0.applyWSSFont(.body5, with: text)
            $0.textColor = .wssBlack
            $0.textAlignment = .center
        }
        
        statusButton.addSubviews(countLabel,
                                 textLabel)
        
        countLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13.5)
            $0.centerX.equalToSuperview()
        }
        
        textLabel.snp.makeConstraints {
            $0.top.equalTo(countLabel.snp.bottom).offset(2)
            $0.centerX.equalToSuperview()
        }
        
        return statusButton
    }
    
    //MARK: - Data
    
    func bindData(data: UserNovelStatusEntity) {
        interestCountLabel.applyWSSFont(.title2, with: String(describing: data.interestNovelCount))
        watchedCountLabel.applyWSSFont(.title2, with: String(describing: data.watchedNovelCount))
        watchingCountLabel.applyWSSFont(.title2, with: String(describing: data.watchingNovelCount))
        quitCountLabel.applyWSSFont(.title2, with: String(describing: data.quitNovelCount))
    }
}
