//
//  DeletePopupViewModel.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 2/25/24.
//

import UIKit

import RxSwift
import RxCocoa

final class DeletePopupViewModel: ViewModelType {

    //MARK: - Properties

    private let userNovelRepository: UserNovelRepository?
    private let memoRepository: MemoRepository?
    private let userNovelId: Int?
    private let memoId: Int?
    
    //MARK: - Life Cycle

    init(userNovelRepository: UserNovelRepository? = nil, memoRepository: MemoRepository? = nil, userNovelId: Int? = nil, memoId: Int? = nil) {
        self.userNovelRepository = userNovelRepository
        self.memoRepository = memoRepository
        self.userNovelId = userNovelId
        self.memoId = memoId
    }

    struct Input {
        let popupStatus: PopupStatus
        let deleteButtonDidTap: ControlEvent<Void>
    }

    struct Output {
        let canceledEdit = PublishRelay<Bool>()
        let deletedMemo = PublishRelay<Bool>()
        let deletedNovel = PublishRelay<Bool>()
    }

    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        switch input.popupStatus {
        case .memoEditCancel:
            input.deleteButtonDidTap
                .subscribe(onNext: {
                    output.canceledEdit.accept(true)
                }, onError: { error in
                    print(error)
                })
                .disposed(by: disposeBag)
        case .memoDelete:
            input.deleteButtonDidTap
                .flatMapLatest {
                    self.deleteMemo()
                }
                .subscribe(onNext: {
                    output.deletedMemo.accept(true)
                }, onError: { error in
                    print(error)
                })
                .disposed(by: disposeBag)
        case .novelDelete:
            input.deleteButtonDidTap
                .flatMapLatest {
                    self.deleteUserNovel()
                }
                .subscribe(onNext: {
                    output.deletedNovel.accept(true)
                }, onError: { error in
                    print(error)
                })
                .disposed(by: disposeBag)
        }
        
        return output
    }
    
    //MARK: - API
    
    private func deleteUserNovel() -> Observable<Void> {
        guard let userNovelRepository = self.userNovelRepository, let userNovelId = self.userNovelId else {
            return Observable.empty()
        }

        return userNovelRepository.deleteUserNovel(userNovelId: userNovelId)
            .observe(on: MainScheduler.instance)
    }
    
    private func deleteMemo() -> Observable<Void> {
        guard let memoRepository = self.memoRepository, let memoId = self.memoId else {
            return Observable.empty()
        }

        return memoRepository.deleteMemo(memoId: memoId)
            .observe(on: MainScheduler.instance)
    }
}
