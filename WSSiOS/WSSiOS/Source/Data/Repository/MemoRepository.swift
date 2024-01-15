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
}
