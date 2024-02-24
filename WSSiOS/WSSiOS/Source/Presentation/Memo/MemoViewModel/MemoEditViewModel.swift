//
//  MemoEditViewModel.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 2/24/24.
//

import UIKit

import RxSwift
import RxCocoa

final class MemoEditViewModel: ViewModelType {
    
    //MARK: - Properties
        
    private let memoRepository: MemoRepository
    
    private let userNovelId: Int?
    private let memoId: Int?
    let memoContent: String?
    private var updatedMemoContent: String = ""
    private let memoContentPredicate = NSPredicate(format: "SELF MATCHES %@", "^[\\s]+$")
    private let maximumMemoContentCount: Int = 2000
       
    //MARK: - Life Cycle
    
    init(memoRepository: MemoRepository, userNovelId: Int? = nil, memoId: Int? = nil, memoContent: String? = nil) {
        self.memoRepository = memoRepository
        self.userNovelId = userNovelId
        self.memoId = memoId
        self.memoContent = memoContent
    }
    
    struct Input {
        let updatedMemoContent: Observable<String>
        let completeButtonDidTapEvent: Observable<Void>
        let backButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        let memoContentPrefix = BehaviorRelay<String>(value: "")
        let completeButtonIsAbled = BehaviorRelay<Bool>(value: false)
        let isMemoSaveSuccess = PublishRelay<Bool>()
        let isFixes = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.updatedMemoContent
            .subscribe(with: self, onNext: { owner, text in
                owner.updatedMemoContent = text
                output.memoContentPrefix.accept(String(text.prefix(owner.maximumMemoContentCount)))

                let isEmpty = text.count == 0
                let isOverLimit = text.count > owner.maximumMemoContentCount
                let isWrongFormat = owner.memoContentPredicate.evaluate(with: owner.updatedMemoContent)
                let isNotChanged = owner.updatedMemoContent == owner.memoContent

                if isEmpty || isOverLimit || isWrongFormat || isNotChanged {
                    output.completeButtonIsAbled.accept(false)
                } else {
                    output.completeButtonIsAbled.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        if memoContent != nil {
            input.completeButtonDidTapEvent
                .flatMapLatest {
                    self.patchMemo(memoId: self.memoId!, memoContent: self.updatedMemoContent)
                }
                .subscribe(with: self, onNext: { owner, data in
                    NotificationCenter.default.post(name: NSNotification.Name("PatchedMemo"), object: nil)
                    output.isMemoSaveSuccess.accept(true)
                }, onError: { owner, error in
                    print(error)
                    output.isMemoSaveSuccess.accept(false)
                })
                .disposed(by: disposeBag)
            
            
            input.backButtonDidTapEvent
                .subscribe(with: self, onNext: { owner, _ in
                    if owner.updatedMemoContent != owner.memoContent {
                        output.isFixes.accept(true)
                    } else {
                        output.isFixes.accept(false)
                    }
                })
                .disposed(by: disposeBag)
        } else {
            input.completeButtonDidTapEvent
                .flatMapLatest {
                    self.postMemo(userNovelId: self.userNovelId!, memoContent: self.updatedMemoContent)
                }
                .subscribe(with: self, onNext: { owner, data in
                    if data.isAvatarUnlocked {
                        NotificationCenter.default.post(name: NSNotification.Name("AvatarUnlocked"), object: nil)
                    } else {
                        NotificationCenter.default.post(name: NSNotification.Name("PostedMemo"), object: nil)
                    }
                    output.isMemoSaveSuccess.accept(true)
                }, onError: { owner, error in
                    print(error)
                    output.isMemoSaveSuccess.accept(false)
                })
                .disposed(by: disposeBag)
            
            input.backButtonDidTapEvent
                .subscribe(with: self, onNext: { owner, _ in
                    if owner.updatedMemoContent.count > 0 && !owner.memoContentPredicate.evaluate(with: owner.updatedMemoContent) {
                        output.isFixes.accept(true)
                    } else {
                        output.isFixes.accept(false)
                    }
                })
                .disposed(by: disposeBag)
        }
        
        return output
    }
    
    private func postMemo(userNovelId: Int, memoContent: String) -> Observable<IsAvatarUnlocked> {
        memoRepository.postMemo(userNovelId: userNovelId, memoContent: memoContent)
            .observe(on: MainScheduler.instance)
    }
    
    private func patchMemo(memoId: Int, memoContent: String) -> Observable<Void> {
        memoRepository.patchMemo(memoId: memoId, memoContent: memoContent)
            .observe(on: MainScheduler.instance)
    }
}
