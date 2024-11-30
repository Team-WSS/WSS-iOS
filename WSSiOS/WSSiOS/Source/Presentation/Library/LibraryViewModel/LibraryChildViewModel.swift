//
//  LibraryChildViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 12/1/24.
//

import Foundation

import RxSwift
import RxCocoa

final class LibraryChildViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let userNovelListRepository: UserNovelRepository
    private let initData: ShowNovelStatus
    
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Life Cycle
    
    init(userNovelListRepository: UserNovelRepository, initData: ShowNovelStatus) {
        self.userNovelListRepository = userNovelListRepository
        self.initData = initData
    }
    
    struct Input {
        let updateNovelList: PublishRelay<ShowNovelStatus>
        let lookForNovelButtonDidTap: ControlEvent<Void>
        let cellItemSeleted: ControlEvent<IndexPath>
    }
    
    struct Output {
        let cellData = BehaviorRelay<[UserNovelListDetail]>(value: [])
        let showEmptyView = PublishRelay<Bool>()
        let pushToDetailNovelViewController = BehaviorRelay<Int>(value: 0)
        let pushToSearchViewController = PublishRelay<Void>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.updateNovelList
            .flatMapLatest { [weak self] status -> Observable<UserNovelList> in
                guard let self = self else { return Observable.empty() }
                return self.getUserNovelList(data: status)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in
                output.cellData.accept(data.userNovels)
                output.showEmptyView.accept(data.userNovels.isEmpty)
            }, onError: { error, _ in
                print(error)
            })
            .disposed(by: disposeBag)
        
        input.lookForNovelButtonDidTap
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                output.pushToSearchViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        
        
        
        return output
    }
    
    // MARK: - Custom Method
    
    // MARK: - API
    
    private func getUserNovelList(data: ShowNovelStatus) -> Observable<UserNovelList> {
        return userNovelListRepository.getUserNovelList(readStatus: data.readStatus, lastUserNovelId: data.lastUserNovelId, size: data.size, sortType: data.sortType)
            .asObservable()
    }
}

