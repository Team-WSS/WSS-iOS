//
//  MyPageModalViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 3/5/24.
//

import Foundation

import RxSwift
import RxCocoa

final class MyPageCustomModalViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let avatarRepository: AvatarRepository

    //MARK: - Life Cycle
    
    init(avatarRepository: AvatarRepository) {
        self.avatarRepository = avatarRepository
    }
    
    struct Input {
        let viewWillAppear: Driver<Bool>
        let viewWillDisappear: Driver<Bool>
        let continueButtonDidTap: ControlEvent<Void>
        let changeButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let viewWillAppearAction = BehaviorRelay(value: false)
        let viewWillDisappearAction = BehaviorRelay(value: false)
        let continueButtonAction = BehaviorRelay(value: false)
        let changeButtonAction = BehaviorRelay(value: false)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppear
            .drive(output.viewWillAppearAction)
            .disposed(by: disposeBag)
        
        input.viewWillDisappear
            .drive(output.viewWillDisappearAction)
            .disposed(by: disposeBag)
        
        input.changeButtonDidTap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe { _ in
                output.continueButtonAction.accept(true)
            }
            .disposed(by: disposeBag)
        
        input.continueButtonDidTap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe { _ in
                output.changeButtonAction.accept(true)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}
