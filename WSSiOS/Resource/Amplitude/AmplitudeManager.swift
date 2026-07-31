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
    
    private let amplitude: Amplitude?

    private init() {
#if DEBUG
        amplitude = nil
#else
        let apiKey = Bundle.main.object(forInfoDictionaryKey: Config.Keys.Plist.amplitudeAPIKey) as? String ?? ""
        amplitude = Amplitude(
            configuration: Configuration(
                apiKey: apiKey,
                autocapture: [.sessions, .appLifecycles]
            )
        )
#endif
    }

    func track<T: RawRepresentable>(_ event: T, properties: [String: Any]? = nil) where T.RawValue == String {
        amplitude?.track(eventType: event.rawValue, eventProperties: properties)
    }
}
