//
//  MyLibraryViewModel.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/25/24.
//

import UIKit

import RxSwift
import RxCocoa
import Then

final class MyLibraryViewModel: ViewModelType {
    
    /// 목록 요청 하나를 만드는 데 필요한 상태 묶음
    private struct NovelListState {
        let filterOption: LibraryFilterOption
        let sortType: LibrarySortType
        let cursor: String?
        let loadedCount: Int
        let isLoadable: Bool
    }
    
    /// 서재 목록을 불러오는 세 가지 방식.
    ///
    /// - `reload`: 필터·정렬이 바뀌어 목록을 처음부터 다시 그린다.
    /// - `nextPage`: 커서로 다음 페이지를 받아 기존 목록 뒤에 이어 붙인다.
    /// - `refresh`: 화면에 다시 들어왔을 때 지금까지 보던 만큼을 한 번에 다시 받아 덮어쓴다.
    private enum NovelListRequest {
        case reload
        case nextPage
        case refresh
        
        /// 한 번에 요청할 작품 수
        static let pageSize = 12
        
        /// 다음 페이지는 이어받을 커서가 있고 더 받을 것이 남았을 때만 의미가 있다
        func canStart(with state: NovelListState) -> Bool {
            guard self == .nextPage else { return true }
            return state.isLoadable && state.cursor != nil
        }
        
        /// 이어 붙이는 요청만 커서를 쓰고, 나머지는 처음부터 다시 받는다
        func cursor(from state: NovelListState) -> String? {
            self == .nextPage ? state.cursor : nil
        }
        
        /// 새로고침은 보던 위치를 유지해야 하므로 지금까지 로드한 만큼을 한 번에 받는다
        func size(from state: NovelListState) -> Int {
            guard self == .refresh, state.loadedCount > 0 else { return Self.pageSize }
            return state.loadedCount + Self.pageSize
        }
        
        /// 목록을 비우고 다시 그리는 요청만 전체 로딩 뷰를 띄운다
        var showsLoadingView: Bool { self == .reload }
        
        /// 다음 페이지 요청만 기존 목록 뒤에 이어 붙인다
        var appendsToCurrentList: Bool { self == .nextPage }
    }
    
    /// 어떤 요청의 응답인지 알아야 목록을 이어 붙일지 덮어쓸지 정할 수 있다
    private typealias NovelListResponse = (request: NovelListRequest, entity: MyLibraryEntity)
    
    //MARK: - Properties
    
    let myLibraryRepository: MyLibraryRepository
    
    //Rx
    let filterOption = BehaviorRelay<LibraryFilterOption>(value: LibraryFilterOption())
    let sortType = BehaviorRelay<LibrarySortType>(value: .createdDesc)
    private let layoutType = BehaviorRelay<LayoutType>(value: .grid)
    private let novelCount = BehaviorRelay<Int>(value: 0)
    
    private let libraryNovelList = BehaviorRelay<[MyLibraryNovel]>(value: [])
    private let cursor = BehaviorRelay<String?>(value: nil)
    private let isLoadable = BehaviorRelay<Bool>(value: true)
    private let fetchNovelList = PublishRelay<Void>()
    private let reloadNovelList = PublishRelay<Void>()
    private let refreshNovelList = PublishRelay<Void>()
    
    private let isLibraryEmpty = BehaviorRelay<Bool>(value: false)
    private let showLibraryEmptyView = BehaviorRelay<Bool>(value: false)
    private let showFilterResultEmptyView = BehaviorRelay<Bool>(value: false)
    private let pushToNovelDetailViewController = PublishRelay<Int>()
    private let showLoadingView = BehaviorRelay<Bool>(value: false)
    private let showNetworkErrorView = BehaviorRelay<Bool>(value: false)
    
    /// 요청 직전에 한 번에 읽어 가도록 상태를 묶어 둔다
    private var novelListState: Observable<NovelListState> {
        Observable.combineLatest(filterOption, sortType, cursor, libraryNovelList, isLoadable) {
            NovelListState(filterOption: $0,
                           sortType: $1,
                           cursor: $2,
                           loadedCount: $3.count,
                           isLoadable: $4)
        }
    }
    
    
    //MARK: - Life Cycle
    
    init(myLibraryRepository: MyLibraryRepository) {
        self.myLibraryRepository = myLibraryRepository
    }
    
