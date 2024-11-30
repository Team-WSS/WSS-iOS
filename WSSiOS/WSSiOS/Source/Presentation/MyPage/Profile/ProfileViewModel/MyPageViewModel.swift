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
    
    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()
    var height: Double = 0.0
    let bindKeywordRelay = BehaviorRelay<[Keyword]>(value: [])
    let userId = BehaviorRelay<Int>(value: 0)
    
    let dummyNovelPreferenceData = UserNovelPreferences(
        attractivePoints: ["character", "material", "worldview"],
        keywords: [
            Keyword(keywordName: "서양풍/중세시대", keywordCount: 4),
            Keyword(keywordName: "학원/아카데미", keywordCount: 3),
            Keyword(keywordName: "SF", keywordCount: 3),
            Keyword(keywordName: "동양풍/사극", keywordCount: 1),
            Keyword(keywordName: "실존역사", keywordCount: 1)
        ]
    )
    
    // MARK: - Life Cycle
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    struct Input {
        let isMyPage: Driver<Bool>
        let headerViewHeight: Driver<Double>
        let scrollOffset: Driver<CGPoint>
        let settingButtonDidTap: ControlEvent<Void>
        let dropdownButtonDidTap: Observable<String>
        let editButtonTapoed: ControlEvent<Void>
        let genrePreferenceButtonDidTap: Observable<Bool>
        let libraryButtonDidTap: Observable<Bool>
        let feedButtonDidTap: Observable<Bool>
        
        let inventoryButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let IsExistPreference = PublishRelay<Bool>()
        let userData = BehaviorRelay<UserInfoResult>(value: UserInfoResult(nickname: "", gender: "", birth: 0, genrePreferences: []))
        let profileData = BehaviorRelay<MyProfileResult>(value: MyProfileResult(nickname: "",
                                                                                intro: "",
                                                                                avatarImage: "",
                                                                                genrePreferences: []))
        let settingButtonEnabled = PublishRelay<Void>()
        let dropdownButtonEnabled = PublishRelay<String>()
        let updateNavigationEnabled = BehaviorRelay<Bool>(value: false)
        let pushToEditViewController = PublishRelay<MyProfileResult>()
        let bindattractivePointsData = BehaviorRelay<[String]>(value: [])
        let bindKeywordCell = BehaviorRelay<[Keyword]>(value: [])
        let bindGenreData = BehaviorRelay<UserGenrePreferences>(value: UserGenrePreferences(genrePreferences: []))
        let bindInventoryData = BehaviorRelay<UserNovelStatus>(value: UserNovelStatus(interestNovelCount: 0, watchingNovelCount: 0, watchedNovelCount: 0, quitNovelCount: 0))
        let showGenreOtherView = BehaviorRelay<Bool>(value: false)
        let stickyHeaderAction = BehaviorRelay<Bool>(value: true)
        
        let pushToLibraryViewController = PublishRelay<Void>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.isMyPage
            .asObservable()
            .flatMapLatest { [unowned self] isMyPage in
                self.getProfileData(isMyPage: isMyPage)
            }
            .bind(to: output.profileData)
            .disposed(by: disposeBag)
        
        Observable.just(())
            .flatMapLatest { _ in
                self.getUserMeData()
            }
            .subscribe(with: self, onNext: { owner, data in
                owner.userId.accept(data.userId)
            }, onError: { owner, error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        Observable.just(())
            .flatMapLatest { _ in
                self.getNovelPreferenceData(userId: self.userId.value)
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
                self.getGenrePreferenceData(userId: self.userId.value)
            }
            .subscribe(with: self, onNext: { owner, data in
                output.bindGenreData.accept(data)
            }, onError: { owner, error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        Observable.just(())
            .flatMapLatest { _ in
                self.getInventoryData(userId: self.userId.value)
            }
            .subscribe(with: self, onNext: { owner, data in
                output.bindInventoryData.accept(data)
            }, onError: { owner, error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
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
        
        input.settingButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                output.settingButtonEnabled.accept(())
            })
            .disposed(by: disposeBag)
        
        input.editButtonTapoed
            .bind(with: self, onNext: { owner, _ in
                output.pushToEditViewController.accept(output.profileData.value)
            })
            .disposed(by: disposeBag)
        
        input.dropdownButtonDidTap
            .bind(with: self, onNext: { owner, data in
                if data == "수정하기" {
                    output.dropdownButtonEnabled.accept(data)
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
        
        input.libraryButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                output.pushToLibraryViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    // MARK: - Custom Method
    
    // MARK: - API
    
    private func getProfileData(isMyPage: Bool) -> Observable<MyProfileResult> {
        if isMyPage {
            return userRepository.getMyProfileData()
                .observe(on: MainScheduler.instance)
        } else {
            return userRepository.getMyProfileData()
                .observe(on: MainScheduler.instance)
        }
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
    
    private func getUserMeData() -> Observable<UserMeResult> {
        return userRepository.getUserMeData()
            .asObservable()
    }
}
