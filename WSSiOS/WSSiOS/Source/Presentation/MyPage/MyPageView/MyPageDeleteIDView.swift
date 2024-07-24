//
//  MyPageDeleteIDView.swift
//  WSSiOS
//
//  Created by 신지원 on 7/24/24.
//

import UIKit

import SnapKit
import Then

final class MyPageDeleteIDView: UIView {
    
    //MARK: - Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let reasonView = UIView()
    private let reasonTitleLabel = UILabel()
    var reasonTableView = UITableView(frame: .zero, style: .plain)
    var reasonTextView = UITextView()
    private var reasonTextViewPlaceholder = UILabel()
    var reasonCountLabel = UILabel()
    private let reasonCountLimitLabel = UILabel()
    
    private let checkView = UIView()
    private let checkTitleLabel = UILabel()
    var checkTableView = UITableView(frame: .zero, style: .plain)
    
    lazy var agreeDeleteIDButton = UIButton()
    private let agreeDeleteIDLabel = UILabel()
    
    lazy var completeButton = UIButton()
    
    //In NavigationBar
    lazy var backButton = UIButton()
    
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
        self.backgroundColor = .wssWhite
        
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
        }
        
        reasonTitleLabel.do {
            $0.textColor = .wssBlack
            $0.makeAttribute(with: StringLiterals.MyPage.DeleteID.reasonTitle)?
                .partialColor(color: .wssPrimary100, rangeString: "탈퇴사유")
                .lineHeight(1.17)
                .kerning(kerningPixel: -1.2)
                .applyAttribute()
            $0.font = .HeadLine1
        }
        
        reasonTableView.do {
            $0.isScrollEnabled = false
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
        }
        
        reasonTextView.do {
            $0.font = .Body2
            $0.textColor = .wssBlack
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 14
            $0.textContainerInset = UIEdgeInsets(top: 10, left: 16, bottom: 12, right: 16)
        }
        
        reasonTextViewPlaceholder.do {
            $0.applyWSSFont(.body2, with: StringLiterals.MyPage.DeleteID.reasonPlaceHolder)
            $0.textColor = .wssGray200
        }
        
        reasonCountLabel.do {
            $0.applyWSSFont(.label1, with: "0")
            $0.textColor = .wssGray300
        }
        
        reasonCountLimitLabel.do {
            $0.applyWSSFont(.label1, with: "/80")
            $0.textColor = .wssGray200
        }
        
        checkTitleLabel.do {
            $0.applyWSSFont(.headline1, with: StringLiterals.MyPage.DeleteID.checkTitle)
            $0.textColor = .wssBlack
        }
        
        checkTableView.do {
            $0.isScrollEnabled = false
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
        }
        
        agreeDeleteIDButton.do {
            $0.setImage(.checkDefault, for: .normal)
        }
        
        agreeDeleteIDLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.MyPage.DeleteID.agreeTitle)
            $0.textColor = .wssGray300
        }
        
        completeButton.do {
            $0.backgroundColor = .wssGray70
            $0.layer.cornerRadius = 14
            $0.setTitle(StringLiterals.MyPage.DeleteIDWarning.buttonTitle, for: .normal)
            $0.setTitleColor(.wssWhite, for: .normal)
            $0.titleLabel?.font = .Title1
            $0.isEnabled = false
        }
        
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    private func setHierarchy() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(reasonView,
                                checkView,
                                agreeDeleteIDButton,
                                agreeDeleteIDLabel,
                                completeButton)
        reasonView.addSubviews(reasonTitleLabel,
                               reasonTableView,
                               reasonTextView,
                               reasonCountLimitLabel,
                               reasonCountLabel)
        reasonTextView.addSubview(reasonTextViewPlaceholder)
        checkView.addSubviews(checkTitleLabel,
                              checkTableView)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        reasonView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(45)
            $0.leading.trailing.equalToSuperview().inset(20)
            
            reasonTitleLabel.snp.makeConstraints {
                $0.top.leading.equalToSuperview()
            }
            
            reasonTableView.snp.makeConstraints {
                $0.top.equalTo(reasonTitleLabel.snp.bottom).offset(20)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(44 * 5)
            }
            
            reasonTextView.snp.makeConstraints {
                $0.top.equalTo(reasonTableView.snp.bottom).offset(2)
                $0.width.equalToSuperview()
                $0.height.equalTo(114)
                
                reasonTextViewPlaceholder.snp.makeConstraints {
                    $0.top.equalToSuperview().inset(10)
                    $0.leading.trailing.equalToSuperview().inset(16)
                }
            }
            
            reasonCountLimitLabel.snp.makeConstraints {
                $0.top.equalTo(reasonTextView.snp.bottom).offset(4)
                $0.trailing.equalToSuperview()
            }
            
            reasonCountLabel.snp.makeConstraints {
                $0.top.equalTo(reasonCountLimitLabel.snp.top)
                $0.trailing.equalTo(reasonCountLimitLabel.snp.leading)
                $0.bottom.equalToSuperview()
            }
        }
        
        checkView.snp.makeConstraints {
            $0.top.equalTo(reasonView.snp.bottom).offset(60)
            $0.leading.trailing.equalToSuperview().inset(20)
            
            checkTitleLabel.snp.makeConstraints {
                $0.top.leading.equalToSuperview()
            }
            
            checkTableView.snp.makeConstraints {
                $0.top.equalTo(checkTitleLabel.snp.bottom).offset(20)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(318)
                $0.bottom.equalToSuperview()
            }
        }
        
        agreeDeleteIDButton.snp.makeConstraints {
            $0.top.equalTo(checkView.snp.bottom).offset(34)
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        agreeDeleteIDLabel.snp.makeConstraints {
            $0.centerY.equalTo(agreeDeleteIDButton.snp.centerY)
            $0.leading.equalTo(agreeDeleteIDButton.snp.trailing).offset(10)
        }
        
        completeButton.snp.makeConstraints {
            $0.top.equalTo(agreeDeleteIDButton.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(53)
            $0.bottom.equalToSuperview()
        }
    }
}

extension MyPageDeleteIDView {
    
    //MARK: - Custom Method
    
    func updateReasonTableViewHeight(height: CGFloat) {
        reasonTableView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
    
    func updateCheckTableViewHeight(height: CGFloat) {
        checkTableView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
    
    func placeholderIsHidden(isHidden: Bool) {
        reasonTextViewPlaceholder.isHidden = isHidden
    }
    
    //MARK: - Data
    
    func bindTextCount(count: Int) {
        reasonCountLabel.do {
            $0.applyWSSFont(.label1, with: String(count))
        }
    }
    
    func bindText(text: String) {
        reasonTextView.do {
            $0.text = text
        }
    }
    
    func agreeDeleteIDButtonIsSeleted(isSeleted: Bool) {
        agreeDeleteIDButton.setImage( isSeleted ? .checkSelected : .checkDefault , for: .normal)
    }
    
    func completeButtonIsAble(isAble: Bool) {
        completeButton.backgroundColor = isAble ? .Primary100 : .wssGray70
        completeButton.isEnabled = isAble
    }
}


