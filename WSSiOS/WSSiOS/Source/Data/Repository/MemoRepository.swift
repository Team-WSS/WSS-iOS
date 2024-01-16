//
//  MemoRepository.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol MemoRepository {
    func getRecordMemoList() -> Observable<RecordMemos>
    func postMemo(userNovelId: Int, memoContent: String) -> Observable<IsAvatarUnlocked>
    func getMemoDetail(memoId: Int) -> Observable<MemoDetail>
}

struct DefaultMemoRepository: MemoRepository {
    
    private var memoService: MemoService
    
    init(memoService: MemoService) {
        self.memoService = memoService
    }
    
    func getRecordMemoList() -> Observable<RecordMemos> {
        return memoService.getRecordMemosData()
            .asObservable()
    }
    
    func postMemo(userNovelId: Int, memoContent: String) -> Observable<IsAvatarUnlocked> {
        return memoService.postMemo(userNovelId: userNovelId, memoContent: memoContent)
            .asObservable()
    }
    
    func getMemoDetail(memoId: Int) -> Observable<MemoDetail> {
        return memoService.getMemoDetail(memoId: memoId)
            .asObservable()
    }
}
