//
//  NovelDetailViewModel.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 2/23/24.
//

import Foundation
import RxSwift
import RxCocoa

final class NovelDetailViewModel: ViewModelType {
    
    struct Input {
        let novelSettingButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        let memoSettingButtonViewIsHidden = BehaviorRelay<Bool>(value: true)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.novelSettingButtonDidTapEvent.subscribe(with: self, onNext: { owner, _ in
            if output.memoSettingButtonViewIsHidden.value == false {
                output.memoSettingButtonViewIsHidden.accept(true)
            } else {
                output.memoSettingButtonViewIsHidden.accept(false)
            }
            
        }).disposed(by: disposeBag)
        
        return output
    }
}
