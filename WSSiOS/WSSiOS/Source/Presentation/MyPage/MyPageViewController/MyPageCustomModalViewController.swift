//
//  MyPageCustomModalViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/13/24.
//

import UIKit

import RxSwift
import RxCocoa

final class MyPageCustomModalViewController: UIViewController {
    
    //MARK: - Set Properties
    
    private let disposeBag = DisposeBag()
    private let avatarRepository: DefaultAvatarRepository
    private let avatarId: Int
    private let modalHasAvatar: Bool
    private let modalBackgroundView = UIView()
    
    init(avatarRepository: DefaultAvatarRepository,
         avatarId: Int,
         modalHasAvatar: Bool) {
        self.avatarRepository = avatarRepository
        self.avatarId = avatarId
        self.modalHasAvatar = modalHasAvatar
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Components
    
    private var rootView = MyPageCustomModalView()
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setBackgroundDimmed()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setStyle()
        setHierachy()
        setLayout()
        print("🙏🏿", avatarId)
        bindAvatarData()
        setAction()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.setBackgroundClear()
    }
    
    //MARK: - Custom Method
    
    private func setBackgroundDimmed() {
        UIView.animate(withDuration: 0.3, delay: 0.3) {
            self.modalBackgroundView.alpha = 1
        }
    }
    
    private func setBackgroundClear() {
        self.modalBackgroundView.alpha = 0
    }
    
    private func setStyle() {
        self.modalBackgroundView.alpha = 0
        self.modalBackgroundView.backgroundColor = .Black60.withAlphaComponent(0.6)
    }
    
    private func setUI() {
        if !modalHasAvatar {
            rootView.modalContinueButton.isHidden = true
            rootView.modalChangeButton.setTitle("돌아가기", for: .normal)
        }
    }
    
    private func setHierachy() {
        self.view.addSubviews(modalBackgroundView, 
                              rootView)
    }
    
    private func setLayout() {
        if !modalHasAvatar {
            rootView.snp.makeConstraints() {
                $0.bottom.width.equalToSuperview()
                $0.height.equalTo(533)
            }
        }
        else {
            rootView.snp.makeConstraints() {
                $0.bottom.width.equalToSuperview()
                $0.height.equalTo(572)
            }
        }
        
        modalBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setAction() {
        rootView.modalContinueButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.modalChangeButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                if !owner.modalHasAvatar {
                    owner.dismiss(animated: true)
                }
                else {
                    owner.patchAvatar()
                }
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Bind Data
    
    private func bindAvatarData() {
        avatarRepository.getAvatarData(avatarId: avatarId)
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (owner, data) in
                print(data)
                owner.rootView.bindData(data)
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
}
