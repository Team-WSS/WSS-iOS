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
    
    let userNickname: String
    
    private let avatarRepository: AvatarRepository
    private var totalAvatarData: [Avatar] = []
    private let lastTappedAvatar = BehaviorRelay<Int>(value: 1)
    
    private var defaultAvatarId: Int = 1
    private var isTappedAvatar = false
    
    //MARK: - Life Cycle
    
    init(avatarRepository: AvatarRepository, userNickname: String) {
        
        self.avatarRepository = avatarRepository
        self.userNickname = userNickname
    }
    
    struct Input {
        let avatarCellDidTap: ControlEvent<IndexPath>
        let changeButtonDidTap: ControlEvent<Void>
        let continueButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let bindAvatarImageCell = BehaviorRelay<[(String, Bool)]>(value: [])
        let updateAvatarData = PublishRelay<(Avatar,String)>()
        let dismissModalViewController = PublishRelay<Void>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        Observable.just(())
            .flatMapLatest { _ in
                self.getAvatarList()
            }
            .subscribe(with: self, onNext: { owner, avatarList in
                
                //전체 avatar 리스트 저장
                owner.totalAvatarData = avatarList.avatars
                
                //셀 바인딩을 위한 튜플 생성
                let avatarImage = avatarList.avatars.map { ($0.avatarImage , $0.isRepresentative)}
                output.bindAvatarImageCell.accept(avatarImage)
                
                //View 바인딩을 위한 대표아바타ID 저장
                let presentativeId = avatarList.avatars.first(where: { $0.isRepresentative })?.avatarId
                owner.defaultAvatarId = presentativeId ?? owner.defaultAvatarId
                owner.lastTappedAvatar.accept(owner.defaultAvatarId)
                
            }, onError: { owner, error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        input.avatarCellDidTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map { $0.row + 1 }
            .bind(to: lastTappedAvatar)
            .disposed(by: disposeBag)
        
        self.lastTappedAvatar
            .subscribe(with: self, onNext: { owner, avatarId in
                guard avatarId >= 0 && avatarId <= owner.totalAvatarData.count else { return }
                output.updateAvatarData.accept((owner.totalAvatarData[avatarId - 1], owner.userNickname))
            })
            .disposed(by: disposeBag)
        
        input.changeButtonDidTap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                let avatarId = owner.lastTappedAvatar.value
                if (avatarId != owner.defaultAvatarId) {
                    let avatarImage = owner.totalAvatarData[avatarId-1].avatarImage
                    NotificationCenter.default.post(name: NSNotification.Name("ChangRepresentativeAvatar"), object: (avatarId, avatarImage))
                }
                output.dismissModalViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.continueButtonDidTap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
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
