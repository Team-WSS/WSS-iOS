//
//  MyPageCustomModalViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/13/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture
import SnapKit

final class MyPageCustomModalViewController: UIViewController {
    
    //MARK: - Properties

    private var viewModel: MyPageCustomModalViewModel
    private let viewDidLoadEvent = BehaviorRelay(value: false)
    private let viewWillAppearEvent = BehaviorRelay(value: false)
    private let viewWillDisappearEvent = BehaviorRelay(value: false)
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private var rootView = MyPageCustomModalView()
    private let modalBackgroundView = UIView()
    
    // MARK: - Life Cycle
    
    init(viewModel: MyPageCustomModalViewModel) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bindAvatarData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDidLoadEvent.accept(true)
        bindViewModel()
        bindGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewWillAppearEvent.accept(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewWillDisappearEvent.accept(true)
    }
    
    //MARK: - Bind
    
    private func bindAvatarData() {
        viewModel.avatarData?
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, avatarResult in
                owner.rootView.bindData(id: owner.viewModel.avatarId,
                                        data: avatarResult)
            }, onError: { owner, error in
                print("Error fetching data: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        
        let input = MyPageCustomModalViewModel.Input(
            viewDidLoad: viewDidLoadEvent.asDriver(),
            viewWillAppear: viewWillAppearEvent.asDriver(),
            viewWillDisappear: viewWillDisappearEvent.asDriver(),
            continueButtonDidTap: rootView.modalContinueButton.rx.tap,
            changeButtonDidTap: rootView.modalChangeButton.rx.tap
                .flatMapLatest { _ in
                    return Observable.just(self.viewModel.avatarId)
                },
            backButtonDidTap: rootView.modalBackButton.rx.tap
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.viewDidLoadAction
            .bind(with: self, onNext: { owner, isRepresentative in
                owner.setUI(isRepresentative: isRepresentative)
                owner.setHierarchy()
                owner.setLayout(isRepresentative: isRepresentative)
            })
        
        output.viewWillAppearAction
            .bind(with: self, onNext: { owner, _ in
                UIView.animate(withDuration: 0.3, delay: 0.3) {
                    owner.modalBackgroundView.alpha = 1
                }
            })
        
        output.viewWillDisappearAction
            .bind(with: self, onNext: { owner, _ in
                owner.modalBackgroundView.alpha = 0
            })
        
        output.backAction
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension MyPageCustomModalViewController {
    
    //MARK: - UI
    
    private func setUI(isRepresentative: Bool) {
        self.modalBackgroundView.alpha = 0
        self.modalBackgroundView.backgroundColor = .wssBlack60.withAlphaComponent(0.6)
        
        if !isRepresentative {
            rootView.modalContinueButton.isHidden = true
            rootView.modalChangeButton.isHidden = true
            rootView.modalBackButton.isHidden = false
        }
    }
    
    private func setHierarchy() {
        self.view.addSubviews(modalBackgroundView, 
                              rootView)
    }
    
    private func setLayout(isRepresentative: Bool) {
        if !isRepresentative {
            rootView.snp.makeConstraints() {
                $0.bottom.width.equalToSuperview()
                $0.height.equalTo(533)
            }
        } else {
            rootView.snp.makeConstraints() {
                $0.bottom.width.equalToSuperview()
                $0.height.equalTo(572)
            }
        }
        
        modalBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

//MARK: - Modal Dismiss Gesture

extension MyPageCustomModalViewController {
    
    func bindGesture() {
        self.view.rx.panGesture()
            .withUnretained(self)
            .bind { view, gesture in
                let viewTranslation = gesture.translation(in: view.view)
                let viewVelocity = gesture.velocity(in: view.view)
                
                switch gesture.state {
                case .changed:
                    if abs(viewVelocity.y) > abs(viewVelocity.x) {
                        if viewVelocity.y > 0 {
                            self.modalBackgroundView.alpha = 0
                            UIView.animate(withDuration: 0.1, animations: {
                                self.view.transform = CGAffineTransform(translationX: 0, y: viewTranslation.y)
                            })
                        }
                    }
                case .ended:
                    if viewTranslation.y < 150 {
                        UIView.animate(withDuration: 0.1, animations: {
                            self.view.transform = .identity
                        })
                        UIView.animate(withDuration: 0.3, delay: 0.3) {
                            self.modalBackgroundView.alpha = 1
                        }
                    }
                    else {
                        self.modalBackgroundView.alpha = 0
                        self.dismiss(animated: true)
                    }
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        self.modalBackgroundView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { view, _ in
                view.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
