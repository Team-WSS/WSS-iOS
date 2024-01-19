//
//  MyPageView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/8/24.
//

import UIKit

import Kingfisher

final class MyPageView: UIView {
    
    //MARK: - UI Components
    
    private var scrollView = UIScrollView()
    var myPageStackView = UIStackView()
    var myPageProfileView = MyPageProfileView()
    var myPageTallyView = MyPageTallyView()
    var myPageInventoryView = MyPageInventoryView()
    var myPageSettingView = MyPageSettingView()
    
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
    
    private func setUI() {
        self.backgroundColor = .White
        
        myPageStackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 0
        }
    }
    
    private func setHierachy() {
        self.addSubview(scrollView)
        scrollView.addSubviews(myPageStackView)
        myPageStackView.addArrangedSubviews(myPageProfileView,
                                            myPageTallyView,
                                            myPageInventoryView,
                                            myPageSettingView)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints() {
            $0.edges.equalToSuperview()
            
            myPageStackView.snp.makeConstraints() {
                $0.top.width.bottom.equalToSuperview()
            }
        }
    }
    
    func dataBind(_ data: UserResult) {
        myPageProfileView.myPageNameLabel.text = data.representativeAvatarTag
        myPageProfileView.myPageBadgeImageView.kfSetImage(url: data.representativeAvatarGenreBadge)
        myPageProfileView.myPagePhraseLabel.text = data.representativeAvatarLineContent
        myPageProfileView.myPageAvartarImageView.kfSetImage(url: data.representativeAvatarImg)
        myPageTallyView.myPageUserNameButton.setTitle("\(data.userNickname)님", for: .normal)
        myPageTallyView.myPageRegisterView.tallyLabel.text = String(data.userNovelCount)
        myPageTallyView.myPageRecordView.tallyLabel.text = String(data.memoCount)
    }
}
