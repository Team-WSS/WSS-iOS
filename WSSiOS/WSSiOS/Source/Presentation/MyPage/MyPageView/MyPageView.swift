//
//  MyPageView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/8/24.
//

import UIKit

class MyPageView: UIView {
    
    //MARK: - UI Components
    
    var scrollView = UIScrollView()
    var myPageStackView = UIStackView()
    var myPageProfileView = MyPageProfileView()
    var myPageTallyView = MyPageTallyView()
    var myPageInventoryView = MyPageInventoryView()
    
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
                                            myPageInventoryView)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints() {
            $0.edges.equalToSuperview()
        }
        
        myPageStackView.snp.makeConstraints() {
            $0.top.width.bottom.equalToSuperview()
        }
    }
}
