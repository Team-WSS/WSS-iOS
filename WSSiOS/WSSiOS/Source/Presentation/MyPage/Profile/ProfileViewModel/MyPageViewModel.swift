//
//  MyPageViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 7/9/24.
//

import Foundation

import RxSwift
import RxCocoa

final class MyPageViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()
    var height: Double = 0.0
    
    // MARK: - Life Cycle
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    struct Input {
        let isMyPage: Driver<Bool>
        let headerViewHeight: Driver<Double>
        let scrollOffset: Driver<CGPoint>
        let settingButtonDidTap: ControlEvent<Void>
        let dropdownButtonDidTap: Observable<String>
        let editButtonTapoed: ControlEvent<Void>
    }
    
    struct Output {
        let profileData = BehaviorSubject<MyProfileResult>(value: MyProfileResult(nickname: "",
                                                                                  intro: "",
                                                                                  avatarImage: "", genrePreferences: []))
        let settingButtonEnabled = PublishRelay<Void>()
        let dropdownButtonEnabled = PublishRelay<String>()
        let updateNavigationEnabled = BehaviorRelay<Bool>(value: false)
        let pushToEditViewController = PublishRelay<Void>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.isMyPage
            .asObservable()
            .flatMapLatest { [unowned self] isMyPage in
                self.getProfileData(isMyPage: isMyPage)
            }
            .bind(to: output.profileData)
            .disposed(by: disposeBag)
        
        input.headerViewHeight
            .asObservable()
            .bind(with: self, onNext: { owner, height in 
                owner.height = height
            })
            .disposed(by: disposeBag)
        
        input.scrollOffset
            .asObservable()
            .map{ $0.y }
            .subscribe(with: self, onNext: { owner, scrollHeight in 
                if (scrollHeight > owner.height) {
                    output.updateNavigationEnabled.accept(true)
                } else {
                    output.updateNavigationEnabled.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        input.settingButtonDidTap
            .bind(with: self, onNext: { owner, _ in 
                output.settingButtonEnabled.accept(())
            })
            .disposed(by: disposeBag)
        
        input.editButtonTapoed
            .bind(with: self, onNext: { owner, _ in 
                output.pushToEditViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.dropdownButtonDidTap
            .bind(with: self, onNext: { owner, data in
                if data == "수정하기" {
                    output.dropdownButtonEnabled.accept(data)
                }
            })
        
        return output
    }
    
    // MARK: - Custom Method
    
    
    // MARK: - API
    
    private func getProfileData(isMyPage: Bool) -> Observable<MyProfileResult> {
        if isMyPage {
            return userRepository.getMyProfileData()
        } else {
            return userRepository.getMyProfileData()
        }
    }
}
