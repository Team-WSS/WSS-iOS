//
//  MyPageCustomModalViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/13/24.
//

import UIKit

import RxCocoa
import RxSwift

class MyPageCustomModalViewController: UIViewController {
    
    //MARK: - Set Properties
    
    private let disposeBag = DisposeBag()
    private var avatarRepository: DefaultAvatarRepository
    private let avatarId: Int
    private let modalHasAvatar: Bool
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierachy()
        setLayout()
        
        bindAvatarData()
        setAction()
    }
    
    //MARK: - Custom Method
    
    private func setUI() {
        if !modalHasAvatar {
            rootView.modalContinueButton.isHidden = true
            rootView.modalChangeButton.setTitle("돌아가기", for: .normal)
        }
    }
    
    private func setHierachy() {
        self.view.addSubview(rootView)
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
    }
    
    private func setAction() {
        rootView.modalContinueButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                //                owner.myPageViewController.myPageViewModel.removeDimmedView.onNext(())
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
    
    private func bindAvatarData() {
        avatarRepository.getAvatarData(avatarId: avatarId)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in 
                print(data)
                owner.rootView.bindData(data)
            })
            .disposed(by: disposeBag)
    }
    
    private func patchAvatar() {
        avatarRepository.patchAvatar(avatarId: avatarId)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in 
                NotificationCenter.default.post(name: NSNotification.Name("AvatarChanged"), object: nil)
                owner.dismiss(animated: true)
            },onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}
