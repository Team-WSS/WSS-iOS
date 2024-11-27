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
    
    private let myPageProfileView = UIView()
    private var userImageView = CircularImageView()
    let userImageChangeInnerButton: UIButton = CircularButton()
    private let userImageChangeInnerButtonView = UIImageView()

    private let nicknameView = UIView()
    private let nicknameLabel = UILabel()
    lazy var nicknameTextField = UITextField()
    lazy var nicknameClearButton = UIButton()
    lazy var nicknameDuplicatedButton = UIButton()
    private let nicknameWarningLabel = UILabel()
    private var nicknameCountView = MyPageCountView(maxLimit: 10)
    
    private let divide1View = UIView()
    
    private let introView = UIView()
    private let introLabel = UILabel()
    lazy var introTextView = UITextView()
    private let introTextViewPlaceholder = UILabel()
    private var introCountView = MyPageCountView(maxLimit: 50)
    
    private let divide2View = UIView()
    
    private let genreView = UIView()
    private let genreLabel = UILabel()
    private let genreDescriptionLabel = UILabel()
    lazy var genreCollectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: UICollectionViewLayout())
    
    //In VC
    let backButton = UIButton()
    let completeButton = UIButton()
    
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
        
        myPageProfileView.do {
            $0.backgroundColor = .wssWhite
            
            userImageChangeInnerButton.do {
                var configuration = UIButton.Configuration.filled()
                configuration.baseBackgroundColor = .wssWhite
                
                $0.configuration = configuration
                $0.imageView?.contentMode = .scaleAspectFit
                
                $0.layer.borderWidth = 1.04
                $0.layer.borderColor = UIColor.wssGray70.cgColor
                
                userImageChangeInnerButtonView.do {
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
                $0.font = .Body2
                $0.backgroundColor = .wssGray50
                $0.layer.cornerRadius = 12
                
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 44))
                $0.leftView = paddingView
                $0.leftViewMode = .always
                $0.contentVerticalAlignment = .center
                
                let rightViewContainer = UIView(frame: CGRect(x: -13, y: 0, width: 44, height: 44))
                
                nicknameClearButton.do {
                    $0.setImage(.icCancelLight, for: .normal)
                    $0.contentMode = .scaleAspectFit
                    $0.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
                }
                
                rightViewContainer.addSubview(nicknameClearButton)
                $0.rightView = rightViewContainer
                $0.rightViewMode = .always
            }
            
            nicknameDuplicatedButton.do {
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
                $0.allowsMultipleSelection = true
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
            $0.setTitle(StringLiterals.MyPage.EditProfile.complete, for: .normal)
            $0.setTitleColor(.wssGray200, for: .normal)
            $0.titleLabel?.font = .Title2
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(myPageProfileView,
                         nicknameView,
                         introView,
                         genreView)
        myPageProfileView.addSubviews(userImageView,
                                      userImageChangeInnerButton)
        userImageChangeInnerButton.addSubview(userImageChangeInnerButtonView)
        nicknameView.addSubviews(nicknameLabel,
                                 nicknameTextField,
                                 nicknameDuplicatedButton,
                                 nicknameWarningLabel,
                                 nicknameCountView,
                                 divide1View)
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
        myPageProfileView.snp.makeConstraints {
            if UIScreen.isSE {
                $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(38-7)
            } else {
                $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(38)
            }
            $0.centerX.equalToSuperview()
            $0.size.equalTo(94)
            
            userImageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            userImageChangeInnerButton.snp.makeConstraints {
                $0.trailing.equalTo(userImageView.snp.trailing)
                $0.bottom.equalTo(userImageView.snp.bottom)
                $0.size.equalTo(25)
                
                userImageChangeInnerButtonView.snp.makeConstraints {
                    $0.center.equalToSuperview()
                    $0.size.equalTo(20)
                }
            }
        }
        
        nicknameView.snp.makeConstraints {
            if UIScreen.isSE {
                $0.top.equalTo(myPageProfileView.snp.bottom).offset(29-7)
            } else {
                $0.top.equalTo(myPageProfileView.snp.bottom).offset(29)
            }
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
            }
            
            nicknameDuplicatedButton.snp.makeConstraints {
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
            $0.width.bottom.equalToSuperview()
            
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
                $0.bottom.equalToSuperview()
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

    //네비게이션
    func isAbledCompleteButton(isAbled: Bool) {
        if isAbled {
            completeButton.setTitleColor(.wssPrimary100, for: .normal)
        } else {
            completeButton.setTitleColor(.wssGray200, for: .normal)
        }
        
        completeButton.isEnabled = isAbled
    }
    
    //프로필
    func updateProfileImage(image: String) {
        userImageView.do {
            $0.kfSetImage(url: makeBucketImageURLString(path: image))
        }
    }
    
    //닉네임
    func updateNicknameText(text: String) {
        nicknameTextField.text = text
        nicknameCountView.countLabel.applyWSSFont(.label1, with: String(text.count))
    }
    
    func updateNicknameTextField(isEditing: Bool, availablity: NicknameAvailablity) {
        var borderColor: CGColor = UIColor.wssGray70.cgColor
        
        switch availablity {
        case .available:
            borderColor = UIColor.wssPrimary100.cgColor
        case .notAvailable:
            borderColor = UIColor.wssSecondary100.cgColor
        default:
            borderColor = UIColor.wssGray70.cgColor
        }
        
        nicknameTextField.do {
            $0.backgroundColor = isEditing ? .wssWhite : .wssGray50
            $0.layer.borderWidth = isEditing ? 1 : 0
            $0.layer.borderColor = borderColor
        }
    }
    
    func updateNickNameWarningLabel(isEditing: Bool, availablity: NicknameAvailablity) {
        nicknameWarningLabel.do {
            $0.isHidden = availablity.descriptionIsHidden()
            $0.applyWSSFont(.body4, with:  availablity.description())
            $0.textColor = availablity.color()
        }
    }
    
    func updateNicknameClearButton(isEditing: Bool, availablity: NicknameAvailablity) {
        var buttonImage: UIImage = .icCancelDark
        
        switch availablity {
        case .available:
            buttonImage = .icNickNameAvailable
        case .notAvailable:
            buttonImage = .icNickNameError
        default:
            break
        }
        
        nicknameClearButton.do {
            $0.isHidden = !isEditing
            $0.setImage(buttonImage, for: .normal)
            $0.isUserInteractionEnabled = !(availablity == .available)
        }
    }
    
    func updateNicknameDuplicatedButton(isEnabled: Bool) {
        nicknameDuplicatedButton.do {
            $0.isEnabled = isEnabled
            $0.backgroundColor = isEnabled ? .wssPrimary50 : .wssGray70
            $0.setTitleColor(isEnabled ? .wssPrimary100 : .wssGray200, for: .normal)
        }
    }
    
    //소개
    func updateIntroTextViewColor(update: Bool) {
        if update {
            introTextView.do {
                $0.backgroundColor = .wssWhite
                $0.layer.borderWidth = 1
                $0.layer.borderColor = UIColor.wssGray70.cgColor
            }
            
            introTextViewPlaceholder.isHidden = true
            
        } else {
            introTextView.do {
                $0.backgroundColor = .wssGray50
                $0.layer.borderWidth = 0
            }
            
            if introTextView.text == "" {
                introTextViewPlaceholder.isHidden = false
            } else {
                introTextViewPlaceholder.isHidden = true
            }
        }
    }
    
    func updateIntro(text: String) {
        introTextView.applyWSSFont(.body2, with: text)
        introCountView.countLabel.applyWSSFont(.label1, with: String(text.count))
    }
    
    //MARK: - Data
    
    func bindData(data: MyProfileResult) {
        
        nicknameTextField.text = data.nickname
        
        introTextView.applyWSSFont(.body2, with: data.intro)
        if !data.intro.isEmpty {
            introTextViewPlaceholder.isHidden = true
        } else {
            introCountView.isHidden = false
        }
        
        userImageView.do {
            $0.kfSetImage(url: makeBucketImageURLString(path: data.avatarImage))
        }
    }
}
