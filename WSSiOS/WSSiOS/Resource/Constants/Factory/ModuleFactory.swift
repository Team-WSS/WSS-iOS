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

final class ModuleFactory: RegisterModuleFactory {
    static let shared = ModuleFactory()
    private init() {}
    
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
