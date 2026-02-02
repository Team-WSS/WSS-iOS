//
//  ViewModelType.swift
//  WSSiOS
//
//  Created by 신지원 on 2/17/24.
//

import Foundation
import RxSwift

protocol ViewModelType {

    associatedtype Input
    associatedtype Output

    func transform(from input: Input, disposeBag: DisposeBag) -> Output
}
