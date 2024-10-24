//
//  OnboardingRepository.swift
//  WSSiOS
//
//  Created by YunhakLee on 10/6/24.
//

import Foundation

import RxSwift

protocol OnboardingRepository {
    func getNicknameisValid(_ nickname: String) -> Single<OnboardingResult>
}

struct TestOnboardingRepository: OnboardingRepository {
    func getNicknameisValid(_ nickname: String) -> Single<OnboardingResult> {
        return Single.just(OnboardingResult(isValid: false))
    }
}

struct DefaultOnboardingRepository: OnboardingRepository {
    private let onboardingService: OnboardingService
    
    init(onboardingService: OnboardingService) {
        self.onboardingService = onboardingService
    }
    
    func getNicknameisValid(_ nickname: String) -> Single<OnboardingResult> {
        return onboardingService.getNicknameisValid(nickname)
    }
}

