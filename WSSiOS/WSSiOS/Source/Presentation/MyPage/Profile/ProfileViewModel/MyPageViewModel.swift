//
//  MyPageViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 7/9/24.
//

import Foundation

import RxSwift
import RxCocoa

final class MyPageViewModel: ViewModelType {
    
    // MARK: - Properties
    
    let profileId: Int
    
    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()
    var height: Double = 0.0
    let bindKeywordRelay = BehaviorRelay<[Keyword]>(value: [])
    let isMyPageRelay = PublishRelay<Bool>()
    
    // MARK: - Life Cycle
    
    init(userRepository: UserRepository, profileId: Int) {
        self.userRepository = userRepository
        if profileId == 0 {
            let userId = UserDefaults.standard.integer(forKey: StringLiterals.UserDefault.userId)
            self.profileId = userId
        } else {
            self.profileId = profileId
        }
        
    }
    
    struct Input {
        let isEntryTabbar: Observable<Bool>
        
        let headerViewHeight: Driver<Double>
        let scrollOffset: Driver<CGPoint>
        
        let settingButtonDidTap: ControlEvent<Void>
        let dropdownButtonDidTap: Observable<String>
        let editButtonDidTap: ControlEvent<Void>
        let backButtonDidTap: ControlEvent<Void>
        
        let genrePreferenceButtonDidTap: Observable<Bool>
        let libraryButtonDidTap: Observable<Bool>
        let feedButtonDidTap: Observable<Bool>
    }
    
    struct Output {
        let isMyPage = BehaviorRelay<Bool>(value: true)
        let IsExistPreference = PublishRelay<Bool>()
        let isProfilePublic = PublishRelay<Bool>()
        let profileData = BehaviorRelay<MyProfileResult>(value: MyProfileResult(nickname: "",
                                                                                intro: "",
                                                                                avatarImage: "",
                                                                                genrePreferences: []))
        
        let updateNavigationEnabled = BehaviorRelay<Bool>(value: false)
        let pushToEditViewController = PublishRelay<MyProfileResult>()
        let pushToSettingViewController = PublishRelay<Void>()
        let popViewController = PublishRelay<Void>()
        
        let bindattractivePointsData = BehaviorRelay<[String]>(value: [])
        let bindKeywordCell = BehaviorRelay<[Keyword]>(value: [])
        let bindGenreData = BehaviorRelay<UserGenrePreferences>(value: UserGenrePreferences(genrePreferences: []))
        let bindInventoryData = BehaviorRelay<UserNovelStatus>(value: UserNovelStatus(interestNovelCount: 0, watchingNovelCount: 0, watchedNovelCount: 0, quitNovelCount: 0))
        let showGenreOtherView = BehaviorRelay<Bool>(value: false)
        
        let stickyHeaderAction = BehaviorRelay<Bool>(value: true)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // 진입 경로 분기처리
        // 현재는 탭바로 진입할 때만 마이페이지!
        input.isEntryTabbar
            .subscribe(with: self, onNext: { owner, isMyPage in
                owner.isMyPageRelay.accept(isMyPage)
            })
            .disposed(by: disposeBag)
        
        // 마이페이지 분기 처리
        self.isMyPageRelay
            .asObservable()
            .flatMapLatest { [unowned self] isMyPage -> Observable<Void> in
                if isMyPage {
                    return self.getProfileData()
                        .do(onNext: { profileData in
                            output.profileData.accept(profileData)
                            output.isMyPage.accept(true)
                        })
                        .map { _ in }
                } else {
                    return self.getOtherProfileData(userId: self.profileId)
                        .do(onNext: { profileData in
                            let data = MyProfileResult(
                                nickname: profileData.nickname,
                                intro: profileData.intro,
                                avatarImage: profileData.avatarImage,
                                genrePreferences: profileData.genrePreferences
                            )
                            output.isProfilePublic.accept(profileData.isProfilePublic)
                            output.profileData.accept(data)
                            output.isMyPage.accept(false)
                        })
                        .map { _ in }
                }
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        // 마이페이지 정보 바인딩
        Observable.just(())
            .flatMapLatest { _ in
                self.getNovelPreferenceData(userId: self.profileId)
            }
            .subscribe(with: self, onNext: { owner, data in
                if data.attractivePoints == [] {
                    output.IsExistPreference.accept(false)
                } else {
                    output.IsExistPreference.accept(true)
                    output.bindattractivePointsData.accept(data.attractivePoints ?? [])
                    let keywords = data.keywords ?? []
                    output.bindKeywordCell.accept(keywords)
                    owner.bindKeywordRelay.accept(keywords)
                }
            }, onError: { owner, error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        Observable.just(())
            .flatMapLatest { _ in
                self.getGenrePreferenceData(userId: self.profileId)
            }
            .subscribe(with: self, onNext: { owner, data in
                output.bindGenreData.accept(data)
            }, onError: { owner, error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        Observable.just(())
            .flatMapLatest { _ in
                self.getInventoryData(userId: self.profileId)
            }
            .subscribe(with: self, onNext: { owner, data in
                output.bindInventoryData.accept(data)
            }, onError: { owner, error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // 레이아웃 조정
        input.headerViewHeight
            .asObservable()
            .bind(with: self, onNext: { owner, height in
                owner.height = height
            })
            .disposed(by: disposeBag)
        
        input.scrollOffset
            .asObservable()
            .map{ $0.y }
            .subscribe(with: self, onNext: { owner, scrollHeight in
                if (scrollHeight > owner.height) {
                    output.updateNavigationEnabled.accept(true)
                } else {
                    output.updateNavigationEnabled.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        
        input.genrePreferenceButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                let currentState = output.showGenreOtherView.value
                output.showGenreOtherView.accept(!(currentState))
            })
            .disposed(by: disposeBag)
        
        input.libraryButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                output.stickyHeaderAction.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.feedButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                output.stickyHeaderAction.accept(false)
            })
            .disposed(by: disposeBag)
        
        //VC 이동
        input.settingButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                output.pushToSettingViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.editButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                output.pushToEditViewController.accept(output.profileData.value)
            })
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                output.popViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    // MARK: - Custom Method
    
    // MARK: - API
    
    private func getProfileData() -> Observable<MyProfileResult> {
        return userRepository.getMyProfileData()
            .observe(on: MainScheduler.instance)
    }
    
    private func getOtherProfileData(userId: Int) -> Observable<OtherProfileResult> {
        return userRepository.getOtherProfile(userId: userId)
            .asObservable()
    }
    
    private func getNovelPreferenceData(userId: Int) -> Observable<UserNovelPreferences> {
        return userRepository.getUserNovelPreferences(userId: userId)
            .asObservable()
    }
    
    private func getGenrePreferenceData(userId: Int) -> Observable<UserGenrePreferences> {
        return userRepository.getUserGenrePreferences(userId: userId)
            .asObservable()
    }
    
    private func getInventoryData(userId: Int) -> Observable<UserNovelStatus> {
        return userRepository.getUserNovelStatus(userId: userId)
            .asObservable()
    }
}
