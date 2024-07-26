//
//  MyPageProfileEditView.swift
//  WSSiOS
//
//  Created by 신지원 on 7/26/24.
//

import UIKit

import SnapKit
import Then

final class MyPageProfileEditView: UIView {
    
    //MARK: - Components
    
    let profileImageView = UIView()
    private var imageView = UIImageView()
    private let changeView = UIView()

    private let nicknameView = UIView()
    private let nicknameLabel = UILabel()
    lazy var nicknameTextField = UITextField()
    lazy var cancelButton = UIButton()
    lazy var checkButton = UIButton()
    var countLabel = UILabel()
    private let countLimitLabel = UILabel()
    
    private let divide1View = UIView()
    
    private let introView = UIView()
    private let introLabel = UILabel()
    lazy var introTextView = UIView()
    
    private let divide2View = UIView()
    
    private let genreView = UIView()
    private let genreLabel = UILabel()
    private let genreDescriptionLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    
    
    
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
        
        nicknameView.do {
            $0.backgroundColor = .wssWhite
            
            nicknameLabel.do {
                $0.applyWSSFont(.title2, with: StringLiterals.MyPage.EditProfile.nickname)
                $0.textColor = .wssBlack
            }
            
            nicknameTextField.do {
                $0.textColor = .wssBlack
                $0.font = .Body2
                $0.backgroundColor = .wssGray50
                $0.layer.cornerRadius = 12
            }
            
            checkButton.do {
                $0.setTitle(StringLiterals.MyPage.EditProfile.nicknameCheck, for: .normal)
                $0.setTitleColor(.Gray200, for: .normal)
                $0.backgroundColor = .Gray70
                $0.layer.cornerRadius = 12
            }
        }
        
        introView.do {
            $0.backgroundColor = .wssWhite
            
            introLabel.do {
                $0.applyWSSFont(.title2, with: StringLiterals.MyPage.EditProfile.intro)
                $0.textColor = .wssBlack
            }
            
            introTextView.do {
                $0.backgroundColor = .Gray50
                $0.layer.cornerRadius = 14
            }
        }
        
        genreView.do {
            $0.backgroundColor = .wssWhite
            
            genreLabel.do {
                $0.applyWSSFont(.title2, with: StringLiterals.MyPage.EditProfile.genre)
                $0.textColor = .wssBlack
            }
            
            genreDescriptionLabel.do {
                $0.applyWSSFont(.body5, with: StringLiterals.MyPage.EditProfile.genreDescription)
                $0.textColor = .Gray200
            }
        }
        
        [divide1View, divide2View].forEach { 
            $0.do {
                $0.backgroundColor = .wssGray50
            }
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(profileImageView,
                         nicknameView,
                         introView,
                         genreView)
        profileImageView.addSubviews(imageView,
                                     changeView)
        nicknameView.addSubviews(nicknameLabel,
                                 nicknameTextField,
                                 checkButton,
                                 divide1View)
        nicknameTextField.addSubview(cancelButton)
        introView.addSubviews(introLabel,
                              introTextView,
                              divide2View)
        genreView.addSubviews(genreLabel,
                              genreDescriptionLabel,
                              tableView)
    }
    
    private func setLayout() {
        
    }
    
    //MARK: - Data
    
    
}

