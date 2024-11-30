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
    
    private let noticeRepository: NoticeRepository
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    struct Input {
        let noticeCellDidTap: ControlEvent<IndexPath>
    }
    
    // MARK: - Outputs
    
    struct Output {
        var noticeList = BehaviorRelay<[Notice]>(value: [])
        let selectedNoticeCellIndexPath = PublishRelay<IndexPath>()
        let showLoadingView = PublishRelay<Bool>()
    }
    
    //MARK: - init
    
    init(noticeRepository: NoticeRepository) {
        self.noticeRepository = noticeRepository
    }
}

extension HomeNoticeViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        noticeRepository.getNotices()
            .do(onNext: { _ in
                output.showLoadingView.accept(true)
            })
            .subscribe(with: self, onNext: { owner, data in
                output.noticeList.accept(data.notices)
                output.showLoadingView.accept(false)
            }, onError: { owner, error in
                print(error)
                output.showLoadingView.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.noticeCellDidTap
            .subscribe(onNext: { indexPath in
                output.selectedNoticeCellIndexPath.accept(indexPath)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
