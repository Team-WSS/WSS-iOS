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

protocol ServiceTermAgreementFactory {
    func makeServiceTermAgreementViewController() -> UIViewController
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
                                                                       userRepository: DefaultUserRepository(userService: DefaultUserService(),
                                                                                                             blocksService: DefaultBlocksService())))
    }
    
    func makeOnboardingSuccessViewController(nickname: String) -> UIViewController {
        return OnboardingSuccessViewController(nickname: nickname)
    }
}

extension ModuleFactory: ServiceTermAgreementFactory {
    func makeServiceTermAgreementViewController() -> UIViewController {
        return ServiceTermAgreementViewController(repository: DefaultUserRepository(userService: DefaultUserService(),
                                                                                    blocksService: DefaultBlocksService()))
    }
}
