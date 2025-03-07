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
    
    private var currentGender = ""
    private var currentBirth = 0
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
        currentGender = Gender.male
        currentBirth = birth

        rootView.genderMaleButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.currentGender = Gender.male
                owner.rootView.changeGenderButton(gender: owner.currentGender)
                owner.isEnabledCompleteButton.accept(owner.checkIsEnabledCompleteButton())
            })
            .disposed(by: disposeBag)
        
        rootView.genderFemaleButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.currentGender = Gender.female
                owner.rootView.changeGenderButton(gender: owner.currentGender)
                owner.isEnabledCompleteButton.accept(owner.checkIsEnabledCompleteButton())
            })
            .disposed(by: disposeBag)
        
        rootView.birthButtonView.rx.tapGesture()
            .subscribe(with: self, onNext: { owner, _ in
                owner.presentModalViewController(MyPageChangeUserBirthViewController(userBirth: owner.birth))
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
                let userData = ChangeUserInfoEntity(gender: owner.currentGender, birth: owner.currentBirth)
                return owner.putUserInfo(userData: userData)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                UserDefaults.standard.removeObject(forKey: StringLiterals.UserDefault.userGender)
                UserDefaults.standard.removeObject(forKey: StringLiterals.UserDefault.userBirth)
                
                UserDefaults.standard.set(owner.currentGender, forKey: StringLiterals.UserDefault.userGender)
                UserDefaults.standard.set(owner.currentBirth, forKey: StringLiterals.UserDefault.userBirth)
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
                owner.currentBirth = userBirth
                owner.isEnabledCompleteButton.accept(owner.checkIsEnabledCompleteButton())
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
        return self.gender != currentGender || self.birth != currentBirth
    }
}
