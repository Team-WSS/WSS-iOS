//
//  HapticManager.swift
//  WSSiOS
//
//  Created by YunhakLee on 7/13/25.
//

import UIKit

final class HapticManager {
    
    static let shared = HapticManager()
    private init() {}
    
    /// 선택 변경(UISelectionFeedbackGenerator) 햅틱을 발생시킵니다.
    /// 주로 피커(Picker)나 스위치(Switch) 등 선택이 바뀔 때 사용합니다.
    func generateSelectionFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare() // 햅틱 엔진을 준비시켜 딜레이를 줄입니다.
        generator.selectionChanged()
    }
    
    /// 충격(UIImpactFeedbackGenerator) 햅틱을 발생시킵니다.
    /// - Parameter style: 충격의 강도를 나타냅니다. (.light, .medium, .heavy, .soft, .rigid)
    func generateImpactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// 알림(UINotificationFeedbackGenerator) 햅틱을 발생시킵니다.
    /// - Parameter type: 알림의 종류를 나타냅니다. (.success, .warning, .error)
    func generateNotificationFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
