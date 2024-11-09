//
//  LoginViewModel.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/17/24.
//

import AuthenticationServices
import UIKit

import RxSwift
import RxCocoa
import Then

final class LoginViewModel: NSObject, ViewModelType {
    
    //MARK: - Properties
    
    private let authRepository: AuthRepository
    
    private let bannerImages = BehaviorRelay<[UIImage]>(
        value: [UIImage(resource: .imgLoginBanner4),
                UIImage(resource: .imgLoginBanner1),
                UIImage(resource: .imgLoginBanner2),
                UIImage(resource: .imgLoginBanner3),
                UIImage(resource: .imgLoginBanner4),
                UIImage(resource: .imgLoginBanner1)])
    
    private let indicatorIndex = BehaviorRelay<Int>(value: 0)
    private let autoScrollTrigger = PublishRelay<Void>()
    private var autoScrollDisposable: Disposable?
    
    private let navigateToHome = PublishRelay<Void>()
    private let navigateToOnboarding = PublishRelay<Void>()
    
    private let loginWithApple = PublishRelay<(userIdentifier: String,
                                               email: String?)>()
    
    //MARK: - Life Cycle
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    //MARK: - Transform
    
    struct Input {
        let bannerCollectionViewContentOffset: ControlProperty<CGPoint>
        let loginButtonDidTap: Observable<LoginButtonType>
    }
    
    struct Output {
        let bannerImages: Driver<[UIImage]>
        let indicatorIndex: Driver<Int>
        let autoScrollTrigger: Driver<Void>
        let navigateToOnboarding: Observable<Void>
        let navigateToHome: Observable<Void>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.bannerCollectionViewContentOffset
            .bind(with: self, onNext: { owner, value in
                let scrollOffset = value.x
                
                //0.0 - 0.5 -> 3
                //0.5 - 1.5 -> 0
                //1.5 - 2.5 -> 1
                //2.5 - 3.5 -> 2
                //3.5 - 4.5 -> 3
                //4.5 - 5.0 -> 0 대로 index가 잡혀야 해서, 이를 계산하는 과정.
                
                var index = Int((scrollOffset + LoginBannerMetric.width/2.0)/LoginBannerMetric.width) - 1
                
                if index == 4 {
                    index = 0
                } else if index == -1 {
                    index = 3
                }
                
                owner.indicatorIndex.accept(index)
            })
            .disposed(by: disposeBag)
        
        let autoScrollTrigger = self.autoScrollTrigger
            .asDriver(onErrorJustReturn: ())
        
        input.loginButtonDidTap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, type in
                switch type {
                case .skip:
                    owner.navigateToHome.accept(())
                case .kakao:
                    owner.navigateToOnboarding.accept(())
                case .naver:
                    owner.navigateToOnboarding.accept(())
                case .apple:
                    owner.requestAppleLogin() // 애플로그인 요청
                }
            })
            .disposed(by: disposeBag)
        
        // 애플로그인 후 userIdentifier와 email을 받아와서 로그인 요청
        loginWithApple
            .flatMapLatest { userIdentifier, email in
                self.loginWithApple(userIdentifier: userIdentifier,
                                    email: email)
            }
            .subscribe(with: self, onNext: { owner, result in
                UserDefaults.standard.setValue(result.Authorization,
                                               forKey: StringLiterals.UserDefault.accessToken)
                UserDefaults.standard.setValue(result.refreshToken,
                                               forKey:  StringLiterals.UserDefault.refreshToken)
                if result.isRegister {
                    owner.navigateToHome.accept(())
                } else {
                    owner.navigateToOnboarding.accept(())
                }
            }, onError: { owner, error  in
                print(error)
            })
            .disposed(by: disposeBag)
        
        return Output(
            bannerImages: bannerImages.asDriver(),
            indicatorIndex: indicatorIndex.asDriver(),
            autoScrollTrigger: autoScrollTrigger,
            navigateToOnboarding: navigateToOnboarding.asObservable(),
            navigateToHome: navigateToHome.asObservable()
        )
    }
    
    //MARK: - Custom Method
    
    func pauseAutoScroll() {
        autoScrollDisposable?.dispose()
    }
    
    func resumeAutoScroll() {
        autoScrollDisposable?.dispose()
        autoScrollDisposable = Observable<Int>.interval(.milliseconds(2000), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                owner.autoScrollTrigger.accept(())
            })
    }
    
    private func repositoryLoginMethod(type: LoginButtonType) -> Observable<LoginButtonType> {
        // 레포지토리에 구현할 각 로그인 메서드. 아마 ..?
        print("\(String(describing: type)) Login 성공")
        if type == .skip {
            APIConstants.isLogined = false
        } else {
            APIConstants.isLogined = true
        }
        return Observable.just(type)
    }
    
    private func requestAppleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    //MARK: - API
    
    private func loginWithApple(userIdentifier: String, email: String?) -> Observable<LoginResult> {
        authRepository.loginWithApple(userIdentifier: userIdentifier, email: email)
            .observe(on: MainScheduler.instance)
    }
}

extension LoginViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        
        loginWithApple.accept((userIdentifier: credential.user,
                               email: credential.email))
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        print("error \(error)")
    }
}
