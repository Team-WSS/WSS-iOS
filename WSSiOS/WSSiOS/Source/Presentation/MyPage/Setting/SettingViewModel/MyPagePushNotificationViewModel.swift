//
//  MyPagePushNotificationViewModel.swift
//  WSSiOS
//
//  Created by YunhakLee on 1/22/25.
//

import UIKit

import RxSwift
import RxCocoa

final class MyPagePushNotificationViewModel: ViewModelType {

    //MARK: - Properties
    
    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()
    
    //MARK: - Life Cycle
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    struct Input {
       
    }
    
    struct Output {

    }
    
    func transform(from input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
        
        return Output()
    }
}
