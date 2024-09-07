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
    
    private let noticeRepository: NoticeRepository
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    struct Input {
        
    }
    
    // MARK: - Outputs
    
    struct Output {
        let noticeData = BehaviorRelay<Notice>(value: Notice(noticeTitle: "", noticeContent: "", createdDate: ""))
    }
    
    //MARK: - init
    
    init(noticeRepository: NoticeRepository) {
        self.noticeRepository = noticeRepository
    }
}

extension HomeNoticeDetailViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        noticeRepository.getNotices()
            .subscribe(with: self, onNext: { owner, data in
                output.noticeData.accept(data[0])
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
