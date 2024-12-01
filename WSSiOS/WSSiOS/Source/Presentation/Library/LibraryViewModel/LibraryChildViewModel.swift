//
//  LibraryChildViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 12/1/24.
//

import Foundation

import RxSwift
import RxCocoa

protocol NovelDelegate: AnyObject {
    func sendNovelCount(data: Int)
}

final class LibraryChildViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let userRepository: UserRepository
    private let initData: ShowNovelStatus
    private let userId: Int
    weak var delegate: NovelDelegate?
    
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Life Cycle
    
    init(userRepository: UserRepository, initData: ShowNovelStatus, userId: Int) {
        self.userRepository = userRepository
        self.initData = initData
        self.userId = userId
    }
    
    struct Input {
        let updateNovelList: PublishRelay<ShowNovelStatus>
        let lookForNovelButtonDidTap: ControlEvent<Void>
        let cellItemSeleted: ControlEvent<IndexPath>
    }
    
    struct Output {
        let cellData = BehaviorRelay<[UserNovel]>(value: [])
        let countNovel = BehaviorRelay<Int>(value: 0)
        let showEmptyView = PublishRelay<Bool>()
        let pushToDetailNovelViewController = BehaviorRelay<Int>(value: 0)
        let pushToSearchViewController = PublishRelay<Void>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        Observable.merge(
            Observable.just(initData),
            input.updateNovelList.asObservable()
        )
        .flatMapLatest { [weak self] status -> Observable<UserNovelList> in
            guard let self = self else { return Observable.empty() }
            return self.getUserNovelList(userId: self.userId, data: status)
        }
        .observe(on: MainScheduler.instance)
        .subscribe(with: self, onNext: { owner, data in
            output.cellData.accept(data.userNovels)
            output.showEmptyView.accept(data.userNovels.isEmpty)
            if data.userNovelCount > 0 {
                NotificationCenter.default.post(name: NSNotification.Name("NovelCount"),object: data.userNovelCount)
            }
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

    // MARK: - API
    
    private func getUserNovelList(userId: Int, data: ShowNovelStatus) -> Observable<UserNovelList> {
        return userRepository.getUserNovelList(userId: userId,
                                               readStatus: data.readStatus, lastUserNovelId: data.lastUserNovelId, size: data.size, sortType: data.sortType)
        .asObservable()
    }
}
