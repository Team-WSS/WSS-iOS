//
//  MyPageProfileVisibilityViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 9/18/24.
//

import UIKit

import RxSwift
import RxCocoa

final class MyPageProfileVisibilityViewController: UIViewController {
    
    //MARK: - Properties
    
    private let userInfoRepository: UserInfoRepository
    private let disposeBag = DisposeBag()
    
    private var initStatus: Bool = true
    private var isStatusRelay = BehaviorRelay<Bool>(value: true)
    
    //MARK: - Components
    
    private let rootView = MyPageProfileVisibilityView()
    
    // MARK: - Life Cycle
    
    init(userInfoRepository: UserInfoRepository) {
        self.userInfoRepository = userInfoRepository
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bindViewWillAppearAction()
    }
    
    //MARK: - Bind
    
    private func bindViewWillAppearAction() {
        hideTabBar()
        swipeBackGesture()
        
        setWSSNavigationBar(title: StringLiterals.Navigation.Title.isVisibleProfile,
                            left: self.rootView.backButton,
                            right: self.rootView.completeButton)
    }
    
    private func bindAction() {
        self.getUserProfileVisibility()
            .map { $0.isProfilePublic }
            .bind(with: self, onNext: { owner, isPublic in
                owner.initStatus = isPublic
                owner.isStatusRelay.accept(isPublic)
            })
            .disposed(by: disposeBag)
        
        self.isStatusRelay
            .bind(with: self, onNext: { owner, status in
                owner.rootView.bindData(isPrivate: !status)
                owner.rootView.changeCompleteButton(change: owner.initStatus != status)
            })
            .disposed(by: disposeBag)
        
        rootView.profilePrivateToggleButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                let currentValue = owner.isStatusRelay.value
                owner.isStatusRelay.accept(!currentValue)
            })
            .disposed(by: disposeBag)
        
        rootView.backButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        rootView.completeButton.rx.tap
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.patchUserProfileVisibility(isProfilePublic: UserProfileVisibilityRequest(isProfilePublic: owner.isStatusRelay.value))
                    .catch { error in
                        return Observable.empty()
                    }
            }
            .bind(with: self, onNext: { owner, _ in
                NotificationCenter.default.post(name: NSNotification.Name("ChangeVisibility"), object: owner.isStatusRelay.value)
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - API
    
    private func getUserProfileVisibility() -> Observable<UserProfileVisibilityResponse> {
        return userInfoRepository.getUserProfileVisibility()
            .observe(on: MainScheduler.instance)
    }
    
    private func patchUserProfileVisibility(isProfilePublic: UserProfileVisibilityRequest) -> Observable<Void> {
        return userInfoRepository.patchUserProfileVisibility(isProfilePublic: isProfilePublic)
            .observe(on: MainScheduler.instance)
    }
}
