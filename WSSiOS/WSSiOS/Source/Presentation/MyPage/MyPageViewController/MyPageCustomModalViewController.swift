//
//  MyPageCustomModalViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/13/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class MyPageCustomModalViewController: UIViewController {
    
    //MARK: - Properties
    
    private let avatarRepository: AvatarRepository
    private let avatarId: Int
    private let modalHasAvatar: Bool
    private let currentRepresentativeAvatar: Bool
    private let viewModel: MyPageCustomModalViewModel
    private let viewWillAppearEvent = BehaviorRelay(value: false)
    private let viewWillDisappearEvent = BehaviorRelay(value: false)
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private var rootView = MyPageCustomModalView()
    private let modalBackgroundView = UIView()
    
    // MARK: - Life Cycle
    
    init(avatarRepository: AvatarRepository,
         avatarId: Int,
         modalHasAvatar: Bool,
         currentRepresentativeAvatar: Bool,
         viewModel: MyPageCustomModalViewModel) {
        
        self.avatarRepository = avatarRepository
        self.avatarId = avatarId
        self.modalHasAvatar = modalHasAvatar
        self.currentRepresentativeAvatar = currentRepresentativeAvatar
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        bindAvatarData()
        bindViewModel()
        modalDismiss()
        bindViewModel()
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
        avatarRepository.getAvatarData(avatarId: avatarId)
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (owner, data) in
                owner.rootView.bindData(id: owner.avatarId,
                                        data: data)
            })
            .disposed(by: disposeBag)
    }
    
    private func patchAvatar() {
        avatarRepository.patchAvatar(avatarId: avatarId)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(with: self, onNext: { owner, _ in 
                NotificationCenter.default.post(name: NSNotification.Name("AvatarChanged"), 
                                                object: nil)
                owner.dismiss(animated: true)
            },onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    
    private func bindViewModel() {
        let input = MyPageCustomModalViewModel.Input(
            viewWillAppear: viewWillAppearEvent.asDriver(),
            viewWillDisappear: viewWillDisappearEvent.asDriver(),
            continueButtonDidTap: rootView.modalContinueButton.rx.tap,
            changeButtonDidTap: rootView.modalChangeButton.rx.tap
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.viewWillAppearAction
            .bind(with: self, onNext: { owner, isAble in
                UIView.animate(withDuration: 0.3, delay: 0.3) {
                    owner.modalBackgroundView.alpha = 1
                }
            })
        
        output.viewWillDisappearAction
            .bind(with: self, onNext: { owner, isAble in
                owner.modalBackgroundView.alpha = 0
            })
        
        output.continueButtonAction
            .subscribe(with: self, onNext: { owner, isAble in
                if isAble {
                    owner.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        output.changeButtonAction
            .subscribe(with: self, onNext: { owner, isAble in
                if isAble {
                    if !owner.modalHasAvatar || owner.currentRepresentativeAvatar {
                        owner.dismiss(animated: true)
                    }
                    else {
                        owner.patchAvatar()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

extension MyPageCustomModalViewController {
    
    //MARK: - UI
    
    private func setUI() {
        self.modalBackgroundView.alpha = 0
        self.modalBackgroundView.backgroundColor = .wssBlack60.withAlphaComponent(0.6)
        
        if !modalHasAvatar || currentRepresentativeAvatar {
            rootView.modalContinueButton.isHidden = true
            rootView.modalChangeButton.setTitle(StringLiterals.MyPage.Modal.back, for: .normal)
        }
    }
    
    private func setHierarchy() {
        self.view.addSubviews(modalBackgroundView, 
                              rootView)
    }
    
    private func setLayout() {
        if !modalHasAvatar || currentRepresentativeAvatar {
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

extension MyPageCustomModalViewController {
    
    //MARK: - Modal Gesture
    
    func modalDismiss() {
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(modalDownGesture)))
        self.modalBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backGroundTapGesture)))
    }
    
    @objc
    private func modalDownGesture(_ sender: UIPanGestureRecognizer) {
        let viewTranslation = sender.translation(in: view)
        let viewVelocity = sender.velocity(in: view)
        
        switch sender.state {
        case .changed:
            if abs(viewVelocity.y) > abs(viewVelocity.x) {
                if viewVelocity.y > 0 {
                    modalBackgroundView.alpha = 0
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
                modalBackgroundView.alpha = 0
                dismiss(animated: true)
            }
        default:
            break
        }
    }
    
    @objc
    private func backGroundTapGesture(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
}
