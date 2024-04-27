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
    
    private let detailRepository: DummyDetailRepository
    private let novelId: Int
    
    private let viewWillAppearEvent = BehaviorRelay(value: false)
    private let detailBasicData = PublishSubject<DetailBasicResult>()
    
    //MARK: - Life Cycle
    
    init(detailRepository: DummyDetailRepository, novelId: Int = 0) {
        self.detailRepository = detailRepository
        self.novelId = novelId
    }
    
    //MARK: - Transform
    
    struct Input {
        let viewWillAppearEvent: Observable<Bool>
    }
    
    struct Output {
        let detailBasicData: Observable<DetailBasicResult>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewWillAppearEvent
            .flatMapLatest { _ in
                self.detailRepository.getEstimatedNovelBasic(novelId: self.novelId)
            }
            .subscribe(with: self, onNext: { owner, data in
                owner.detailBasicData.onNext(data)
            }, onError: { owner, error in
                owner.detailBasicData.onError(error)
            })
            .disposed(by: disposeBag)
        

        return Output(detailBasicData: detailBasicData.asObservable())
    }
}
