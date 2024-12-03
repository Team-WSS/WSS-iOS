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
    
    private let novelDataRelay = BehaviorRelay<[UserNovel]>(value: [])
    private let isLoadableRelay = BehaviorRelay<Bool>(value: true)
    private let lastNovelIdRelay = BehaviorRelay<Int>(value: 0)
    private let showLoadingViewRelay = BehaviorRelay<Bool>(value: false)
    private var isFetching = false
    
    private let countNovel = BehaviorRelay<Int>(value: 0)
    private let showEmptyView = PublishRelay<Bool>()
    private let pushToDetailNovelViewController = BehaviorRelay<Int>(value: 0)
    private let pushToSearchViewController = PublishRelay<Void>()
    private let sendNovelTotalCountRelay = PublishRelay<Int>()
    
    // MARK: - Life Cycle
    
    init(userRepository: UserRepository, initData: ShowNovelStatus, userId: Int) {
        self.userRepository = userRepository
        self.initData = initData
        self.userId = userId
    }
    
    struct Input {
        let lookForNovelButtonDidTap: ControlEvent<Void>
        let cellItemSeleted: ControlEvent<IndexPath>
        let loadNextPageTrigger: Observable<Void>
    }
    
    struct Output {
        let cellData: BehaviorRelay<[UserNovel]>
        let countNovel: BehaviorRelay<Int>
        let showEmptyView: PublishRelay<Bool>
        let pushToDetailNovelViewController: BehaviorRelay<Int>
        let pushToSearchViewController: PublishRelay<Void>
        let sendNovelTotalCount: PublishRelay<Int>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.lookForNovelButtonDidTap
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                self.pushToSearchViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.loadNextPageTrigger
            .filter { [unowned self] _ in !self.isFetching && self.isLoadableRelay.value }
            .do(onNext: { [unowned self] _ in self.isFetching = true })
            .flatMapLatest { [unowned self] _ in
                self.getUserNovelList(userId: self.userId,
                                      data: self.initData)
            }
            .subscribe(with: self, onNext: { owner, novelResult in
                owner.updateNovelList(novelResult)
            }, onError: { owner, error in
                owner.isFetching = false
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        Observable.just(())
            .flatMapLatest{  [weak self] _ -> Observable<UserNovelList> in
                guard let self = self else { return Observable.empty() }
                return self.getUserNovelList(userId: self.userId,
                                      data: self.initData)
            }.subscribe(with: self, onNext: { owner, novelData in
                self.sendNovelTotalCountRelay.accept(Int(novelData.userNovelCount))
            }, onError: { owner, error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
//        input.cellItemSeleted
            
        
        return Output(cellData: self.novelDataRelay,
                      countNovel: self.countNovel,
                      showEmptyView: self.showEmptyView,
                      pushToDetailNovelViewController: self.pushToDetailNovelViewController,
                      pushToSearchViewController: self.pushToSearchViewController,
                      sendNovelTotalCount: self.sendNovelTotalCountRelay)
    }
    
    private func updateNovelList(_ novelResult: UserNovelList) {
        let newNovelData = novelResult.userNovels
        if let lastNovel = novelResult.userNovels.last {
            self.lastNovelIdRelay.accept(Int(lastNovel.userNovelId))
        }
        
        self.novelDataRelay.accept(self.novelDataRelay.value + newNovelData)
        self.isLoadableRelay.accept(novelResult.isLoadable)
        self.isFetching = false
        
        self.showEmptyView.accept(novelDataRelay.value.isEmpty)
    }
    
    // MARK: - API
    
    private func getUserNovelList(userId: Int, data: ShowNovelStatus) -> Observable<UserNovelList> {
        return userRepository.getUserNovelList(userId: userId,
                                               readStatus: data.readStatus,
                                               lastUserNovelId: data.lastUserNovelId,
                                               size: data.size,
                                               sortType: data.sortType)
        .asObservable()
    }
}
