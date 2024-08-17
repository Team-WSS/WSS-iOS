//
//  MyPageViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 1/10/24.
//

import Foundation

import RxSwift
import RxCocoa

final class MyPageChangeNickNameViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let userRepository: UserRepository
    private var updateNicknameText: String = ""
    private let maximumNickNameCount: Int = 10
    var userNickName: String
    
    
    //MARK: - Life Cycle
    
    init(userRepository: UserRepository, userNickname: String) {
        self.userRepository = userRepository
        self.userNickName = userNickname
    }
    
    struct Input {
        let updateNicknameTextField: Driver<String>
        let completeButtonDidTap: ControlEvent<Void>
        let clearButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let completeButtonIsAble = BehaviorRelay(value: false)
        let completeButtonAction = BehaviorRelay(value: false)
        let textFieldUnderlineColor = BehaviorRelay(value: false)
        let completeButtonTitleColor = BehaviorRelay(value: false)
        let countLabelText = BehaviorRelay(value: String())
        let newNicknameText = BehaviorRelay(value: String())
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.updateNicknameTextField
            .drive(with: self, onNext: { owner, newNickname in    
                let limitNewNickname = String(newNickname.prefix(owner.maximumNickNameCount))
                owner.updateNicknameText = limitNewNickname
                
                if owner.updateNicknameText == owner.userNickName || owner.updateNicknameText.isEmpty == true {
                    owner.changeNickname(output: output, isAble: false)
                } else {
                    owner.changeNickname(output: output, isAble: true)
                }
            })
            .disposed(by: disposeBag)
        
        input.completeButtonDidTap
            .withLatestFrom(output.completeButtonIsAble)
            .filter { isAble in isAble }
//            .flatMapLatest { [unowned self] _ in
//                patchUserNickName(nickname: self.updateNicknameText)
//            }
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, result in
                output.completeButtonAction.accept(true)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        input.clearButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in 
                owner.updateNicknameText = ""
                owner.changeNickname(output: output, isAble: false)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    //MARK: - Custom Method
    
    private func changeNickname(output: Output, isAble: Bool) {
        output.newNicknameText.accept(self.updateNicknameText)
        output.countLabelText.accept("\(String(self.updateNicknameText.count))/\(self.maximumNickNameCount)")
        
        if !isAble {
            output.completeButtonTitleColor.accept(isAble)
            output.textFieldUnderlineColor.accept(isAble)
            output.completeButtonIsAble.accept(isAble)
        }
        else {
            output.completeButtonTitleColor.accept(isAble)
            output.textFieldUnderlineColor.accept(isAble)
            output.completeButtonIsAble.accept(isAble)
        }
    }
    
    //MARK: - API
    
//    private func patchUserNickName(nickname: String) -> Observable<Void> {
//        return self.userRepository.patchUserName(userNickName: nickname)
//    }
}
