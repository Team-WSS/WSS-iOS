//
//  MyPageChangeUserInfoViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 9/20/24.
//

import UIKit

import RxSwift
import RxCocoa

enum Gender {
    static let male = "M"
    static let female = "F"
}

final class MyPageChangeUserInfoViewController: UIViewController {
    
    //MARK: - Properties
    
    private let userRepository: UserInfoRepository
    private let disposeBag = DisposeBag()
    
    private let gender = UserDefaults.standard.string(forKey: StringLiterals.UserDefault.userGender) ?? ""
    private let birth = UserDefaults.standard.integer(forKey: StringLiterals.UserDefault.userBirth)
    
    private var currentGender = BehaviorRelay<String>(value: "")
    private var currentBirth = BehaviorRelay<Int>(value: 0)
    private var isEnabledCompleteButton = BehaviorRelay<Bool>(value: false)
    
    //MARK: - Components
    
    private let rootView = MyPageChangeUserInfoView()
    
    // MARK: - Life Cycle
    
    init(userRepository: UserInfoRepository) {
        self.userRepository = userRepository
        
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
        super.viewWillAppear(true)
        
        bindViewWillAppearAction()
    }
    
    //MARK: - Bind
    
    private func bindViewWillAppearAction() {
        hideTabBar()
        swipeBackGesture()
        setWSSNavigationBar(title: StringLiterals.Navigation.Title.myPageChangeUserInfo,
                         left: self.rootView.backButton,
                         right: self.rootView.completeButton)
    }
    
    private func bindAction() {
        currentGender.accept(gender)
        currentBirth.accept(birth)
        
        Observable.merge(
            rootView.genderMaleButton.rx.tap.map { Gender.male },
            rootView.genderFemaleButton.rx.tap.map { Gender.female }
        )
        .bind(with: self, onNext: { owner, gender in
            owner.currentGender.accept(gender)
        })
        .disposed(by: disposeBag)
        
        rootView.birthButtonView.rx.tapGesture()
            .when(.recognized)
            .subscribe(with: self, onNext: { owner, _ in
                owner.presentModalViewController(MyPageChangeUserBirthViewController(userBirth: owner.currentBirth.value))
            })
            .disposed(by: disposeBag)
        
        rootView.backButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        rootView.completeButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .flatMapLatest { owner, _ -> Observable<Void> in
                guard owner.isEnabledCompleteButton.value else { return .empty() }
                let userData = ChangeUserInfoEntity(gender: owner.currentGender.value, birth: owner.currentBirth.value)
                return owner.putUserInfo(userData: userData)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                UserDefaults.standard.removeObject(forKey: StringLiterals.UserDefault.userGender)
                UserDefaults.standard.removeObject(forKey: StringLiterals.UserDefault.userBirth)
                
                UserDefaults.standard.set(owner.currentGender.value, forKey: StringLiterals.UserDefault.userGender)
                UserDefaults.standard.set(owner.currentBirth.value, forKey: StringLiterals.UserDefault.userBirth)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    NotificationCenter.default.post(name: NSNotification.Name("ChangeUserInfo"), object: nil)
                }
                
                owner.popToLastViewController()
            }, onError: { owner, error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NSNotification.Name("UserBirth"))
            .compactMap { notification -> Int? in
                return notification.userInfo?["userBirth"] as? Int
            }
            .bind(with: self, onNext: { owner, userBirth in
                owner.currentBirth.accept(userBirth)
                owner.isEnabledCompleteButton.accept(owner.checkIsEnabledCompleteButton())
            })
            .disposed(by: disposeBag)
        
        currentGender
            .bind(with: self, onNext: { owner, gender in
                owner.rootView.changeGenderButton(gender: gender)
                owner.isEnabledCompleteButton.accept(owner.checkIsEnabledCompleteButton())
            })
            .disposed(by: disposeBag)
        
        currentBirth
            .bind(with: self, onNext: { owner, birth in
                owner.rootView.changeBirthYearLabel(year: birth)
                owner.isEnabledCompleteButton.accept(owner.checkIsEnabledCompleteButton())
            })
            .disposed(by: disposeBag)
        
        isEnabledCompleteButton
            .bind(with: self, onNext: { owner, isEnabled in
                owner.rootView.isEnabledCompleteButton(isEnabled: isEnabled)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - API
    
    private func putUserInfo(userData: ChangeUserInfoEntity) -> Observable<Void> {
        return userRepository.putUserInfo(userData: userData)
            .observe(on: MainScheduler.instance)
    }
    
    //MARK: - Custom Method
    
    private func checkIsEnabledCompleteButton() -> Bool {
        let isEnabled = self.gender != currentGender.value || self.birth != currentBirth.value
        return isEnabled
    }
}
