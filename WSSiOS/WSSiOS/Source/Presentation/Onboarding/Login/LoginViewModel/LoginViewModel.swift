//
//  LoginViewModel.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/17/24.
//

import UIKit

import RxSwift
import RxCocoa
import Then

final class LoginViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let bannerImages = BehaviorRelay<[UIImage]>(value: [UIImage(resource: .imgLoginBanner4),
                                                                UIImage(resource: .imgLoginBanner1),
                                                                UIImage(resource: .imgLoginBanner2),
                                                                UIImage(resource: .imgLoginBanner3),
                                                                UIImage(resource: .imgLoginBanner4),
                                                                UIImage(resource: .imgLoginBanner1)])

    
    //MARK: - Life Cycle
    
    //    init(detailRepository: NovelDetailRepository, novelId: Int = 0) {
    //        self.novelDetailRepository = detailRepository
    //        self.novelId = novelId
    //    }
    
    //MARK: - Transform
    
    struct Input {
        
    }
    
    struct Output {
        let bannerImages: Driver<[UIImage]>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        return Output(
            bannerImages: bannerImages.asDriver()
        )
    }
}
