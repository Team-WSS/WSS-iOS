//
//  AmplitudeManager.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 12/31/24.
//

import UIKit

import AmplitudeSwift

final class AmplitudeManager {
    static let shared = AmplitudeManager()
    
    let amplitude: Amplitude

    private init() {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: Config.Keys.Plist.amplitudeAPIKey) as? String ?? ""
        amplitude = Amplitude(
            configuration: Configuration(
                apiKey: apiKey,
                autocapture: [.sessions, .appLifecycles]
            )
        )
    }
    
    func track<T: RawRepresentable>(_ event: T, properties: [String: Any]? = nil) where T.RawValue == String {
        amplitude.track(eventType: event.rawValue, eventProperties: properties)
    }
}
