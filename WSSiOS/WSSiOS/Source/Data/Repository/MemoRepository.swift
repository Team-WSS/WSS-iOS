//
//  MemoRepository.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol MemoRepository {
    func getRecordMemos(lastId: Int, sort: String) -> Observable<RecordMemos>
    func postMemo(userNovelId: Int, memoContent: String) -> Observable<IsAvatarUnlocked>
    func postFeed(relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool) -> Observable<Void>
    func putFeed(feedId: Int, relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool) -> Observable<Void>
    func getMemoDetail(memoId: Int) -> Observable<MemoDetail>
    func deleteMemo(memoId: Int) -> Observable<Void>
    func patchMemo(memoId: Int, memoContent: String) -> Observable<Void>
}

struct DefaultMemoRepository: MemoRepository {
    
    private var memoService: MemoService
    
    init(memoService: MemoService) {
        self.memoService = memoService
    }
    
    func getRecordMemos(lastId: Int, sort: String) -> Observable<RecordMemos> {
        return memoService.getRecordMemos(lastId: lastId, sort: sort)
            .asObservable()
    }
    
    func postMemo(userNovelId: Int, memoContent: String) -> Observable<IsAvatarUnlocked> {
        return memoService.postMemo(userNovelId: userNovelId, memoContent: memoContent)
            .asObservable()
    }
    
    func postFeed(relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool) -> Observable<Void> {
        return memoService.postFeed(relevantCategories: relevantCategories, feedContent: feedContent, novelId: novelId, isSpoiler: isSpoiler)
            .asObservable()
    }
    
    func putFeed(feedId: Int, relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool) -> Observable<Void> {
        return memoService.putFeed(feedId: feedId, relevantCategories: relevantCategories, feedContent: feedContent, novelId: novelId, isSpoiler: isSpoiler)
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
