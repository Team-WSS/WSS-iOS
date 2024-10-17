//
//  ModuleFactory.swift
//  WSSiOS
//
//  Created by 이윤학 on 2/24/24.
//

import UIKit

protocol RegisterModuleFactory {
    func makeRegisterNormalViewController(novelId: Int) -> UIViewController
    func makeRegisterSuccessViewController(userNovelId: Int) -> UIViewController
}

protocol OnboardingModuleFactory {
    func makeLoginViewController() -> UIViewController
    func makeOnboardingViewController() -> UIViewController
    func makeOnboardingSuccessViewController(nickname: String) -> UIViewController
}

protocol NovelDetailModuleFactory {
    func makeNovelDetailViewController(novelId: Int) -> UIViewController
}

final class ModuleFactory {
    static let shared = ModuleFactory()
    private init() {}
}

extension ModuleFactory: RegisterModuleFactory {
    func makeRegisterNormalViewController(novelId: Int) -> UIViewController {
        return RegisterNormalViewController(viewModel: RegisterViewModel(
            novelRepository: DefaultNovelRepository(novelService: DefaultNovelService()),
            userNovelRepository: DefaultUserNovelRepository(userNovelService:DefaultUserNovelService()),
            novelId: novelId))
    }
    
    func makeRegisterSuccessViewController(userNovelId: Int) -> UIViewController {
        return RegisterSuccessViewController(userNovelId: userNovelId)
    }
}

extension ModuleFactory: NovelDetailModuleFactory {
    func makeNovelDetailViewController(novelId: Int) -> UIViewController {
        return NovelDetailViewController(
            viewModel: NovelDetailViewModel(
                novelDetailRepository: DefaultNovelDetailRepository(novelDetailService: DefaultNovelDetailService()),
                novelId: novelId))
    }
    
    func makeTestNovelDetailViewController(novelId: Int) -> UIViewController {
        return NovelDetailViewController(viewModel: NovelDetailViewModel(novelDetailRepository: TestNovelDetailRepository()))
    }
}

extension ModuleFactory: OnboardingModuleFactory {
    func makeLoginViewController() -> UIViewController {
        return LoginViewController(viewModel: LoginViewModel())
    }
    
    func makeOnboardingViewController() -> UIViewController {
        return OnboardingViewController(viewModel: OnboardingViewModel(onboardingRepository: DefaultOnboardingRepository(onboardingService: DefaultOnboardingService())))
    }
    
    func makeOnboardingSuccessViewController(nickname: String) -> UIViewController {
        return OnboardingSuccessViewController(nickname: nickname)
    }
}
