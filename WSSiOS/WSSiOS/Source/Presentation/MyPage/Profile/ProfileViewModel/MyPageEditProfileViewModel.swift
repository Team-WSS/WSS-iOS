//
//  MyPageEditProfileViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 7/26/24.
//

import UIKit

import RxSwift
import RxCocoa

final class MyPageEditProfileViewModel: ViewModelType {
    
    //MARK: - Properties
    
    //TODO: 서연이 코드랑 합칠 예정
    let genreList = ["로맨스", "로판", "판타지", "현판", "무협", "BL", "라노벨", "미스터리", "드라마"]
    
    static let nicknameLimit = 10
    static let introLimit = 40
    private var updateImage = BehaviorRelay<Bool>(value: false)
    private var updateNickname = BehaviorRelay<Bool>(value: false)
    private var updateIntro = BehaviorRelay<Bool>(value: false)
    private var updateGenre = BehaviorRelay<Bool>(value: false)
    private var updateCompleteButton = BehaviorRelay<Bool>(value: false)
    
    private let userRepository: UserRepository
    private var profileData: MyProfileResult
    
    private var userNickname = BehaviorRelay<String>(value: "")
    private let userIntro = BehaviorRelay<String>(value: "")
    private let userGenre = BehaviorRelay<[String]>(value: [])
    private let userImage = BehaviorRelay<String>(value: "")
    
    
    //MARK: - Life Cycle
    
    init(userRepository: UserRepository,
         profileData: MyProfileResult) {
        
        self.userRepository = userRepository
        self.profileData = profileData
    }
    
    struct Input {
        let backButtonDidTap: ControlEvent<Void>
        let completeButtonDidTap: ControlEvent<Void>
        let profileViewDidTap: Observable<UITapGestureRecognizer>
        
        let updateNicknameText: Observable<String>
        let textFieldBeginEditing: ControlEvent<Void>
        let clearButtonDidTap: ControlEvent<Void>
        let checkButtonDidTap: ControlEvent<Void>
        
        let viewDidTap: ControlEvent<UITapGestureRecognizer>
        let updateIntroText: Observable<String>
        let textViewBeginEditing: ControlEvent<Void>
        
        let genreCellTap: ControlEvent<IndexPath>
    }
    
    struct Output {
        //TODO: 서연이 코드 합치면서 수정하기
        let bindGenreCell = BehaviorRelay<[String]>(value: ["로맨스", "로판", "판타지", "현판", "무협", "BL", "라노벨", "미스터리", "드라마"])
        let popViewController = PublishRelay<Bool>()
        
        let bindProfileData = BehaviorRelay<MyProfileResult>(value: MyProfileResult(nickname: "",
                                                                                    intro: "",
                                                                                    avatarImage: "",
                                                                                    genrePreferences: []))
        let nicknameText = BehaviorRelay<String>(value: "")
        let editingTextField = BehaviorRelay<Bool>(value: false)
        let isShownWarning = PublishRelay<StringLiterals.MyPage.EditProfileWarningMessage>()
        let checkButtonIsAbled = BehaviorRelay<Bool>(value: false)
        
        let introText = BehaviorRelay<String>(value: "")
        let editingTextView = BehaviorRelay<Bool>(value: false)
        let endEditing = PublishRelay<Bool>()
        
        let updateCell = PublishRelay<IndexPath>()
        let completeButtonIsAbled = BehaviorRelay<Bool>(value: false)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        self.userNickname.accept(self.profileData.nickname)
        self.userIntro.accept(self.profileData.intro)
        self.userGenre.accept(self.profileData.genrePreferences)
        self.userImage.accept(self.profileData.avatarImage)
        
        output.bindProfileData.accept(self.profileData)
        
        input.backButtonDidTap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                output.popViewController.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.completeButtonDidTap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                //서버통신 구현
                output.popViewController.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.profileViewDidTap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                //VC 이동
                owner.updateImage.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.updateNicknameText
            .subscribe(with: self, onNext: { owner, text in
                output.nicknameText.accept(String(text.prefix(MyPageEditProfileViewModel.nicknameLimit)))
                
                owner.updateNickname.accept(false)
                
                if owner.userNickname.value == output.nicknameText.value {
                    output.checkButtonIsAbled.accept(false)
                } else {
                    owner.updateNickname.accept(true)
                    output.checkButtonIsAbled.accept(true)
                    owner.checkCompleteButton()
                }
            })
            .disposed(by: disposeBag)
        
        input.textFieldBeginEditing
            .subscribe(with: self, onNext: { owner, _ in
                output.editingTextField.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.clearButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                output.nicknameText.accept("")
                owner.updateNickname.accept(false)
                output.editingTextField.accept(true)
                output.completeButtonIsAbled.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.checkButtonDidTap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                
                if owner.userNickname.value == output.nicknameText.value {
                    output.editingTextField.accept(false)
                    owner.updateNickname.accept(false)
                } else {
                    //TODO: 중복 체크 완료시
                    output.editingTextField.accept(false)
                    owner.updateNickname.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        input.viewDidTap
            .subscribe(onNext: { _ in
                output.endEditing.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.updateIntroText
            .subscribe(with: self, onNext: { owner, text in
                output.introText.accept(String(text.prefix(MyPageEditProfileViewModel.introLimit)))
                if owner.userIntro.value ==  output.introText.value {
                    owner.updateIntro.accept(false)
                } else {
                    owner.updateIntro.accept(true)
                    owner.checkCompleteButton()
                }
            })
            .disposed(by: disposeBag)
        
        input.textViewBeginEditing
            .subscribe(with: self, onNext: { owner, _ in
                output.editingTextView.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.genreCellTap
            .bind(with: self, onNext: { owner, indexPath in
                print(indexPath, "😃")
                owner.updateGenre.accept(true)
                output.updateCell.accept(indexPath)
                owner.checkCompleteButton()
            })
            .disposed(by: disposeBag)
        
        updateCompleteButton
            .bind(with: self, onNext: { owner, update in
                output.completeButtonIsAbled.accept(update)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    //MARK: - Custom Method
    
    private func checkCompleteButton() {
        if self.updateGenre.value && self.updateImage.value && self.updateIntro.value && self.updateNickname.value {
            updateCompleteButton.accept(true)
        } else {
            updateCompleteButton.accept(false)
        }
    }
    
    //MARK: - API
    
}


