//
//  RecommendRepository.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol RecommendRepository {
    func getSosopickNovels() -> Observable<SosopickNovels>
}

struct DefaultRecommendRepository: RecommendRepository {
    
    private let recommendService: RecommendService
    
    init(recommendService: RecommendService) {
        self.recommendService = recommendService
    }
    
    func getSosopickNovels() -> Observable<SosopickNovels> {
        return recommendService.getSosopickData()
            .asObservable()
    }
}
