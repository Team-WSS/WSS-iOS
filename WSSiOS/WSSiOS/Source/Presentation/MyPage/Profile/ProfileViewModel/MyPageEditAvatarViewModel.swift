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
    
    private let userRepository: UserRepository
    var totalAvatarData: [Avatar] = []
    
    //MARK: - Life Cycle
    
    init(userRepository: UserRepository) {
        
        self.userRepository = userRepository
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
        let popViewController = PublishRelay<Void>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.avatarCellDidTap
            .subscribe(with: self, onNext: { owner, indexPath in
                output.updateAvatarData.accept(owner.totalAvatarData[indexPath.row])
            })
            .disposed(by: disposeBag)
        
        input.changeButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                output.popViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.continueButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                output.popViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
