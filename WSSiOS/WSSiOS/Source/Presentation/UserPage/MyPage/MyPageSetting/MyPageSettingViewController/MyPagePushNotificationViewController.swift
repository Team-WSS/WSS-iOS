//
//  MyPagePushNotificationViewController.swift
//  WSSiOS
//
//  Created by YunhakLee on 1/22/25.
//

import UIKit

import RxSwift
import RxCocoa

final class MyPagePushNotificationViewController: UIViewController {
    
    //MARK: - Properties
    
    private let notificationRepository: NotificationRepository
    private let disposeBag = DisposeBag()
    private let activePushIsEnabled = BehaviorRelay<Bool>(value: true)
    
    //MARK: - Components
    
    private let rootView = MyPagePushNotificationView()
    
    // MARK: - Life Cycle
    
    init(notificationRepository: NotificationRepository) {
        self.notificationRepository = notificationRepository
        
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
        
        bindViewModelAction()
    }
    
    //MARK: - Bind
    
    private func bindViewModelAction() {
        getUserPushNotificationSetting()
        hideTabBar()
        swipeBackGesture()
        setWSSNavigationBar(title: StringLiterals.Navigation.Title.pushNotification,
                            left: self.rootView.backButton,
                            right: nil)
    }
    
    private func bindAction() {
        rootView.backButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: {owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        rootView.activePushSettingSection.rx.tap
            .withLatestFrom(activePushIsEnabled)
            .bind(with: self, onNext: { owner, isEnalbed in
                owner.postUserPushNotificationSetting(isPushEnabled: !isEnalbed)
            })
            .disposed(by: disposeBag)
        
        activePushIsEnabled
            .bind(with: self, onNext: { owner, isEnabled in
                owner.rootView.bindData(isEnabled: isEnabled)
            })
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - API
    
    func getUserPushNotificationSetting() {
        notificationRepository.getUserPushNotificationSetting()
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onSuccess: { owner, data in
                owner.activePushIsEnabled.accept(data.isPushEnabled)
            }, onFailure: { onwer, error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    func postUserPushNotificationSetting(isPushEnabled: Bool) {
        notificationRepository.postUserPushNotificationSetting(isPushEnabled: isPushEnabled)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onSuccess: { owner, _ in
                owner.activePushIsEnabled.accept(isPushEnabled)
            })
            .disposed(by: disposeBag)
    }
}
