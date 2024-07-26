//
//  MyPageProfileEditView.swift
//  WSSiOS
//
//  Created by 신지원 on 7/26/24.
//

import UIKit

import SnapKit
import Then

final class MyPageEditProfileView: UIView {
    
    //MARK: - Components
    
    let profileView = UIView()
    private var profileImageView = UIImageView()
    private let profileChangeView = UIView()
    private let profileChangeImageView = UIImageView()

    private let nicknameView = UIView()
    private let nicknameLabel = UILabel()
    lazy var nicknameTextField = UITextField()
    lazy var clearButton = UIButton()
    lazy var checkButton = UIButton()
    private let nicknameWarningLabel = UILabel()
    private var nicknameCountView = MyPageCountView(maxLimit: 10)
    
    private let divide1View = UIView()
    
    private let introView = UIView()
    private let introLabel = UILabel()
    lazy var introTextView = UITextView()
    private let introTextViewPlaceholder = UILabel()
    private var introCountView = MyPageCountView(maxLimit: 40)
    
    private let divide2View = UIView()
    
    private let genreView = UIView()
    private let genreLabel = UILabel()
    private let genreDescriptionLabel = UILabel()
    lazy var genreCollectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: UICollectionViewLayout())
    
    //In VC
    lazy var backButton = UIButton()
    lazy var completeButton = UIButton()
    
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
        
        profileView.do {
            $0.backgroundColor = .wssWhite
            
            profileImageView.do {
                $0.image = .profile
                $0.layer.cornerRadius = 37
            }
            
            profileChangeView.do {
                $0.backgroundColor = .wssWhite
                $0.layer.cornerRadius = 12.5
                $0.layer.borderColor = UIColor.wssGray70.cgColor
                $0.layer.borderWidth = 1.04
                
                profileChangeImageView.do {
                    $0.image = .icPlus
                }
            }
        }
        
        nicknameView.do {
            $0.backgroundColor = .wssWhite
            
            nicknameLabel.do {
                $0.applyWSSFont(.title2, with: StringLiterals.MyPage.EditProfile.nickname)
                $0.textColor = .wssBlack
            }
            
            nicknameTextField.do {
                $0.textColor = .wssBlack
                $0.backgroundColor = .wssGray50
                $0.layer.cornerRadius = 12
                
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 44))
                $0.leftView = paddingView
                $0.leftViewMode = .always
                
                clearButton.do {
                    var configuration = UIButton.Configuration.plain()
                    configuration.image = .icCancel
                    configuration.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 13, bottom: 13, trailing: 13)
                    $0.configuration = configuration
                }
            }
            
            checkButton.do {
                $0.setTitle(StringLiterals.MyPage.EditProfile.nicknameCheck, for: .normal)
                $0.setTitleColor(.wssGray200, for: .normal)
                $0.titleLabel?.applyWSSFont(.body2, with: StringLiterals.MyPage.EditProfile.nicknameCheck)
                $0.backgroundColor = .wssGray70
                $0.layer.cornerRadius = 12
            }
            
            nicknameWarningLabel.do {
                $0.textColor = .Secondary100
                $0.isHidden = true
            }
        }
        
        introView.do {
            $0.backgroundColor = .wssWhite
            
            introLabel.do {
                $0.applyWSSFont(.title2, with: StringLiterals.MyPage.EditProfile.intro)
                $0.textColor = .wssBlack
            }
            
            introTextView.do {
                $0.backgroundColor = .wssGray50
                $0.layer.cornerRadius = 14
                $0.textContainerInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
                $0.spellCheckingType = .no
                $0.autocorrectionType = .no
                $0.autocapitalizationType = .none
            }
            
            introTextViewPlaceholder.do {
                $0.applyWSSFont(.body2, with: StringLiterals.MyPage.EditProfile.introPlaceholder)
                $0.textColor = .wssGray200
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
            
            genreCollectionView.do {
                let layout = LeftAlignedCollectionViewFlowLayout()
                layout.scrollDirection = .vertical
                layout.minimumLineSpacing = 14
                layout.minimumInteritemSpacing = 6
                
                $0.backgroundColor = .wssWhite
                $0.collectionViewLayout = layout
                $0.isScrollEnabled = false
            }
        }
        
        [divide1View, divide2View].forEach { 
            $0.do {
                $0.backgroundColor = .wssGray50
            }
        }
        
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        completeButton.do {
            $0.setTitle(StringLiterals.MyPage.EditProfile.completeTitle, for: .normal)
            $0.setTitleColor(.wssPrimary100, for: .normal)
            $0.titleLabel?.font = .Title2
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(profileView,
                         nicknameView,
                         introView,
                         genreView)
        profileView.addSubviews(profileImageView,
                                     profileChangeView)
        profileChangeView.addSubview(profileChangeImageView)
        nicknameView.addSubviews(nicknameLabel,
                                 nicknameTextField,
                                 checkButton,
                                 nicknameWarningLabel,
                                 nicknameCountView,
                                 divide1View)
        nicknameTextField.addSubview(clearButton)
        introView.addSubviews(introLabel,
                              introTextView,
                              introCountView,
                              divide2View)
        introTextView.addSubview(introTextViewPlaceholder)
        genreView.addSubviews(genreLabel,
                              genreDescriptionLabel,
                              genreCollectionView)
    }
    
    private func setLayout() {
        profileView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(38)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(94)
            
            profileImageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            profileChangeView.snp.makeConstraints {
                $0.size.equalTo(25)
                $0.trailing.equalTo(profileImageView.snp.trailing)
                $0.bottom.equalTo(profileImageView.snp.bottom)
                
                profileChangeImageView.snp.makeConstraints {
                    $0.center.equalToSuperview()
                    //TODO: 디자인썜들께 여쭤봄
                    $0.size.equalTo(19.79)
                }
            }
        }     
        
        nicknameView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(29)
            $0.width.equalToSuperview()
            
            nicknameLabel.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview().inset(20)
            }
            
            nicknameTextField.snp.makeConstraints {
                $0.top.equalTo(nicknameLabel.snp.bottom).offset(7)
                $0.leading.equalToSuperview().inset(20)
                $0.height.equalTo(44)
                $0.width.equalTo(240)
                
                clearButton.snp.makeConstraints {
                    $0.centerY.trailing.equalToSuperview()
                    $0.size.equalTo(44)
                }
            }
            
            checkButton.snp.makeConstraints {
                $0.top.equalTo(nicknameLabel.snp.bottom).offset(7)
                $0.leading.equalTo(nicknameTextField.snp.trailing).offset(7)
                $0.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(nicknameTextField.snp.height)
            }
            
            nicknameWarningLabel.snp.makeConstraints {
                $0.top.equalTo(nicknameTextField.snp.bottom).offset(4)
                $0.leading.equalToSuperview().inset(20)
            }
            
            nicknameCountView.snp.makeConstraints {
                $0.top.equalTo(nicknameTextField.snp.bottom).offset(4)
                $0.trailing.bottom.equalToSuperview().inset(20)
            }
        }
        
        introView.snp.makeConstraints {
            $0.top.equalTo(nicknameView.snp.bottom).offset(15)
            $0.width.equalToSuperview()
            
            introLabel.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview().inset(20)
            }
            
            introTextView.snp.makeConstraints {
                $0.top.equalTo(introLabel.snp.bottom).offset(7)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(66)
                
                introTextViewPlaceholder.snp.makeConstraints {
                    $0.top.equalToSuperview().inset(10)
                    $0.leading.equalToSuperview().inset(16)
                }
            }
            
            introCountView.snp.makeConstraints {
                $0.top.equalTo(introTextView.snp.bottom).offset(4)
                $0.trailing.bottom.equalToSuperview().inset(20)
            }
        }
        
        genreView.snp.makeConstraints {
            $0.top.equalTo(introView.snp.bottom).offset(15)
            $0.width.equalToSuperview()
            
            genreLabel.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview().inset(20)
            }
            
            genreDescriptionLabel.snp.makeConstraints {
                $0.top.equalTo(genreLabel.snp.bottom).offset(6)
                $0.leading.equalToSuperview().inset(20)
            }
            
            genreCollectionView.snp.makeConstraints {
                $0.top.equalTo(genreDescriptionLabel.snp.bottom).offset(14)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(200)
            }
        }
        
        [divide1View, divide2View].forEach { 
            $0.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(1)
            }
        }
        
        completeButton.snp.makeConstraints {
            $0.width.equalTo(48)
            $0.height.equalTo(42)
        }
        
        backButton.snp.makeConstraints {
            $0.size.equalTo(44)
        }
    }
}

