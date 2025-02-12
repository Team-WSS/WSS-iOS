//
//  TermsAgreementViewController.swift
//  WSSiOS
//
//  Created by YunhakLee on 2/11/25.
//

import UIKit

import RxSwift
import RxCocoa

final class ServiceTermAgreementViewController: UIViewController {
    
    //MARK: - Properties
    
    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()
    
    private let agreedTerms = BehaviorRelay<Set<ServiceTerm>>(value: [])
    private let dismissModal = PublishRelay<Void>()
    
    //MARK: - Components
    
    private let rootView = ServiceTermAgreementView()
    
    //MARK: - Life Cycle
    
    init(repository: UserRepository) {
        self.userRepository = repository
        
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
        bindOutput()
    }
    
    //MARK: - Bind
    
    func bindAction() {
        rootView.allAgreeButton.rx.tap
            .withLatestFrom(agreedTerms)
            .bind(with: self, onNext: { owner, currentAgreedTerms in
                let isAllAgreed = (currentAgreedTerms.count == ServiceTerm.allCases.count)
                owner.agreedTerms.accept(isAllAgreed ? [] : Set(ServiceTerm.allCases))
            })
            .disposed(by: disposeBag)
        
        Observable.merge(
            rootView.serviceTermRowViews.map { view in
                view.termAgreeButton.rx.tap.map { view.serviceTerm }
            }
        )
        .bind(with: self, onNext: { owner, value in
            var currentAgreedTerms = owner.agreedTerms.value
            
            if currentAgreedTerms.contains(value) {
                currentAgreedTerms.remove(value)
            } else {
                currentAgreedTerms.insert(value)
            }
            
            owner.agreedTerms.accept(currentAgreedTerms)
        })
        .disposed(by: disposeBag)
        
        Observable.merge(
            rootView.serviceTermRowViews.map { view in
                view.termLabelButton.rx.tap.map { _ in view.serviceTerm }
            }
        )
        .observe(on: MainScheduler.instance)
        .bind(with: self, onNext: { owner, value in
            if let urlString = value.connectedURLString, let url = URL(string: urlString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        })
        .disposed(by: disposeBag)
        
        rootView.bottomButton.rx.tap
            .do(onNext: {
                print("약관 동의 작업 완료!")
            })
            .bind(with: self, onNext: { owner, _ in
                owner.patchTermSetting(disposeBag: owner.disposeBag)
            })
            .disposed(by: disposeBag)
    }
    
    func bindOutput() {
        agreedTerms
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, currentAgreedTerms in
                owner.rootView.serviceTermRowViews.forEach {
                    let isAgreed = currentAgreedTerms.contains($0.serviceTerm)
                    $0.updateAgreeButton(isAgreed: isAgreed)
                }
                
                let isAllAgreed = (currentAgreedTerms.count == ServiceTerm.allCases.count)
                owner.rootView.updateAllAgreeButton(isAllAgreed: isAllAgreed)
                
                let requiredTermsAllAgreed = currentAgreedTerms.filter({ $0.isRequired }).count == ServiceTerm.allCases.filter({ $0.isRequired }).count
                owner.rootView.updateBottomButton(isEnabled: requiredTermsAllAgreed)
            })
            .disposed(by: disposeBag)
        
        dismissModal
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.dismissModalViewController()
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - API
    
    private func patchTermSetting(disposeBag: DisposeBag) {
        let agreedTermBools: [Bool] = ServiceTerm.allCases.map { self.agreedTerms.value.contains($0) }
        
        userRepository.patchTermSetting(serviceAgreed: agreedTermBools[0],
                                        privacyAgreed: agreedTermBools[1],
                                        marketingAgreed: agreedTermBools[2])
        .do(onSuccess: { _ in
            print("약관 동의 패치 성공")
        }, onError: { error in
            print("약관 동의 패치 실패")
        })
        .subscribe(with: self, onSuccess: { owner, _ in
            owner.dismissModal.accept(())
        }, onFailure: { owner, error in
            print(error)
        })
        .disposed(by: disposeBag)
    }
}
