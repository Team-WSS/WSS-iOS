//
//  OnboardingRepository.swift
//  WSSiOS
//
//  Created by YunhakLee on 10/6/24.
//

import Foundation

import RxSwift

protocol OnboardingRepository {
    func getNicknameisValid(_ nickname: String) -> Single<OnboardingResponse>
    func postUserProfile(nickname: String, gender: OnboardingGender, birth: Int, genrePreferences: [NewNovelGenre]) -> Single<Void>
}

struct TestOnboardingRepository: OnboardingRepository {
    func getNicknameisValid(_ nickname: String) -> Single<OnboardingResponse> {
        return Single.just(OnboardingResponse(isValid: false))
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
    
    func getNicknameisValid(_ nickname: String) -> Single<OnboardingResponse> {
        return onboardingService.getNicknameisValid(nickname)
    }
    
    func postUserProfile(nickname: String, gender: OnboardingGender, birth: Int, genrePreferences: [NewNovelGenre]) -> Single<Void> {
        let userInfoResult = UserInfoRequest(
            nickname: nickname,
            gender: gender.rawValue,
            birth: birth,
            genrePreferences: genrePreferences.map { $0.rawValue }
        )
        return onboardingService.postUserProfile(userInfoRequest: userInfoResult)
    }
}

