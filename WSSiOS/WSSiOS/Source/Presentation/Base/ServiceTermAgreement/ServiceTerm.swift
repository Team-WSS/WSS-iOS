//
//  ServiceTerm.swift
//  WSSiOS
//
//  Created by YunhakLee on 2/11/25.
//

import Foundation

enum ServiceTerm: CaseIterable {
    case serviceAgreement
    case privacyPolicy
    case marketingConsent
    
    var fullText: String {
        return "\(termTitle) \(requiredStatusText)"
    }
    
    var requiredStatusText: String {
        switch self.isRequired {
        case true:
            return "(필수)"
        case false:
            return "(선택)"
        }
    }
    
    var isRequired: Bool {
        switch self {
        case .serviceAgreement:
            return true
        case .privacyPolicy:
            return true
        case .marketingConsent:
            return false
        }
    }
    
    var termTitle: String {
        switch self {
        case .serviceAgreement:
            return "서비스 이용약관 동의"
        case .privacyPolicy:
            return "개인정보 수집 및 이용 동의"
        case .marketingConsent:
            return "마케팅 정보 수신 동의"
        }
    }
    
    var connectedURLString: String? {
        switch self {
        case .serviceAgreement:
            return "https://websoso.notion.site/143600bd74688050be18f4da31d9403e"
        case .privacyPolicy:
            return "https://websoso.notion.site/198600bd746880699fd6f22dd42a7215"
        case .marketingConsent:
            return nil
        }
    }
    
    var underlineText: String {
        if self.connectedURLString != nil {
            return self.termTitle
        } else {
            return ""
        }
    }
}
