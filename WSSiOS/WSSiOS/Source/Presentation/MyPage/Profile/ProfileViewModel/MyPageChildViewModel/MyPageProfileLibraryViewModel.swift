//
//  MyPageProfileLibraryViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 3/19/25.
//

import UIKit

import RxSwift
import RxCocoa

protocol MyPageProfileLibraryViewModelDelegate: AnyObject {
    func bindProfileId(profileId: Int)
    func transform(from input: MyPageProfileLibraryViewModel.Input, disposeBag: DisposeBag) -> MyPageProfileLibraryViewModel.Output
}

final class MyPageProfileLibraryViewModel: ViewModelType, MyPageProfileLibraryViewModelDelegate {
    
    // MARK: - Properties
    
    private let userInfoRepository: UserInfoRepository
    private var profileId = BehaviorRelay<Int>(value: 0)
    private let disposeBag = DisposeBag()
    
    private let isExistPrefernecesRelay = PublishRelay<Bool>()
    private let updateKeywordCollectionViewHeightRelay = PublishRelay<CGFloat>()
    private let bindInventoryDataRelay = BehaviorRelay<UserNovelStatusResponse>(value: UserNovelStatusResponse(interestNovelCount: 0,
                                                                                               watchingNovelCount: 0,
                                                                                               watchedNovelCount: 0,
                                                                                               quitNovelCount: 0))
    private let bindKeywordRelay = BehaviorRelay<[KeywordResponse]>(value: [])
    private let updateCellSize = BehaviorRelay<[CGSize]>(value: [])
    private let bindAttractivePointsDataRelay = BehaviorRelay<[String]>(value: [])
    private let bindGenreDataRelay = BehaviorRelay<UserGenrePreferenceListEntity>(value: UserGenrePreferenceListEntity(genrePreferences: []))
    private let showGenreOtherViewRelay = BehaviorRelay<Bool>(value: false)
    private let pushToLibraryViewController = PublishSubject<Int>()
    private let pushToSpecificLibraryViewController = PublishSubject<(Int,Int)>()
    
    // MARK: - Life Cycle
    
    init(userInfoRepository: UserInfoRepository) {
        self.userInfoRepository = userInfoRepository
    }
    
    struct Input {
        let viewWillAppearEvent: PublishSubject<Void>
        let resizeKeywordCollectionViewHeight: Observable<CGSize?>
        let genrePreferenceButtonDidTap: Observable<Bool>
        let inventoryViewDidTap: Observable<UITapGestureRecognizer>
        let inventorySpecificPageViewDidTap: Observable<Int>
    }
    
