//
//  MyPageView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/8/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class MyPageView: UIView {
    
    //MARK: - Components
    
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
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.backgroundColor = .wssGray50
        
        myPageStackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 0
        }
    }
    
    private func setHierarchy() {
        self.addSubview(scrollView)
        scrollView.addSubview(myPageStackView)
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
    
    //MARK: - Data
    
    func bindData(_ data: UserResult) {
        myPageProfileView.bindProfileViewData(data)
        myPageTallyView.bindTallyViewData(data)
    }
}
