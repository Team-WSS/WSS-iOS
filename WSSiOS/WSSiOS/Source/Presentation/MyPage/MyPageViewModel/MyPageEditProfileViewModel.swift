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
    private let genreList = ["로맨스", "로판", "판타지", "현판", "무협", "BL", "라노벨", "미스터리", "드라마"]
    private let dummySelectList = ["romanceFantasy", "fantasy", "drama"]
    
    //MARK: - Life Cycle
    
    struct Input {
        let backButtonDidTap: ControlEvent<Void>
        let completeButtonDidTap: ControlEvent<Void>
        let profileViewDidTap: Observable<UITapGestureRecognizer>
        let clearButtonDidTap: ControlEvent<Void>
        let checkButtonDidTap: ControlEvent<Void>
        let genreCellTap: ControlEvent<String.Type>
    }
    
    struct Output {
        let bindGenreCell = BehaviorRelay<[String]>(value: ["로맨스", "로판", "판타지", "현판", "무협", "BL", "라노벨", "미스터리", "드라마"])
        let popViewController = PublishRelay<Bool>() 
        let nicknameText = BehaviorRelay<String>(value: "")
        let introText = BehaviorRelay<String>(value: "")
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
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
            })
            .disposed(by: disposeBag)
        
        input.profileViewDidTap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                //VC 이동
            })
            .disposed(by: disposeBag)
        
        input.clearButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                output.nicknameText.accept("")
            })
            .disposed(by: disposeBag)
        
        input.checkButtonDidTap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                //중복 확인 서버통신 구현
            })
            .disposed(by: disposeBag)
        
        input.genreCellTap
            .subscribe(with: self, onNext: { owner, _ in
                //Cell Tap 액션
            })
            .disposed(by: disposeBag)
       
        return output
    }
    
    //MARK: - Custom Method
    
    
    //MARK: - API
   
}


