//
//  LottieLiterals.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/18/24.
//

import Foundation

import Lottie

enum Lottie {
    static let loading = LottieAnimationView(name: "loading")
    
    enum Onboarding {
        static let success = LottieAnimationView(name: "scroll")
    }
    
    enum Home {
        enum Sosocat {
            static let tail = LottieAnimationView(name: "sosocatTail")
            static let bread = LottieAnimationView(name: "sosocatBread")
        }
        
        enum Villainess {
            static let fan = LottieAnimationView(name: "villainessFan")
            static let tea = LottieAnimationView(name: "villainessTea")
        }
        
        enum Regressor {
            static let sword = LottieAnimationView(name: "regressorSword")
            static let greeting = LottieAnimationView(name: "regressorGreeting")
        }
    }
}
