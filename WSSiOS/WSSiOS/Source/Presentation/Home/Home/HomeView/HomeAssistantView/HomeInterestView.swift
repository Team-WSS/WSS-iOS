//
//  HomeInterestView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/2/24.
//

import UIKit

import SnapKit
import Then

final class HomeInterestView: UIView {
    
    //MARK: - UI Components
    
    private var titleLabel = UILabel()
    private var subTitleLabel = UILabel()
    
    let interestCollectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewLayout())
    private let interestCollectionViewLayout = UICollectionViewFlowLayout()
    
    private let userNickname = UserDefaults.standard.string(forKey: StringLiterals.UserDefault.userNickname)
    let unregisterView = HomeUnregisterView(.interest)
    private let interestEmptyView = HomeInterestEmptyView()
    
    //MARK: - Life Cycle
    
    init() {
        super.init(frame: .zero)
        
        setUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        titleLabel.do {
            $0.applyWSSFont(.headline1, with: StringLiterals.Home.Title.notLoggedInInterest)
            $0.textColor = .wssBlack
        }
        
        subTitleLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.Home.SubTitle.interest)
            $0.textColor = .wssGray200
        }
        
        interestCollectionView.do {
            $0.showsHorizontalScrollIndicator = false
        }
        
        interestCollectionViewLayout.do {
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 12
            $0.itemSize = CGSize(width: 280, height: 251)
            $0.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            interestCollectionView.setCollectionViewLayout($0, animated: false)
        }
    }
    
    //MARK: - Custom Method
    
    func updateView(_ isLogined: Bool, _ message: InterestMessage) {
        if isLogined {
            // 로그인
            switch message {
            case .noInterestNovels:
                // 유저의 선호장르가 없을 때
                if let nickname = userNickname {
                    titleLabel.applyWSSFont(.headline1, with: "\(nickname)\(StringLiterals.Home.Title.interest)")
                }
                self.addSubviews(titleLabel,
                                 unregisterView)
                titleLabel.snp.makeConstraints {
                    $0.top.equalToSuperview()
                    $0.leading.equalToSuperview().inset(20)
                }
                unregisterView.snp.makeConstraints {
                    $0.top.equalTo(titleLabel.snp.bottom).offset(11)
                    $0.leading.trailing.equalToSuperview().inset(20)
                    $0.bottom.equalToSuperview().inset(20)
                }
                interestCollectionView.removeFromSuperview()
                interestEmptyView.removeFromSuperview()
                subTitleLabel.removeFromSuperview()
            case .noAssociatedFeeds:
                // 유저의 선호장르에 대한 글이 하나도 없을 때
                titleLabel.applyWSSFont(.headline1, with: StringLiterals.Home.Title.notLoggedInInterest)
                interestCollectionView.removeFromSuperview()
                self.addSubviews(titleLabel,
                                 interestEmptyView)
                titleLabel.snp.makeConstraints {
                    $0.top.equalToSuperview()
                    $0.leading.equalToSuperview().inset(20)
                }
                interestEmptyView.snp.makeConstraints {
                    $0.top.equalTo(titleLabel.snp.bottom).offset(11)
                    $0.leading.trailing.equalToSuperview().inset(20)
                    $0.bottom.equalToSuperview().inset(20)
                }
                unregisterView.removeFromSuperview()
                subTitleLabel.removeFromSuperview()
            case .none:
                // 관심글이 존재할 때
                if let nickname = userNickname {
                    titleLabel.applyWSSFont(.headline1, with: "\(nickname)\(StringLiterals.Home.Title.interest)")
                }
                self.addSubviews(titleLabel,
                                 subTitleLabel,
                                 interestCollectionView)
                titleLabel.snp.makeConstraints {
                    $0.top.equalToSuperview()
                    $0.leading.equalToSuperview().inset(20)
                }
                subTitleLabel.snp.makeConstraints {
                    $0.top.equalTo(titleLabel.snp.bottom).offset(2)
                    $0.leading.equalTo(titleLabel.snp.leading)
                }
                interestCollectionView.snp.makeConstraints {
                    $0.top.equalTo(subTitleLabel.snp.bottom)
                    $0.leading.trailing.bottom.equalToSuperview()
                    $0.height.equalTo(301)
                }
                unregisterView.removeFromSuperview()
                interestEmptyView.removeFromSuperview()
            }
        } else {
            // 비로그인
            titleLabel.applyWSSFont(.headline1, with: StringLiterals.Home.Title.notLoggedInInterest)
            self.addSubviews(titleLabel,
                             unregisterView)
            titleLabel.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview().inset(20)
            }
            unregisterView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(11)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.bottom.equalToSuperview().inset(20)
            }
            interestCollectionView.removeFromSuperview()
            interestEmptyView.removeFromSuperview()
            subTitleLabel.removeFromSuperview()
        }
    }
}
