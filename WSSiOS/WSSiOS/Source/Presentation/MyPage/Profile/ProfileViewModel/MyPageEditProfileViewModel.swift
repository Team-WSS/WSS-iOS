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
    
    let genreList: [String] = NovelGenre.allCases.map { $0.toKorean }
    
    private let nicknamePattern = "^[a-zA-Z0-9가-힣]{2,10}$"
    static let nicknameLimit = 10
    static let introLimit = 50
    
    private let userRepository: UserRepository
    private var profileData: MyProfileResult
    private var avatarId: Int = -1
    
    private var userNickname = BehaviorRelay<String>(value: "")
    private let userIntro = BehaviorRelay<String>(value: "")
    private let userGenre = BehaviorRelay<[String]>(value: [])
    private let userImage = BehaviorRelay<String>(value: "")
    
    private var changeCompleteButtonRelay = BehaviorRelay<Bool>(value: false)
    private let isNicknameAvailable = BehaviorRelay<NicknameAvailablity>(value: .notStarted)
    private let showNetworkErrorView = PublishRelay<Void>()
    private let checkDuplicatedButton = BehaviorRelay<Bool>(value: false)
    
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
        let avatarImageNotification: Observable<Notification>
        
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
        let pushToAvatarViewController = PublishRelay<Bool>()
        let updateProfileImage = PublishRelay<String>()
        
        let nicknameText = BehaviorRelay<String>(value: "")
        let editingTextField = BehaviorRelay<Bool>(value: false)
        let checkShwonWarningMessage = BehaviorRelay<NicknameAvailablity>(value: .notStarted)
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
            .observe(on: MainScheduler.instance)
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .flatMapLatest{ _ -> Observable<Void> in
                var updatedFields: [String: Any] = [:]
                
                if self.userImage.value != self.profileData.avatarImage && self.avatarId != -1  {
                    updatedFields["avatarId"] = self.avatarId
                }
                
                if self.userNickname.value != self.profileData.nickname {
                    updatedFields["nickname"] = self.userNickname.value
                }
                
                if self.userIntro.value != self.profileData.intro {
                    updatedFields["intro"] = self.userIntro.value
                }
                
                if self.userGenre.value != self.profileData.genrePreferences {
                    updatedFields["genrePreferences"] = self.userGenre.value.compactMap { genre in
                        NewNovelGenre.withKoreanRawValue(from: genre).rawValue
                    }
                } else {
                    updatedFields["genrePreferences"] = []
                }
                
                return self.patchProfile(updatedFields: updatedFields)
            }
            .subscribe(
                onNext: {
                    UserDefaults.standard.removeObject(forKey: StringLiterals.UserDefault.userNickname)
                    UserDefaults.standard.setValue(self.userNickname.value, forKey: StringLiterals.UserDefault.userNickname)
                    
                    output.popViewController.accept(true)
                },
                onError: { error in
                    print(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
        
        changeCompleteButtonRelay
            .distinctUntilChanged()
            .bind(to: output.completeButtonIsAbled)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(userNickname, userIntro, userGenre, userImage, checkDuplicatedButton)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                owner.changeInfoData()
            })
            .disposed(by: disposeBag)
        
        // 프로필 기능
        input.profileViewDidTap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                output.pushToAvatarViewController.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.avatarImageNotification
            .subscribe(with: self, onNext: { owner, notification in
                guard let avatarData = notification.object as? (Int, String) else { return }
                owner.avatarId = avatarData.0
                owner.userImage.accept(avatarData.1)
                output.updateProfileImage.accept(avatarData.1)
            })
            .disposed(by: disposeBag)
        
        // 닉네임 기능
        input.updateNicknameText
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, text in
                output.nicknameText.accept(String(text.prefix(MyPageEditProfileViewModel.nicknameLimit)))
                owner.checkNicknameAvailability(text)
                
                let isNickNameValid = owner.isValidNicknameCharacters(text)
                output.checkButtonIsAbled.accept(text != owner.userNickname.value && isNickNameValid)
                
                if(text != owner.profileData.nickname) {
                    owner.checkDuplicatedButton.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        input.textFieldBeginEditing
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                output.editingTextField.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.clearButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                output.nicknameText.accept("")
                
                output.editingTextField.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.checkButtonDidTap
            .withLatestFrom(input.updateNicknameText)
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, nickname in
                owner.checkNicknameisValid(nickname, disposeBag: disposeBag)
            })
            .disposed(by: disposeBag)
        
        self.isNicknameAvailable
            .bind(with: self, onNext: { owner, availablity in
                output.checkShwonWarningMessage.accept(availablity)
                output.checkButtonIsAbled.accept(availablity != .available && availablity != .notStarted)
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
                owner.userIntro.accept(String(text.prefix(MyPageEditProfileViewModel.introLimit)))
                output.introText.accept(owner.userIntro.value)
            })
            .disposed(by: disposeBag)
        
        input.textViewBeginEditing
            .observe(on: MainScheduler.instance)
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
        if (self.userNickname.value == profileData.nickname && self.userIntro.value == profileData.intro && self.userGenre.value == profileData.genrePreferences && self.userImage.value == self.profileData.avatarImage) {
            self.changeCompleteButtonRelay.accept(self.checkDuplicatedButton.value)
        }
        else {
            self.changeCompleteButtonRelay.accept(true)
        }
    }
    
    private func checkNicknameAvailability(_ nickname: String) {
        if nickname.isEmpty {
            self.isNicknameAvailable.accept(.notStarted)
        } else if !self.isValidNicknameCharacters(nickname) {
            if nickname.contains(where: { $0 == " " }) {
                self.isNicknameAvailable.accept(
                    .notAvailable(reason: .whiteSpaceIncluded)
                )
            } else {
                self.isNicknameAvailable.accept(
                    .notAvailable(reason: .invalidChacterOrLimitExceeded)
                )
            }
        } else {
            self.isNicknameAvailable.accept(.unknown)
        }
    }
    
    private func isValidNicknameCharacters(_ text: String) -> Bool {
        return text.range(of: nicknamePattern, options: .regularExpression) != nil
    }
    
    private func acceptNicknameNotAvailableReason(from code: String) {
        let reason: NicknameNotAvailableReason
        switch code {
        case "USER-003":
            reason = .whiteSpaceIncluded
        case "USER-014":
            reason = .notChanged
        default:
            reason = .invalidChacterOrLimitExceeded
        }
        
        self.isNicknameAvailable.accept(.notAvailable(reason: reason))
    }
    
    //MARK: - API
    
    private func patchProfile(updatedFields: [String: Any]) -> Observable<Void> {
        return userRepository.patchUserProfile(updatedFields: updatedFields)
            .asObservable()
    }
    
    private func checkNicknameisValid(_ nickname: String, disposeBag: DisposeBag) {
        self.userRepository.getNicknameisValid(nickname: nickname)
            .map { $0.isValid }
            .subscribe(with: self, onSuccess: { owner, isValid in
                if isValid {
                    owner.isNicknameAvailable.accept(.available)
                    owner.checkDuplicatedButton.accept(true)
                } else {
                    owner.isNicknameAvailable.accept(
                        .notAvailable(reason: .duplicated)
                    )
                }
            }, onFailure: { owner, error in
                guard let networkError = error as? RxCocoaURLError else {
                    owner.showNetworkErrorView.accept(())
                    owner.checkDuplicatedButton.accept(false)
                    return
                }
                
                switch networkError {
                case .httpRequestFailed(_, let data):
                    if let data,
                       let errorResponse = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                        owner.acceptNicknameNotAvailableReason(from: errorResponse.code)
                    } else {
                        owner.showNetworkErrorView.accept(())
                    }
                default:
                    owner.showNetworkErrorView.accept(())
                }
            })
            .disposed(by: disposeBag)
    }
}