    //MARK: - Transform
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let interestFilterButtonDidTap: ControlEvent<Void>
        let sortTypeSelected: Observable<LibrarySortType>
        let layoutToggleButtonDidTap: ControlEvent<Void>
        let collectionViewDidReachBottom: Observable<Void>
        let tableViewDidReachBottom: Observable<Void>
        let novelItemSelected: Observable<IndexPath>
        let networkErrorRefreshButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let selectedFilterOption: Driver<LibraryFilterOption>
        let selectedSortType: Driver<LibrarySortType>
        let selectedLayoutType: Driver<LayoutType>
        let novelCount: Driver<Int>
        let libraryNovelList: Observable<[MyLibraryNovel]>
        let showLibraryEmptyView: Driver<Bool>
        let showFilterResultEmptyView: Driver<Bool>
        let pushToNovelDetailViewController: Observable<Int>
        let showLoadingView: Observable<Bool>
        let showNetworkErrorView: Observable<Bool>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewWillAppear
            .bind(with: self) { owner, _ in
                owner.applySavedOption()
            }
            .disposed(by: disposeBag)
        
        input.interestFilterButtonDidTap
            .withLatestFrom(filterOption)
            .map { option in
                var updated = option
                updated.interestedOption.toggle()
                return updated
            }
            .bind(to: filterOption)
            .disposed(by: disposeBag)
        
        filterOption
            .skip(1)
            .distinctUntilChanged()
            .bind(with: self) { owner, selectedOption in
                owner.saveFilterOption(selectedOption)
            }
            .disposed(by: disposeBag)
        
        sortType
            .skip(1)
            .distinctUntilChanged()
            .bind(with: self) { owner, selectedType in
                owner.saveSortType(selectedType)
            }
            .disposed(by: disposeBag)
        
        input.sortTypeSelected
            .bind(to: sortType)
            .disposed(by: disposeBag)
        
        input.layoutToggleButtonDidTap
            .withLatestFrom(layoutType)
            .map { $0.toggle() }
            .bind(to: layoutType)
            .disposed(by: disposeBag)
        
        // 구독하는 순간 초기 조합이 흘러 첫 로드가 일어난다. 이 최초 방출을 skip하면 목록이 비어 있게 된다.
        Observable.combineLatest(filterOption, sortType)
            .distinctUntilChanged { $0 == $1 }
            // 필터와 정렬을 잇달아 반영할 때 (새 필터, 옛 정렬) 같은 중간 조합으로 요청이 나가지 않도록,
            // 두 값이 모두 반영된 다음 사이클로 미룬다
            .observe(on: MainScheduler.asyncInstance)
            .map { _ in }
            .bind(to: reloadNovelList)
            .disposed(by: disposeBag)
        
        Observable.merge(
            input.collectionViewDidReachBottom,
            input.tableViewDidReachBottom
        )
        .bind(to: fetchNovelList)
        .disposed(by: disposeBag)
        
        input.networkErrorRefreshButtonDidTap
            .bind(to: reloadNovelList)
            .disposed(by: disposeBag)
        
        // 세 방식이 하나의 스트림으로 모인다.
        // flatMapLatest가 항상 마지막 요청만 살려 두므로, 앞선 요청의 응답이 뒤늦게 목록을 덮어쓰지 않는다.
        Observable.merge(
            reloadNovelList.map { NovelListRequest.reload },
            fetchNovelList.map { NovelListRequest.nextPage },
            refreshNovelList.map { NovelListRequest.refresh }
        )
        .observe(on: MainScheduler.instance)
        .withLatestFrom(novelListState) { (request: $0, state: $1) }
        .filter { $0.request.canStart(with: $0.state) }
        .do(onNext: { [weak self] request, _ in
            guard request == .reload else { return }
            self?.initializeLibraryState()
        })
        .flatMapLatest { [weak self] request, state -> Observable<NovelListResponse> in
            guard let self else { return .empty() }
            return self.requestNovelList(request, with: state)
        }
        .withLatestFrom(libraryNovelList) { response, currentList -> MyLibraryEntity in
            guard response.request.appendsToCurrentList else { return response.entity }
            
            var appendedEntity = response.entity
            appendedEntity.userNovels = currentList + response.entity.userNovels
            return appendedEntity
        }
        .bind(with: self) { owner, entity in
            owner.updateLibraryState(with: entity)
        }
        .disposed(by: disposeBag)
        
        input.novelItemSelected
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(libraryNovelList) { indexPath, novelList in
                novelList[indexPath.item].novelId
            }
            .bind(to: pushToNovelDetailViewController)
            .disposed(by: disposeBag)
        
