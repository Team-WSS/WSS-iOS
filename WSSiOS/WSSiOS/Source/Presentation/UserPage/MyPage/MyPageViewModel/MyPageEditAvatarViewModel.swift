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
    
    private var totalAvatarData: [AvatarEntity] = []
    private let lastTappedAvatarId = BehaviorRelay<Int>(value: 1)
    private var defaultAvatarId: Int = 1
    
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
        let bindAvatarImageCell = BehaviorRelay<[(URL?, Bool)]>(value: [])
        let updateAvatarData = PublishRelay<(AvatarEntity,String)>()
        let dismissModalViewController = PublishRelay<Void>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        Observable.just(())
            .flatMapLatest { _ in
                self.getAvatarList()
            }
            .map { [weak self] avatarList -> [AvatarEntity] in
                guard let self else { return avatarList.avatars }
                return self.reorderAvatarsForPaging(avatars: avatarList.avatars)
            }
            .subscribe(with: self, onNext: { owner, avatarList in
                
                owner.totalAvatarData = avatarList

                let avatarImage = avatarList.map {
                    ($0.avatarProfileImageURL, $0.isRepresentative)
                }
                output.bindAvatarImageCell.accept(avatarImage)

                let presentativeId = avatarList.first(where: { $0.isRepresentative })?.avatarId
                owner.defaultAvatarId = presentativeId ?? owner.defaultAvatarId
                owner.lastTappedAvatarId.accept(owner.defaultAvatarId)
                
            }, onError: { owner, error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        input.avatarCellDidTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map { $0.row + 1 }
            .bind(to: lastTappedAvatarId)
            .disposed(by: disposeBag)
        
        self.lastTappedAvatarId
            .subscribe(with: self, onNext: { owner, avatarId in
                guard avatarId >= 0 && avatarId <= owner.totalAvatarData.count else { return }
                output.updateAvatarData.accept((owner.totalAvatarData[avatarId - 1], owner.userNickname))
            })
            .disposed(by: disposeBag)
        
        input.changeButtonDidTap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                let avatarId = owner.lastTappedAvatarId.value
                if (avatarId != owner.defaultAvatarId) {
                    let avatarImage = owner.totalAvatarData[avatarId-1].avatarProfileImageURL
                    NotificationCenter.default.post(name: NotificationName.changeRepresentativeAvatar, object: (avatarId, avatarImage))
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
    
    private func getAvatarList() -> Observable<AvatarListEntity> {
        return avatarRepository.getAvatarList()
    }
    
    private func reorderAvatarsForPaging(
        avatars: [AvatarEntity],
        rows: Int = 2,
        columns: Int = 5
    ) -> [AvatarEntity] {

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
