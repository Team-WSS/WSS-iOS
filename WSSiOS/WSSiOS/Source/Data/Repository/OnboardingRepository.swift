//
//  OnboardingRepository.swift
//  WSSiOS
//
//  Created by YunhakLee on 10/6/24.
//

import Foundation

import RxSwift

protocol OnboardingRepository {
    func getNicknameisValid(_ nickname: String) -> Observable<OnboardingResult>
}

struct TestOnboardingRepository: OnboardingRepository {
    func getNicknameisValid(_ nickname: String) -> Observable<OnboardingResult> {
        return Observable.just(OnboardingResult(isValid: false))
    }
}

struct DefaultOnboardingRepository: OnboardingRepository {
    private let onboardingService: OnboardingService
    
    init(onboardingService: OnboardingService) {
        self.onboardingService = onboardingService
    }
    
    func getNicknameisValid(_ nickname: String) -> Observable<OnboardingResult> {
        return onboardingService.getNicknameisValid(nickname).asObservable()
    }
}

