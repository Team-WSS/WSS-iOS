//
//  KeywordManager.swift
//  WSSiOS
//
//  Created by 이윤학 on 5/1/24.
//

import UIKit

final class KeywordViewManager {
    static let shared = KeywordViewManager()
    private init() {}
    
    func tag() -> KeywordTag {
        return KeywordTag()
    }
    
    func link() -> KeywordLink {
        return KeywordLink()
    }
    
    func label() -> KeywordLabel {
        return KeywordLabel()
    }
}
