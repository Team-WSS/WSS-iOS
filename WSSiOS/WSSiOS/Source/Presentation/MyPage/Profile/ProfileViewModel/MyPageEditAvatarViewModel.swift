//
//   MyPageEditAvatarViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 11/25/24.
//

import UIKit

import RxSwift
import RxCocoa

final class MyPageEditAvatarViewModel: ViewModelType {

    //MARK: - Properties
    
    private let avatarRepository: AvatarRepository
    private var totalAvatarData: [Avatar] = []
    private let lastTappedAvatar = BehaviorRelay<Int>(value: 0)
    private var isTappedAvatar = false
    
    //MARK: - Life Cycle
    
    init(avatarRepository: AvatarRepository) {
        
        self.avatarRepository = avatarRepository
    }
    
    struct Input {
        let avatarCellDidTap: ControlEvent<IndexPath>
        let changeButtonDidTap: ControlEvent<Void>
        let continueButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let bindAvatarCell = BehaviorRelay<[Avatar]>(value: [Avatar(avatarId: 0,
                                                                 avatarName: "",
                                                                 avatarLine: "",
                                                                 avatarImage: "",
                                                                 isRepresentative: true)])
        let updateAvatarData = PublishRelay<Avatar>()
        let dismissModalViewController = PublishRelay<Void>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        Observable.just(())
            .flatMapLatest { _ in
                self.getAvatarList()
            }
            .subscribe(with: self, onNext: { owner, avatarList in
                owner.totalAvatarData = avatarList.avatars
                output.bindAvatarCell.accept(avatarList.avatars)
            }, onError: { owner, error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        input.avatarCellDidTap
            .subscribe(with: self, onNext: { owner, indexPath in
                output.updateAvatarData.accept(owner.totalAvatarData[indexPath.row])
                owner.isTappedAvatar = true
                owner.lastTappedAvatar.accept(indexPath.row)
            })
            .disposed(by: disposeBag)
        
        input.changeButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                if owner.isTappedAvatar {
                    NotificationCenter.default.post(name: NSNotification.Name("ChangRepresentativeAvatar"), object: owner.lastTappedAvatar.value)
                }
                output.dismissModalViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.continueButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                output.dismissModalViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    //MARK: - API
    
    private func getAvatarList() -> Observable<AvatarResponse> {
        return avatarRepository.getAvatarList()
            .asObservable()
    }
}
