//
//  MyPageViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 7/9/24.
//

import Foundation

import RxSwift
import RxCocoa

final class MyPageViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    struct Input {
        let isMyPage: Driver<Bool>
        let settingButtonDidTap: ControlEvent<Void>
        let dropdownButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let profileData = PublishRelay<MyProfileResult>()
        let settingButtonAction = BehaviorRelay(value: false)
        let dropdownButtonAction = BehaviorRelay(value: false)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.isMyPage
            .asObservable()
            .flatMapLatest { [unowned self] isMyPage in
                self.getProfileData(isMyPage: isMyPage)
            }
            .bind(to: output.profileData)
            .disposed(by: disposeBag)
        return output
    }
    
    // MARK: - Custom Method
    
    
    // MARK: - API
    
    private func getProfileData(isMyPage: Bool) -> Observable<MyProfileResult> {
        if isMyPage {
            return userRepository.getMyProfileData().asObservable()
        } else {
            return userRepository.getMyProfileData().asObservable()
        }
    }
}