extension MyPageEditProfileView {
    
    //MARK: - Custom Method
    
    func updateNicknameTextFieldColor(update: Bool) {
        nicknameWarningLabel.isHidden = true
        
        if update {
            nicknameTextField.do {
                $0.backgroundColor = .wssWhite
                $0.layer.borderColor = UIColor.wssGray70.cgColor
                $0.layer.borderWidth = 1
            }
            
            checkButton.do {
                $0.setTitleColor(.wssPrimary100, for: .normal)
                $0.backgroundColor = .wssPrimary50
            }
            
        } else {
            nicknameTextField.do {
                $0.backgroundColor = .wssGray50
                $0.layer.borderWidth = 0
            }
            
            checkButton.do {
                $0.setTitleColor(.wssGray200, for: .normal)
                $0.backgroundColor = .wssGray70
            }
        }
    }
    
    func updateIntroTextViewColor(update: Bool) {
        if update {
            introTextView.do {
                $0.backgroundColor = .wssWhite
                $0.layer.borderWidth = 1
                $0.layer.borderColor = UIColor.wssGray70.cgColor
            }
        } else {
            introTextView.do {
                $0.backgroundColor = .wssGray50
                $0.layer.borderWidth = 0
            }
        }
    }
    
    func updateNickname(text: String) {
        nicknameTextField.applyWSSFont(.body2, with: text)
        nicknameCountView.countLabel.applyWSSFont(.label1, with: String(text.count))
    }
    
    func updateIntro(text: String) {
        introTextView.applyWSSFont(.body2, with: text)
        introCountView.countLabel.applyWSSFont(.label1, with: String(text.count))
    }
    
    func warningNickname(isWarning: StringLiterals.MyPage.EditProfileWarningMessage) {
        nicknameTextField.do {
            $0.backgroundColor = .wssWhite
            $0.layer.borderColor = UIColor.wssSecondary100.cgColor
            $0.layer.borderWidth = 1
        }
        
        nicknameWarningLabel.do {
            $0.isHidden = false
            $0.applyWSSFont(.label1, with: isWarning.rawValue)
        }
    }
    
    //MARK: - Data
    
    func bindData(nickName: String, intro: String) {
        nicknameTextField.applyWSSFont(.body2, with: nickName)
        introTextView.applyWSSFont(.body2, with: intro)
    }
}
