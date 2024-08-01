//
//  BlocksService.swift
//  WSSiOS
//
//  Created by 신지원 on 8/1/24.
//

import Foundation

import RxSwift

protocol BlocksService {
  
}

final class DefaultBlocksService: NSObject, Networking {
    private var urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default,
                                                    delegate: nil,
                                                    delegateQueue: nil)
}

extension DefaultBlocksService: BlocksService {
   
}



