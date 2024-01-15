//
//  MyPageViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 1/10/24.
//

import Foundation

import RxSwift
import RxCocoa

protocol MyUseCase {
    var profileData: PublishRelay<UserDTO> { get }
   
    func requestMyPage()
}

final class MyPageViewModel {
    
    internal var disposeBag = DisposeBag()
    
    private var myUseCase : MyUseCase
    
    init(myUseCase: MyUseCase) {
        self.myUseCase = myUseCase
    }
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
    }
    
    struct Output {
        var profileData = PublishRelay<UserDTO>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewWillAppearEvent.subscribe(with: self, onNext: { owner, _ in
            owner.myUseCase.requestMyPage()
        }).disposed(by: disposeBag)
        
        return output
    }
    
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        myUseCase.profileData.subscribe(onNext: { profileData in
            output.profileData.accept(profileData)
        }).disposed(by: disposeBag)
    }
}

