//
//  UserPageOverviewView.swift
//  WSSiOS
//
//  Created by 신지원 on 11/16/24.
//

import UIKit

import SnapKit
import Then

final class UserPageOverviewView: UIView {
    
    // MARK: - Components
    
    private let stackView = UIStackView()
    let userPageLibraryStatusView = UserPageLibraryStatusView()
    
    let userPageGenrePreferencesView = UserPageGenrePreferencesView()
    let userPageNovelPreferencesView = UserPageNovelPreferencesView()
    
    private let preferencesEmptyView = UserPagePreferencesEmptyView()
    private let userPagePrivateView = UserPagePrivateView()
    
    private let firstDividerView = UIView()
    private let secondDividerView = UIView()
    
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
    
    private func setUI() {
        self.backgroundColor = .wssWhite
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
        }
        
        [firstDividerView, secondDividerView].forEach {
            $0.backgroundColor = .wssGray50
        }
        
        userPagePrivateView.isHidden = true
        preferencesEmptyView.isHidden = true
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(userPageLibraryStatusView,
                                      firstDividerView,
                                      userPageGenrePreferencesView,
                                      secondDividerView,
                                      userPageNovelPreferencesView,
                                      userPagePrivateView,
                                      preferencesEmptyView)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
        
        userPageLibraryStatusView.snp.makeConstraints {
            $0.height.equalTo(160)
        }
        
        userPageGenrePreferencesView.snp.makeConstraints {
            $0.height.equalTo(224.5)
        }
        
        [firstDividerView, secondDividerView].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(3)
            }
        }
        
        userPagePrivateView.snp.makeConstraints {
            $0.height.equalTo(450)
        }
        
        preferencesEmptyView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(363)
        }
    }
    
    //MARK: - Custom Method
    
    func updateGenreViewHeight(isExpanded: Bool) {
        userPageGenrePreferencesView.snp.updateConstraints {
            $0.height.equalTo(isExpanded ? 514 : 224.5)
        }
    }
    
    func isPrivateUserPage(nickname: String) {
        [userPageLibraryStatusView,
         firstDividerView,
         userPageGenrePreferencesView,
         secondDividerView,
         userPageNovelPreferencesView].forEach { view in
            view.isHidden = true
        }
        
        let text = nickname + StringLiterals.MyPage.Profile.privateLabel
        userPagePrivateView.bindData(nickname: text)
        userPagePrivateView.isHidden = false
    }
    
    func updatePreferenceViews(genreEmpty: Bool, novelEmpty: Bool) {
        
        //장르뷰
        userPageGenrePreferencesView.isHidden = genreEmpty
        secondDividerView.isHidden = genreEmpty

        // 노벨뷰
        userPageNovelPreferencesView.isHidden = novelEmpty

        // Empty 뷰
        preferencesEmptyView.isHidden = !novelEmpty
    }
}
