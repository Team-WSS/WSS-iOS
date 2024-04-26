//
//  DetailViewModel.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/25/24.
//

import Foundation

import RxSwift
import RxCocoa
import Then

final class DetailViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let detailRepository: DetailRepository
    
    //MARK: - Life Cycle
    
    init(detailRepository: DetailRepository, novelId: Int = 0) {
        self.detailRepository = detailRepository
    }
    
    //MARK: - Transform
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        return Output()
    }
}
