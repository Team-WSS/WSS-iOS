//
//  ModuleFactory.swift
//  WSSiOS
//
//  Created by 이윤학 on 2/24/24.
//

import UIKit

protocol OnboardingModuleFactory {
    func makeLoginViewController() -> UIViewController
    func makeOnboardingViewController() -> UIViewController
    func makeOnboardingSuccessViewController(nickname: String) -> UIViewController
}

protocol NovelDetailModuleFactory {
    func makeNovelDetailViewController(novelId: Int) -> UIViewController
}

protocol ServiceTermAgreementModuleFactory {
    func makeServiceTermAgreementViewController() -> UIViewController
}

protocol FeedDetailModuleFactory {
    func makeFeedDetailViewController(feedId: Int) -> UIViewController
}

protocol MyPageModuleFactory {
    func makeMyPageViewController() -> UIViewController
    func makeUserPageViewController(profileId: Int) -> UIViewController
    func makeMyPageEditViewController(entryType: MyPageEditEntryType, profile: MyProfileEntity?) -> UIViewController
}

final class ModuleFactory {
    static let shared = ModuleFactory()
    private init() {}
}

extension ModuleFactory: NovelDetailModuleFactory {
    func makeNovelDetailViewController(novelId: Int) -> UIViewController {
        return NovelDetailViewController(
            viewModel: NovelDetailViewModel(
                novelDetailRepository: DefaultNovelDetailRepository(novelDetailService: DefaultNovelDetailService()),
                feedDetailRepository: DefaultFeedDetailRepository(feedDetailService: DefaultFeedDetailService()),
                novelId: novelId))
    }
}

extension ModuleFactory: OnboardingModuleFactory {
    func makeLoginViewController() -> UIViewController {
        return LoginViewController(viewModel: LoginViewModel(authRepository: DefaultAuthRepository(authService: DefaultAuthService())))
    }
    
    func makeOnboardingViewController() -> UIViewController {
        return OnboardingViewController(viewModel: OnboardingViewModel(onboardingRepository: DefaultOnboardingRepository(onboardingService: DefaultOnboardingService()),
                                                                       userRepository: DefaultUserInfoRepository(userService: DefaultUserService())))
    }
    
    func makeOnboardingSuccessViewController(nickname: String) -> UIViewController {
        return OnboardingSuccessViewController(nickname: nickname)
    }
}

extension ModuleFactory: ServiceTermAgreementModuleFactory {
    func makeServiceTermAgreementViewController() -> UIViewController {
        return ServiceTermAgreementViewController(repository: DefaultUserInfoRepository(userService: DefaultUserService()))
    }
}

extension ModuleFactory: FeedDetailModuleFactory {
    func makeFeedDetailViewController(feedId: Int) -> UIViewController {
        return FeedDetailViewController(viewModel: FeedDetailViewModel(feedDetailRepository: DefaultFeedDetailRepository(feedDetailService: DefaultFeedDetailService()),
                                                                       userRepository: DefaultUserInfoRepository(userService: DefaultUserService()),
                                                                       feedId: feedId))
    }
}

extension ModuleFactory: MyPageModuleFactory {
    func makeMyPageViewController() -> UIViewController {
        return MyPageViewController(viewModel: MyPageViewModel(
            userRepository: DefaultUserRepository(
                userInfoRepository: DefaultUserInfoRepository(userService: DefaultUserService()),
                userBlockRepository: DefaultUserBlockRepository(blocksService: DefaultBlocksService()))))
    }
    
    func makeUserPageViewController(profileId: Int) -> UIViewController {
        return UserPageViewController(
            viewModel: UserPageViewModel(
                userRepository: DefaultUserRepository(
                    userInfoRepository: DefaultUserInfoRepository(userService: DefaultUserService()),
                    userBlockRepository: DefaultUserBlockRepository(blocksService: DefaultBlocksService())),
                profileId: profileId))
    }
    
    func makeMyPageEditViewController(entryType: MyPageEditEntryType, profile: MyProfileEntity?) -> UIViewController {
        return MyPageEditProfileViewController(
            viewModel: MyPageEditProfileViewModel(
                userRepository: DefaultUserInfoRepository(userService: DefaultUserService()),
                entryType: entryType,
                profileData: profile))
    }
}
