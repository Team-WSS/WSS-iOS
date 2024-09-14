//
//  HomeNoticeDetailViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/6/24.
//

import Foundation

import RxSwift
import RxCocoa

final class HomeNoticeDetailViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    struct Input {
        let viewWillAppearEvent: Observable<Notice>
    }
    
    // MARK: - Outputs
    
    struct Output {
        let noticeData = BehaviorRelay<Notice>(value: Notice(noticeTitle: "", noticeContent: "", createdDate: ""))
    }
}

extension HomeNoticeDetailViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .subscribe(with: self, onNext: { owner, data in
                output.noticeData.accept(data)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
