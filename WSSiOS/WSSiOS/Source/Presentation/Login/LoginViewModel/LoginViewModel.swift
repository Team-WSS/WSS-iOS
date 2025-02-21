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
import KakaoSDKUser
import RxKakaoSDKUser

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
    
    private let loginWithApple = PublishRelay<(authorizationCode: String,
                                               idToken: String)>()
    
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
                    AmplitudeManager.shared.track(AmplitudeEvent.Onboarding.nonLogin)
                    owner.navigateToHome.accept(())
                case .kakao:
                    owner.loginWithKakao(disposeBag: disposeBag)
                case .apple:
                    owner.requestAppleLogin() // 애플로그인 요청
                }
            })
            .disposed(by: disposeBag)
        
        // 애플로그인 후 authorizationCode와 idToken을 받아와서 로그인 요청
        loginWithApple
            .flatMapLatest { authorizationCode, idToken in
                self.loginWithApple(authorizationCode: authorizationCode,
                                    idToken: idToken)
            }
            .subscribe(with: self, onNext: { owner, result in
                owner.loginSuccess(result: result)
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
    
    private func loginSuccess(result: LoginResponse) {
        UserDefaults.standard.setValue(result.Authorization,
                                       forKey: StringLiterals.UserDefault.accessToken)
        UserDefaults.standard.setValue(result.refreshToken,
                                       forKey:  StringLiterals.UserDefault.refreshToken)
        UserDefaults.standard.setValue(result.isRegister,
                                       forKey: StringLiterals.UserDefault.isRegister)
        NotificationHelper.shared.fetchFCMToken()
        if APIConstants.isRegister {
            self.navigateToHome.accept(())
        } else {
            self.navigateToOnboarding.accept(())
        }
    }
    
    //MARK: - API/Apple
    
    private func loginWithApple(authorizationCode: String, idToken: String) -> Observable<LoginResponse> {
        authRepository.loginWithApple(authorizationCode: authorizationCode, idToken: idToken)
            .observe(on: MainScheduler.instance)
    }
    
    private func requestAppleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    //MARK: - API/Kakao
    
    private func loginWithKakao(disposeBag: DisposeBag) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            loginWithKakaoTalk(disposeBag: disposeBag)
        } else {
            loginWithKakaoAccount(disposeBag: disposeBag)
        }
    }
    
    private func loginWithKakaoTalk(disposeBag: DisposeBag) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.rx.loginWithKakaoTalk()
                .flatMapLatest{ oauthToken in
                    return self.authRepository.loginWithKakao(oauthToken)
                }
                .do(onNext: { _ in
                    print("LoginWithKakao Success.")
                })
                .subscribe(with: self, onNext: { owner, result in
                    owner.loginSuccess(result: result)
                }, onError: { owner, error in
                    print(error)
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func loginWithKakaoAccount(disposeBag: DisposeBag) {
        UserApi.shared.rx.loginWithKakaoAccount()
            .flatMapLatest{ oauthToken in
                return self.authRepository.loginWithKakao(oauthToken)
            }
            .do(onNext: { _ in
                print("LoginWithKakao Success.")
            })
            .subscribe(with: self, onNext: { owner, result in
                owner.loginSuccess(result: result)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
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
        
        loginWithApple.accept((authorizationCode: String(data: credential.authorizationCode!, encoding: String.Encoding.utf8)!,
                               idToken: String(data: credential.identityToken!, encoding: String.Encoding.utf8)!))
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        print("error \(error)")
    }
}
