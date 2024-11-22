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
    
    private let userRepository: UserRepository
    private var profileData: MyProfileResult
    
    private var userNickname = BehaviorRelay<String>(value: "")
    private let userIntro = BehaviorRelay<String>(value: "")
    private let userGenre = BehaviorRelay<[String]>(value: [])
    private let userImage = BehaviorRelay<String>(value: "")
    
    private var changeCompleteButtonRelay = BehaviorRelay<Bool>(value: false)
    
    
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
        let bindGenreCell = BehaviorRelay<[(String, Bool)]>(value: [])
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
        
        let updateCell = PublishRelay<(IndexPath, Bool)>()
        let completeButtonIsAbled = BehaviorRelay<Bool>(value: false)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // 데이터 초기 설정
        self.userNickname.accept(self.profileData.nickname)
        self.userIntro.accept(self.profileData.intro)
        self.userGenre.accept(self.profileData.genrePreferences)
        self.userImage.accept(self.profileData.avatarImage)
        
        output.bindProfileData.accept(self.profileData)
        
        let bindGenreTuple = checkGenreToMakeTuple(self.genreList, self.userGenre.value)
        output.bindGenreCell.accept(bindGenreTuple)
        
        // 네비게이션 기능
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
        
        changeCompleteButtonRelay
            .distinctUntilChanged()
            .bind(to: output.completeButtonIsAbled)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(userNickname, userIntro, userGenre, userImage)
            .subscribe(with: self, onNext: { owner, _ in
                owner.changeInfoData()
            })
            .disposed(by: disposeBag)
        
        // 프로필 기능
        input.profileViewDidTap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                //VC 이동
            })
            .disposed(by: disposeBag)
        
        // 닉네임 기능
        input.updateNicknameText
            .subscribe(with: self, onNext: { owner, text in
                output.nicknameText.accept(String(text.prefix(MyPageEditProfileViewModel.nicknameLimit)))
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
                output.editingTextField.accept(true)
                output.completeButtonIsAbled.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.checkButtonDidTap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                
                if owner.userNickname.value == output.nicknameText.value {
                    output.editingTextField.accept(false)
                } else {
                    //TODO: 중복 체크 완료시
                    output.editingTextField.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        input.viewDidTap
            .subscribe(onNext: { _ in
                output.endEditing.accept(true)
            })
            .disposed(by: disposeBag)
        
        // 소개 기능
        input.updateIntroText
            .subscribe(with: self, onNext: { owner, text in
                output.introText.accept(String(text.prefix(MyPageEditProfileViewModel.introLimit)))
                owner.userIntro.accept(String(text.prefix(MyPageEditProfileViewModel.introLimit)))
            })
            .disposed(by: disposeBag)
        
        input.textViewBeginEditing
            .subscribe(with: self, onNext: { owner, _ in
                output.editingTextView.accept(true)
            })
            .disposed(by: disposeBag)
        
        // 선호 장르 기능
        input.genreCellTap
            .bind(with: self, onNext: { owner, indexPath in
                let cellContent = owner.genreList[indexPath.row]
                let update = owner.checkGenreToUpdateCell(owner.userGenre.value, cellContent)
                
                var updatedGenres = owner.userGenre.value
                if (update) {
                    updatedGenres = updatedGenres.filter { $0 != cellContent }
                } else {
                    updatedGenres.append(cellContent)
                }
                owner.userGenre.accept(updatedGenres)
                output.updateCell.accept((indexPath, !update))
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    //MARK: - Custom Method
    
    private func checkGenreToMakeTuple(_ totalGenre: [String], _ myGenre: [String]) -> [(String, Bool)] {
        return totalGenre.map { genre in
            let isPreferred = myGenre.contains(genre)
            return (genre, isPreferred)
        }
    }
    
    private func checkGenreToUpdateCell(_ totalGenre: [String], _ myGenre: String) -> Bool {
        return totalGenre.contains { genre in
            myGenre.contains(genre)
        }
    }
    
    private func changeInfoData() {
        if (self.userNickname.value == "" || self.userIntro.value == "" || self.userGenre.value == []) {
            self.changeCompleteButtonRelay.accept(false)
        }
        else if (self.userNickname.value == profileData.nickname && self.userIntro.value == profileData.intro && self.userGenre.value == profileData.genrePreferences && self.userImage.value == self.profileData.avatarImage) {
            self.changeCompleteButtonRelay.accept(false)
        }
        else {
            self.changeCompleteButtonRelay.accept(true)
        }
    }
    
    //MARK: - API
    
}


