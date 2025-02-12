//
//  TermsAgreementViewController.swift
//  WSSiOS
//
//  Created by YunhakLee on 2/11/25.
//

import UIKit

import RxSwift
import RxCocoa

class TermsAgreementViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    private let agreedTerms = BehaviorRelay<Set<ServiceTerm>>(value: [])
    
    //MARK: - Components
    
    private let rootView = ServiceTermAgreementView()
    
    // MARK: - Life Cycle
    
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
        
        rootView.bottomButton.rx.tap
            .do(onNext: {
                print("약관 동의 작업 완료!")
            })
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.dismissModalViewController()
            })
            .disposed(by: disposeBag)
    }
    
    func bindOutput() {
        agreedTerms.asDriver()
            .drive(with: self, onNext: { owner, currentAgreedTerms in
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
    }
}
