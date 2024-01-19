//
//  MemoRepository.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol MemoRepository {
    func getRecordMemoList(memoId: Int, sort: String) -> Observable<RecordMemos>
    func postMemo(userNovelId: Int, memoContent: String) -> Observable<IsAvatarUnlocked>
    func getMemoDetail(memoId: Int) -> Observable<MemoDetail>
    func deleteMemo(memoId: Int) -> Observable<Void>
    func patchMemo(memoId: Int, memoContent: String) -> Observable<Void>
}

struct DefaultMemoRepository: MemoRepository {
    
    private var memoService: MemoService
    
    init(memoService: MemoService) {
        self.memoService = memoService
    }
    
    func getRecordMemoList(memoId: Int, sort: String) -> Observable<RecordMemos> {
        return memoService.getRecordMemosData(memoId: memoId, sort: sort)
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
    
    func deleteMemo(memoId: Int) -> Observable<Void> {
        return memoService.deleteMemo(memoId: memoId)
            .asObservable()
    }
    
    func patchMemo(memoId: Int, memoContent: String) -> Observable<Void> {
        return memoService.patchMemo(memoId: memoId, memoContent: memoContent)
            .asObservable()
    }
}
