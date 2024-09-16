//
//  LoginViewModel.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/17/24.
//

import Foundation

import RxSwift
import RxCocoa
import Then

final class LoginViewModel: ViewModelType {
    
    //MARK: - Properties
    
    //MARK: - Life Cycle
    
    //    init(detailRepository: NovelDetailRepository, novelId: Int = 0) {
    //        self.novelDetailRepository = detailRepository
    //        self.novelId = novelId
    //    }
    
    //MARK: - Transform
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        return Output()
    }
}
