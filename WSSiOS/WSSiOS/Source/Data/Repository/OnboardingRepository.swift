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
    func postUserProfile(nickname: String, gender: OnboardingGender, birth: Int, genrePreferences: [NewNovelGenre]) -> Single<Void>
}

struct TestOnboardingRepository: OnboardingRepository {
    func getNicknameisValid(_ nickname: String) -> Single<OnboardingResult> {
        return Single.just(OnboardingResult(isValid: false))
    }
    
    func postUserProfile(nickname: String, gender: OnboardingGender, birth: Int, genrePreferences: [NewNovelGenre]) -> Single<Void> {
        return Single.just(())
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
    
    func postUserProfile(nickname: String, gender: OnboardingGender, birth: Int, genrePreferences: [NewNovelGenre]) -> Single<Void> {
        let userInfoResult = UserInfoResult(
            nickname: nickname,
            gender: gender.rawValue,
            birth: birth,
            genrePreferences: genrePreferences.map { $0.rawValue }
        )
        return onboardingService.postUserProfile(userInfoResult: userInfoResult)
    }
}

