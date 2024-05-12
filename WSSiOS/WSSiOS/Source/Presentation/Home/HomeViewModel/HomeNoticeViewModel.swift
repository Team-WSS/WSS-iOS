//
//  HomeNoticeViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/12/24.
//

import UIKit

import RxSwift
import RxCocoa

final class HomeNoticeViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let noticeRepository: DefaultNoticeRepository
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    struct Input {
        let noticeCellTapped: ControlEvent<IndexPath>
    }
    
    // MARK: - Outputs
    
    struct Output {
        var noticeList = BehaviorRelay<[Notice]>(value: [])
        let navigateToNoticeDetail = PublishRelay<IndexPath>()
    }
    
    //MARK: - init
    
    init(noticeRepository: DefaultNoticeRepository) {
        self.noticeRepository = noticeRepository
    }
}

extension HomeNoticeViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        noticeRepository.getTestNotices()
            .subscribe(with: self, onNext: { owner, data in
                output.noticeList.accept(data)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        input.noticeCellTapped
            .subscribe(onNext: { indexPath in
                output.navigateToNoticeDetail.accept(indexPath)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
