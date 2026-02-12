//
//  AppReviewManager.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 2/6/26.
//

import Foundation
import StoreKit

final class AppReviewManager {
    
    static let shared = AppReviewManager()
    
    private init() {}
    
    func requestReview() {
        guard
            let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first
        else { return }
        
        SKStoreReviewController.requestReview(in: windowScene)
    }
}
