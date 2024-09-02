//
//  NoticeRepository.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/12/24.
//

import Foundation

import RxSwift

protocol NoticeRepository {
    func getNotices() -> Observable<[Notice]>
}

struct DefaultNoticeRepository: NoticeRepository {
    
    private var noticeService: NoticeService
    
    init(noticeService: NoticeService) {
        self.noticeService = noticeService
    }
    
    func getNotices() -> Observable<[Notice]> {
        return noticeService.getNoticeList().asObservable()
    }
}
