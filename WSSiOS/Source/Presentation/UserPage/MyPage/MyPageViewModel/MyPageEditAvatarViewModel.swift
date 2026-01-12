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
    
    private let userNickname: String
    private let avatarRepository: AvatarRepository
    
    private let avatars = BehaviorRelay<[AvatarEntity]>(value: [])
    private let selectedAvatar = BehaviorRelay<AvatarEntity?>(value: nil)
    private var defaultAvatar: AvatarEntity? = nil
    
    //MARK: - Life Cycle
    
    init(avatarRepository: AvatarRepository, userNickname: String) {
        self.avatarRepository = avatarRepository
        self.userNickname = userNickname
    }
    
    struct Input {
        let avatarCellDidTap: ControlEvent<IndexPath>
        let changeButtonDidTap: ControlEvent<Void>
        let cancelButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let bindAvatarImageCell = BehaviorRelay<[(URL?, Bool)]>(value: [])
        let updateAvatarLine = PublishRelay<(AvatarEntity, String)>()
        let initialSelectedAvatarIndex = PublishRelay<Int>()
        let dismissModalViewController = PublishRelay<Void>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        self.getAvatarList()
            .map {
                self.reorderAvatarsForPaging(avatars: $0.avatars)
            }
            .subscribe(with: self, onNext: { owner, avatars in
                owner.avatars.accept(avatars)
                
                let defaultAvatar = avatars.first(where: { $0.isRepresentative })
                owner.defaultAvatar = defaultAvatar
                owner.selectedAvatar.accept(owner.defaultAvatar)
                
                if let defaultAvatar,
                   let index = avatars.firstIndex(where: { $0.avatarId == defaultAvatar.avatarId }) {
                    output.initialSelectedAvatarIndex.accept(index)
                }
            })
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(avatars, selectedAvatar)
            .map { avatars, selectedAvatar in
                avatars.map { avatar in
                    (
                        avatar.avatarProfileImageURL,
                        avatar.avatarId == selectedAvatar?.avatarId
                    )
                }
            }
            .bind(to: output.bindAvatarImageCell)
            .disposed(by: disposeBag)
        
        input.avatarCellDidTap
            .withLatestFrom(avatars) { indexPath, avatars in
                avatars[indexPath.row]
            }
            .bind(to: selectedAvatar)
            .disposed(by: disposeBag)
        
        selectedAvatar
            .compactMap { $0 }
            .distinctUntilChanged { $0.avatarId == $1.avatarId }
            .subscribe(with: self, onNext: { owner, avatar in
                // 아바타 대사 속 유저의 닉네임이 들어가는 경우 존재
                output.updateAvatarLine.accept((avatar, owner.userNickname))
            })
            .disposed(by: disposeBag)
        
        input.changeButtonDidTap
            .withLatestFrom(selectedAvatar.compactMap { $0 })
            .subscribe(with: self, onNext: { owner, avatar in
                
                // 기존에 선택한 아바타와 최종 선택한 아바타가 동일 시 전달 X
                guard avatar.avatarId != owner.defaultAvatar?.avatarId else {
                    output.dismissModalViewController.accept(())
                    return
                }
                
                NotificationCenter.default.post(
                    name: NotificationName.changeRepresentativeAvatar,
                    object: (avatar.avatarId, avatar.avatarProfileImageURL)
                )
                
                output.dismissModalViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.cancelButtonDidTap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                output.dismissModalViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    //MARK: - API
    
    private func getAvatarList() -> Observable<AvatarListEntity> {
        return avatarRepository.getAvatarList()
    }
    
    private func reorderAvatarsForPaging(avatars: [AvatarEntity],
                                         rows: Int = 2,
                                         columns: Int = 5) -> [AvatarEntity] {
        let pageSize = rows * columns
        var reordered: [AvatarEntity] = []
        
        for start in stride(from: 0, to: avatars.count, by: pageSize) {
            let page = Array(avatars[start..<min(start + pageSize, avatars.count)])
            
            for row in 0..<rows {
                for column in 0..<columns {
                    let index = column * rows + row
                    if index < page.count {
                        reordered.append(page[index])
                    }
                }
            }
        }
        
        return reordered
    }
}