    struct Output {
        let bindAttractivePointsData: BehaviorRelay<[String]>
        let bindKeywordCell: BehaviorRelay<[KeywordResponse]>
        let updateKeywordCollectionViewHeight: PublishRelay<CGFloat>
        let bindGenreData: BehaviorRelay<UserGenrePreferenceListEntity>
        let bindInventoryData: BehaviorRelay<UserNovelStatusResponse>
        let showGenreOtherView: BehaviorRelay<Bool>
        let isExistPreferneces: PublishRelay<Bool>
        let pushToLibraryViewController: PublishSubject<Int>
        let pushToSpecificLibraryViewController: PublishSubject<(Int, Int)>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewWillAppearEvent
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self else { return .empty() }
                return self.updateMyPageLibraryInventoryData()
                    .concat(self.updateMyPageLibraryPreferenceData())
                    .concatMap { [weak self] _ -> Observable<Void> in
                        guard let self else { return .empty() }
                        return self.handleKeywordCollectionViewHeight(resizeKeywordCollectionViewHeight: input.resizeKeywordCollectionViewHeight)
                            .map { _ in Void() }
                    }
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        input.genrePreferenceButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                let currentState = owner.showGenreOtherViewRelay.value
                owner.showGenreOtherViewRelay.accept(!currentState)
            })
            .disposed(by: disposeBag)
        
        input.inventoryViewDidTap
            .bind(with: self, onNext: { owner, _ in
                self.pushToLibraryViewController.onNext(owner.profileId.value)
            })
            .disposed(by: disposeBag)
        
        input.inventorySpecificPageViewDidTap
            .bind(with: self, onNext: { owner, pageIndex in
                self.pushToSpecificLibraryViewController.onNext((owner.profileId.value, pageIndex))
            })
            .disposed(by: disposeBag)
        
        return Output(bindAttractivePointsData: self.bindAttractivePointsDataRelay,
                      bindKeywordCell: self.bindKeywordRelay,
                      updateKeywordCollectionViewHeight: self.updateKeywordCollectionViewHeightRelay,
                      bindGenreData: self.bindGenreDataRelay,
                      bindInventoryData: self.bindInventoryDataRelay,
                      showGenreOtherView: self.showGenreOtherViewRelay,
                      isExistPreferneces: self.isExistPrefernecesRelay,
                      pushToLibraryViewController: self.pushToLibraryViewController,
                      pushToSpecificLibraryViewController: pushToSpecificLibraryViewController)
    }
    
    // MARK: - Bind Data
    
    func bindProfileId(profileId: Int) {
        self.profileId.accept(profileId)
    }
    
    // MARK: - Custom Method
    
    //서재 데이터 바인딩
    //보관함-장르취향-작품취향 서버연결
    private func updateMyPageLibraryInventoryData() -> Observable<Void> {
        return getInventoryData(userId: self.profileId.value)
            .do(onNext: { [weak self] inventory in
                guard let self else { return }
                self.bindInventoryDataRelay.accept(inventory)
            })
            .map { _ in Void() }
    }
    
    //취향분석 데이터 바인딩
    private func updateMyPageLibraryPreferenceData() -> Observable<Void> {
        return getNovelPreferenceData(userId: self.profileId.value)
            .flatMap { [weak self] preference -> Observable<Bool> in
                guard let self else { return .just(false) }
                
                //작품취향 분기처리
                //1. 매력포인트, 키워드 둘 다 있을 때
                //2. 매력포인트만 있을 때
                //3. 키워드만 있을 때
                // => 각각의 뷰만 뜨게 함
                
                //4. 둘 다 없을 때
                //=> emptyView 처리
                //=> 이 경우 장르 취향도 데이터가 없기 때문에 false 반환
                let keywords = preference.keywords ?? []
                if preference.attractivePoints == [] && keywords.isEmpty {
                    self.isExistPrefernecesRelay.accept(false)
                    return .just(false)
                } else {
                    self.bindAttractivePointsDataRelay.accept(preference.attractivePoints ?? [])
                    self.bindKeywordRelay.accept(keywords)
                    return .just(true)
                }
            }
        
        //회원가입후 처음 접속시 서버연결 에러가 나서 분기처리가 제대로 안된 에러 발생
        //=> 해결 위하여 서버연결 실패시 emptyView 처리
            .catch { [weak self] error in
                self?.isExistPrefernecesRelay.accept(false)
                return .just(false)
            }
        
        // 장르 취향
            .flatMap { [weak self] isExist -> Observable<Void> in
                guard let self else { return .empty() }
                if isExist {
                    return self.getGenrePreferenceData(userId: self.profileId.value)
                        .do(onNext: { data in
                            if !data.genrePreferences.isEmpty {
                                self.bindGenreDataRelay.accept(data)
                            }
                        })
                        .map { _ in Void() }
                } else {
                    return .just(Void())
                }
            }
    }
    
    private func handleKeywordCollectionViewHeight(resizeKeywordCollectionViewHeight: Observable<CGSize?>) -> Observable<CGFloat> {
        return resizeKeywordCollectionViewHeight
            .map { $0?.height ?? 0 }
            .do(onNext: { [weak self] height in
                self?.updateKeywordCollectionViewHeightRelay.accept(height)
            })
    }
    
    // MARK: - API
    
    private func getNovelPreferenceData(userId: Int) -> Observable<UserNovelPreferenceEntity> {
        return userInfoRepository.getUserNovelPreferences(userId: userId)
    }
    
    private func getGenrePreferenceData(userId: Int) -> Observable<UserGenrePreferenceListEntity> {
        return userInfoRepository.getUserGenrePreferences(userId: userId)
    }
    
    private func getInventoryData(userId: Int) -> Observable<UserNovelStatusResponse> {
        return userInfoRepository.getUserNovelStatus(userId: userId)
    }
}
