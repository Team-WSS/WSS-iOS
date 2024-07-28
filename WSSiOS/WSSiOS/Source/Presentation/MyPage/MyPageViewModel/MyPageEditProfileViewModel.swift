//
//  MyPageEditProfileViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 7/26/24.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa

final class MyPageEditProfileViewModel: ViewModelType {
    
    //MARK: - Properties
    
    //TODO: 서연이 코드랑 합칠 예정
    let genreList = ["로맨스", "로판", "판타지", "현판", "무협", "BL", "라노벨", "미스터리", "드라마"]
    
    static let nicknameLimit = 10
    static let introLimit = 40
    
    //더미 데이터
    private var userNickname = "밝보"
    private var userIntro = "ㅎㅇ"
    private var userImage = ""
    private var genre = ["로맨스", "드라마"]
    
    //MARK: - Life Cycle
    
    struct Input {
        let backButtonDidTap: ControlEvent<Void>
        let completeButtonDidTap: ControlEvent<Void>
        let profileViewDidTap: Observable<UITapGestureRecognizer>
        
        let updateNicknameText: Observable<String>
        let textFieldBeginEditing: ControlEvent<Void>
        let clearButtonDidTap: ControlEvent<Void>
        let checkButtonDidTap: ControlEvent<Void>
        
        let updateIntroText: Observable<String>
        let textViewBeginEditing: ControlEvent<Void>
        
        let genreCellTap: ControlEvent<IndexPath>
    }
    
    struct Output {
        let bindUserData = BehaviorRelay<MyProfileResult>(value: MyProfileResult(
            nickname: "",
            intro: "",
            avatarImage: "",
            genrePreferences: [""]))
        
        //TODO: 서연이 코드 합치면서 수정하기
        let bindGenreCell = BehaviorRelay<[String]>(value: ["로맨스", "로판", "판타지", "현판", "무협", "BL", "라노벨", "미스터리", "드라마"])
        let popViewController = PublishRelay<Bool>() 
        
        let nicknameText = BehaviorRelay<String>(value: "")
        let editingTextField = BehaviorRelay<Bool>(value: false)
        let isShwonWarning = PublishRelay<StringLiterals.MyPage.EditProfileWarningMessage>() 
        
        let introText = BehaviorRelay<String>(value: "")
        let editingTextView = BehaviorRelay<Bool>(value: false)
        
        let updateCell = PublishRelay<IndexPath>()
        let completeButtonIsAble = BehaviorRelay<Bool>(value: false)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        output.bindUserData.accept(MyProfileResult(
            nickname: self.userNickname,
            intro: self.userIntro,
            avatarImage: self.userImage,
            genrePreferences: self.genreList))
        
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
            })
            .disposed(by: disposeBag)
        
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
            })
            .disposed(by: disposeBag)
        
        input.checkButtonDidTap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                
                //TODO: 현재 임시 더미 넣어놓음 중복 체크 서버 연결 후 수정
                if owner.userNickname == output.nicknameText.value {
                    output.editingTextField.accept(false)
                    output.completeButtonIsAble.accept(false)
                } else if output.nicknameText.value.count < 2 {
                    //서버연결
                    output.isShwonWarning.accept(.guid)
                    output.completeButtonIsAble.accept(false)
                }
                else {
                    //TODO: 중복 체크 완료시
                    output.editingTextField.accept(false)
                    output.completeButtonIsAble.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        input.updateIntroText
            .subscribe(with: self, onNext: { owner, text in
                output.introText.accept(String(text.prefix(MyPageEditProfileViewModel.introLimit)))
                if owner.userIntro ==  output.introText.value {
                    output.completeButtonIsAble.accept(false)
                } else {
                    output.completeButtonIsAble.accept(true)
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
                output.updateCell.accept(indexPath)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    //MARK: - Custom Method
    
    
    //MARK: - API
    
}


