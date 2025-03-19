//
//  MyPageProfileHeaderViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 3/19/25.
//

import UIKit

import RxSwift
import RxCocoa

protocol MyPageProfileHeaderViewModelDelegate: AnyObject {
    func bindProfileId(profileId: Int)
    func transform(from input: MyPageProfileHeaderViewModel.Input, disposeBag: DisposeBag) -> MyPageProfileHeaderViewModel.Output
}

final class MyPageProfileHeaderViewModel: ViewModelType, MyPageProfileHeaderViewModelDelegate {
    
    // MARK: - Properties
    
    private let userBlockRepository: UserBlockRepository
    private let disposeBag = DisposeBag()
    
    private let profileId = BehaviorRelay<Int>(value: 0)
    private let profileData = BehaviorRelay<MyProfileEntity>(value: MyProfileEntity(nickname: "",
                                                                                    intro: "",
                                                                                    avatarImage: "",
                                                                                    genrePreferences: []))
    private let isProfilePrivate = BehaviorRelay<Bool>(value: false)
    private let isMyPage = BehaviorRelay<Bool>(value: true)
    private var stickyHeaderHeight: CGFloat = 0
    private let stickyHeaderAction = BehaviorRelay<Bool>(value: true)
    private let updateStickyHeader = BehaviorRelay<(Bool)>(value: (false))
    private let updateNavigation = BehaviorRelay<(Bool, String)>(value: (false, ""))
    private let updateButtonWithLibraryView = BehaviorRelay<Bool>(value: true)
    private let pushToEditViewController = PublishRelay<MyProfileEntity>()
    private let pushToSettingViewController = PublishRelay<Void>()
    private let pushToLibraryViewController = PublishRelay<Int>()
    private let popViewController = PublishRelay<Void>()
    
    // MARK: - Life Cycle
    
    init(userBlockRepository: UserBlockRepository) {
        self.userBlockRepository = userBlockRepository
    }
    
    struct Input {
        let profileData: Observable<MyProfileEntity>
        let isProfilePrivate: Observable<Bool>
        let isMyPage: Observable<Bool>
        let headerViewHeight: Driver<Double>
        let scrollOffset: Driver<CGPoint>
        let libraryButtonDidTap: Observable<Bool>
        let feedButtonDidTap: Observable<Bool>
        let settingButtonDidTap: ControlEvent<Void>
        let dropdownButtonDidTap: Observable<String>
        let editButtonDidTap: ControlEvent<Void>
        let backButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let updateNavigationBar: BehaviorRelay<(Bool, String)>
        let updateStickyHeader: BehaviorRelay<(Bool)>
        let pushToEditViewController: PublishRelay<MyProfileEntity>
        let pushToSettingViewController: PublishRelay<Void>
        let popViewController: PublishRelay<Void>
        let stickyHeaderAction: BehaviorRelay<Bool>
        let updateButtonWithLibraryView: BehaviorRelay<Bool>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.profileData
            .bind(to: self.profileData)
            .disposed(by: disposeBag)
        
        input.isProfilePrivate
            .bind(to: self.isProfilePrivate)
            .disposed(by: disposeBag)
        
        input.isMyPage
            .bind(to: self.isMyPage)
            .disposed(by: disposeBag)
        
        input.headerViewHeight
            .asObservable()
            .bind(with: self, onNext: { owner, height in
                owner.stickyHeaderHeight = height
            })
            .disposed(by: disposeBag)
        
        input.scrollOffset
            .asObservable()
            .map{ $0.y }
            .subscribe(with: self, onNext: { owner, scrollHeight in
                let navigationText = owner.isMyPage.value ? StringLiterals.Navigation.Title.myPage : owner.profileData.value.nickname
                owner.updateNavigation.accept((scrollHeight > 0, navigationText))
                owner.updateStickyHeader.accept(scrollHeight > owner.stickyHeaderHeight)
            })
            .disposed(by: disposeBag)
        
        input.libraryButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.stickyHeaderAction.accept(true)
                owner.updateButtonWithLibraryView.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.feedButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.stickyHeaderAction.accept(false)
                owner.updateButtonWithLibraryView.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.settingButtonDidTap
            .bind(to: pushToSettingViewController)
            .disposed(by: disposeBag)
        
        input.dropdownButtonDidTap
            .filter { $0 == StringLiterals.MyPage.BlockUser.toastText }
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self else { return .empty() }
                return self.postBlockUser(userId: self.profileId.value)
            }
            .subscribe(with: self, onNext: { owner, _ in
                AmplitudeManager.shared.track(AmplitudeEvent.MyPage.otherBlock)
                let nickname = owner.profileData.value.nickname
                NotificationCenter.default.post(name: NSNotification.Name("BlockUser"), object: nickname)
                owner.popViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.editButtonDidTap
            .map { self.profileData.value }
            .bind(to: pushToEditViewController)
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .bind(to: popViewController)
            .disposed(by: disposeBag)
        
        return Output(updateNavigationBar: self.updateNavigation,
                      updateStickyHeader: self.updateStickyHeader,
                      pushToEditViewController: self.pushToEditViewController,
                      pushToSettingViewController: self.pushToSettingViewController,
                      popViewController: self.popViewController,
                      stickyHeaderAction: self.stickyHeaderAction,
                      updateButtonWithLibraryView: self.updateButtonWithLibraryView)
    }
    
    // MARK: - Bind Data
    
    func bindProfileId(profileId: Int) {
        self.profileId.accept(profileId)
    }
    
    // MARK: - API
    
    private func postBlockUser(userId: Int) -> Observable<Void> {
        return userBlockRepository.postBlockUser(userId: userId)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
    }
}
