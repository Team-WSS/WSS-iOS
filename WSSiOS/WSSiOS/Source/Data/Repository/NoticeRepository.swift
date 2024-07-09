//
//  NoticeRepository.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/12/24.
//

import Foundation

import RxSwift

protocol NoticeRepository {
    func getTestNotices() -> Observable<[Notice]>
}

struct DefaultNoticeRepository: NoticeRepository {
    func getTestNotices() -> Observable<[Notice]> {
        return Observable.just([Notice(noticeTitle: "#후회남에 등록된 새로운 웹소설을 확인해 보실 수 있습니다람쥐",
                                       noticeContent: "후회남에 등록된 새로운 웹소설 리스트: <상수리 나무 아래>가 추가되었습니다~ 축하합니다~",
                                       createdDate: "2024.10.03"),
                                Notice(noticeTitle: "출석체크 관련 공지",
                                       noticeContent: "출석체크 하세용~",
                                       createdDate: "2024.11.14"),
                                Notice(noticeTitle: "#후회남에 등록된 새로운 웹소설을 확인하세요!",
                                       noticeContent: "후회남에 등록된 새로운 웹소설 리스트: <상수리 나무 아래>가 추가되었습니다~ 축하합니다~",
                                       createdDate: "2024.10.03"),
                                Notice(noticeTitle: "👑공지 제목 공지📢 ",
                                       noticeContent: "후회남에 등록된 새로운 웹소설 리스트: <상수리 나무 아래>가 추가되었습니다~ 축하합니다~",
                                       createdDate: "2024.10.03"),
                                Notice(noticeTitle: "#후회남에 등록된 새로운 웹소설을 확인해 보실 수 있습니다람쥐",
                                       noticeContent: "후회남에 등록된 새로운 웹소설 리스트: <상수리 나무 아래>가 추가되었습니다~ 축하합니다~",
                                       createdDate: "2024.10.03"),
                                Notice(noticeTitle: "#후회남에 등록된 새로운 웹소설을 확인해 보실 수 있습니다람쥐",
                                       noticeContent: "후회남에 등록된 새로운 웹소설 리스트: <상수리 나무 아래>가 추가되었습니다~ 축하합니다~",
                                       createdDate: "2024.10.03"),
                                Notice(noticeTitle: "#후회남에 등록된 새로운 웹소설을 확인해 보실 수 있습니다람쥐",
                                       noticeContent: "후회남에 등록된 새로운 웹소설 리스트: <상수리 나무 아래>가 추가되었습니다~ 축하합니다~",
                                       createdDate: "2024.10.03"),
                                Notice(noticeTitle: "#후회남에 등록된 새로운 웹소설을 확인해 보실 수 있습니다람쥐",
                                       noticeContent: "후회남에 등록된 새로운 웹소설 리스트: <상수리 나무 아래>가 추가되었습니다~ 축하합니다~",
                                       createdDate: "2024.10.03")])
    }
}
