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
        let viewDidLoad: Observable<Int>
        let viewWillAppear: Driver<Bool>
        let viewWillDisappear: Driver<Bool>
        let continueButtonDidTap: ControlEvent<Void>
        let changeButtonDidTap: Observable<Int>
        let backButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let viewDidLoadAction = BehaviorRelay(value: false)
        let viewWillAppearAction = BehaviorRelay(value: false)
        let viewWillDisappearAction = BehaviorRelay(value: false)
        let bindAvatarDataEvent = PublishRelay<AvatarResult>()
        let currentState = BehaviorRelay(value: false)
        let changeButtonAction = BehaviorRelay(value: false)
        let backAction = BehaviorRelay(value: false)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .observe(on: MainScheduler.instance)
            .flatMap { [weak self] avatarId -> Observable<AvatarResult> in
                guard let self = self else { return .empty() }
                return self.getAvatarData(avatarId: avatarId)
            }
            .subscribe(onNext: { data in
                output.bindAvatarDataEvent.accept(data)
                output.viewDidLoadAction.accept(true)
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .drive(output.viewWillAppearAction)
            .disposed(by: disposeBag)
        
        input.viewWillDisappear
            .drive(output.viewWillDisappearAction)
            .disposed(by: disposeBag)
        
        input.changeButtonDidTap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, avatarId in
                owner.patchAvatar(avatarId: avatarId)
                output.backAction.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.continueButtonDidTap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe { _ in
                output.backAction.accept(true)
            }
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe { _ in
                output.backAction.accept(true)
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
    //MARK: - API
    
    private func getAvatarData(avatarId: Int) -> Observable<AvatarResult> {
        return self.avatarRepository.getAvatarData(avatarId: avatarId)
    }
    
    private func patchAvatar(avatarId: Int) -> Observable<Void> {
        return self.avatarRepository.patchAvatar(avatarId: avatarId)
    }
}
