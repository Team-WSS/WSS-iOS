//
//  NovelDetailViewModel.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 2/23/24.
//

import UIKit

import RxSwift
import RxCocoa

final class NovelDetailViewModel: ViewModelType {
    
    struct Input {
        let novelSettingButtonDidTapEvent: Observable<Void>
        let viewDidTapEvent: Observable<UITapGestureRecognizer>
        let memoButtonDidTapEvent: Observable<Void>
        let infoButtonDidTapEvent: Observable<Void>
        let stickyMemoButtonDidTapEvent: Observable<Void>
        let stickyInfoButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        let memoSettingButtonViewIsHidden = BehaviorRelay<Bool>(value: true)
        let selectedMenu = BehaviorRelay<SelectedMenu>(value: .memo)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.novelSettingButtonDidTapEvent
            .subscribe(with: self, onNext: { owner, _ in
                if output.memoSettingButtonViewIsHidden.value == false {
                    output.memoSettingButtonViewIsHidden.accept(true)
                } else {
                    output.memoSettingButtonViewIsHidden.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        input.viewDidTapEvent
            .subscribe(with: self, onNext: { owner, _ in
                output.memoSettingButtonViewIsHidden.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.memoButtonDidTapEvent
            .subscribe(with: self, onNext: { owner, _ in
                output.selectedMenu.accept(.memo)
            })
            .disposed(by: disposeBag)
        
        input.infoButtonDidTapEvent
            .subscribe(with: self, onNext: { owner, _ in
                output.selectedMenu.accept(.info)
            })
            .disposed(by: disposeBag)
        
        input.stickyMemoButtonDidTapEvent
            .subscribe(with: self, onNext: { owner, _ in
                output.selectedMenu.accept(.memo)
            })
            .disposed(by: disposeBag)
        
        input.stickyInfoButtonDidTapEvent
            .subscribe(with: self, onNext: { owner, _ in
                output.selectedMenu.accept(.info)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