        isLibraryEmpty
            .withLatestFrom(filterOption) { isEmpty, filterOption in
                return (isEmpty, filterOption != LibraryFilterOption())
            }
            .bind(with: self) { owner, data in
                let (isLibraryEmpty, isFilterResult) = data
                if isLibraryEmpty {
                    owner.showFilterResultEmptyView.accept(isFilterResult)
                    owner.showLibraryEmptyView.accept(!isFilterResult)
                } else {
                    owner.showFilterResultEmptyView.accept(false)
                    owner.showLibraryEmptyView.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            selectedFilterOption: filterOption.asDriver(),
            selectedSortType: sortType.asDriver(),
            selectedLayoutType: layoutType.asDriver(),
            novelCount: novelCount.asDriver(),
            libraryNovelList: libraryNovelList.asObservable(),
            showLibraryEmptyView: showLibraryEmptyView.asDriver(),
            showFilterResultEmptyView: showFilterResultEmptyView.asDriver(),
            pushToNovelDetailViewController: pushToNovelDetailViewController.asObservable(),
            showLoadingView: showLoadingView.asObservable(),
            showNetworkErrorView: showNetworkErrorView.asObservable()
        )
    }
    
    //MARK: - API
    
    /// 실패해도 스트림을 끊지 않고 에러 뷰만 띄운다
    private func requestNovelList(_ request: NovelListRequest,
                                  with state: NovelListState) -> Observable<NovelListResponse> {
        myLibraryRepository.getNovelList(
            filterOption: state.filterOption,
            cursor: request.cursor(from: state),
            size: request.size(from: state),
            sortType: state.sortType
        )
        .asObservable()
        .do(onSubscribe: { [weak self] in
            self?.updateRequestState(isStarting: true, isReloading: request.showsLoadingView)
        })
        .observe(on: MainScheduler.instance)
        .map { (request: request, entity: $0) }
        .do(onNext: { [weak self] _ in
            self?.updateRequestState(isStarting: false)
        })
        .catch { [weak self] error in
            self?.updateRequestState(isStarting: false, isError: true)
            print(error)
            return .empty()
        }
    }
    
    //MARK: - Custom Method
    
    /// 저장된 필터·정렬을 반영하고, 필요할 때만 새로고침을 요청한다.
    ///
    /// 반영 순서가 결과를 바꾸므로 한 곳에서 처리한다.
    private func applySavedOption() {
        let savedFilterOption = loadFilterOption()
        let savedSortType = loadSortType()
        let willReload = savedFilterOption != filterOption.value || savedSortType != sortType.value
        
        filterOption.accept(savedFilterOption)
        sortType.accept(savedSortType)
        
        // 필터·정렬이 달라졌다면 reload가 목록을 처음부터 다시 그리므로, 어차피 취소될 새로고침은 보내지 않는다
        guard !willReload else { return }
        refreshNovelList.accept(())
    }
    
    private func initializeLibraryState() {
        libraryNovelList.accept([])
        isLoadable.accept(true)
        novelCount.accept(0)
        cursor.accept(nil)
        isLibraryEmpty.accept(false)
    }
    
    private func updateLibraryState(with entity: MyLibraryEntity) {
        libraryNovelList.accept(entity.userNovels)
        isLoadable.accept(entity.isLoadable)
        novelCount.accept(entity.userNovelCount)
        cursor.accept(entity.nextCursor)
        isLibraryEmpty.accept(entity.userNovels.isEmpty)
    }
    
    private func updateRequestState(isStarting: Bool, isReloading: Bool = false, isError: Bool = false) {
        if isStarting {
            showNetworkErrorView.accept(false)
            showLoadingView.accept(isReloading)
        } else {
            showNetworkErrorView.accept(isError)
            showLoadingView.accept(false)
        }
    }
    
    private func saveFilterOption(_ filterOption: LibraryFilterOption) {
        if let encodedData = try? JSONEncoder().encode(filterOption) {
            UserDefaults.standard.set(encodedData,
                                      forKey: StringLiterals.UserDefault.libraryFilterOption)
        }
    }
    
    private func saveSortType(_ sortType: LibrarySortType) {
        UserDefaults.standard.set(sortType.text,
                                  forKey: StringLiterals.UserDefault.librarySortOption)
    }
    
    
    private func loadFilterOption() -> LibraryFilterOption {
        if let savedData = UserDefaults.standard.data(forKey: StringLiterals.UserDefault.libraryFilterOption),
           let loadedFilterOption = try? JSONDecoder().decode(LibraryFilterOption.self, from: savedData) {
            return loadedFilterOption
        } else { 
            return LibraryFilterOption()
        }
    }
    
    private func loadSortType() -> LibrarySortType {
        if let savedData = UserDefaults.standard.string(forKey: StringLiterals.UserDefault.librarySortOption),
           let sortType = LibrarySortType.fromText(savedData) {
            return sortType
        } else {
            return LibrarySortType.createdDesc
        }
    }
}
