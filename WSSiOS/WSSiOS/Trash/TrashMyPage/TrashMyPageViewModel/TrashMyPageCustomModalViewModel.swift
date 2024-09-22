////
////  TrashMyPageModalViewModel.swift
////  WSSiOS
////
////  Created by 신지원 on 3/5/24.
////
//
//import Foundation
//
//import RxSwift
//import RxCocoa
//
//final class TrashMyPageCustomModalViewModel: ViewModelType {
//    
//    //MARK: - Properties
//    
//    private let avatarRepository: AvatarRepository
//    var avatarData: Observable<AvatarResult>?
//    let avatarId: Int
//    private let modalHasAvatar: Bool
//    private let currentRepresentativeAvatar: Bool
//    
//    //MARK: - Life Cycle
//    
//    init(avatarRepository: AvatarRepository,
//         avatarId: Int,
//         modalHasAvatar: Bool,
//         currentRepresentativeAvatar: Bool) {
//        
//        self.avatarRepository = avatarRepository
//        self.avatarId = avatarId
//        self.modalHasAvatar = modalHasAvatar
//        self.currentRepresentativeAvatar = currentRepresentativeAvatar
//        
//        let data = self.getAvatarData(avatar: avatarId)
//        self.avatarData = data
//    }
//    
//    struct Input {
//        let viewDidLoad: Driver<Bool>
//        let viewWillAppear: Driver<Bool>
//        let viewWillDisappear: Driver<Bool>
//        let continueButtonDidTap: ControlEvent<Void>
//        let changeButtonDidTap: Observable<Int>
//        let backButtonDidTap: ControlEvent<Void>
//    }
//    
//    struct Output {
//        let viewDidLoadAction = BehaviorRelay(value: false)
//        let viewWillAppearAction = BehaviorRelay(value: false)
//        let viewWillDisappearAction = BehaviorRelay(value: false)
//        let backAction = BehaviorRelay(value: false)
//    }
//    
//    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
//        let output = Output()
//        
//        input.viewDidLoad
//            .drive(with: self, onNext: { owner, _ in 
//                if !self.modalHasAvatar || self.currentRepresentativeAvatar {
//                    output.viewDidLoadAction.accept(false)
//                } else {
//                    output.viewDidLoadAction.accept(true)
//                }
//            })
//            .disposed(by: disposeBag)
//        
//        input.viewWillAppear
//            .drive(output.viewWillAppearAction)
//            .disposed(by: disposeBag)
//        
//        input.viewWillDisappear
//            .drive(output.viewWillDisappearAction)
//            .disposed(by: disposeBag)
//        
//        input.changeButtonDidTap
//            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
//            .flatMapLatest { id -> Observable<Bool> in
//                return self.patchAvatar(avatar: id)
//            }
//            .filter { $0 == true }
//            .subscribe(with: self, onNext: { owner, _ in
//                output.backAction.accept(true)
//            })
//            .disposed(by: disposeBag)
//        
//        input.continueButtonDidTap
//            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
//            .subscribe { _ in
//                output.backAction.accept(true)
//            }
//            .disposed(by: disposeBag)
//        
//        input.backButtonDidTap
//            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
//            .subscribe { _ in
//                output.backAction.accept(true)
//            }
//            .disposed(by: disposeBag)
//        
//        return output
//    }
//    
//    //MARK: - API
//    
//    private func getAvatarData(avatar: Int) -> Observable<AvatarResult> {
//        return self.avatarRepository.getAvatarData(avatarId: avatar)
//    }
//    
//    private func patchAvatar(avatar: Int) -> Observable<Bool> {
//        return self.avatarRepository.patchAvatar(avatarId: avatar)
//    }
//}
