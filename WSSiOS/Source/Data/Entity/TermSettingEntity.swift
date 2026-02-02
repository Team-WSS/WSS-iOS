//
//  TermSettingEntity.swift
//  WSSiOS
//
//  Created by YunhakLee on 2/13/25.
//

import Foundation

struct TermSettingEntity {
    let isAllRequiredTermsAgreed: Bool
}

extension TermSettingResponse {
    func toEntity() -> TermSettingEntity {
        let isAllRequiredTermsAgreed = self.privacyAgreed && self.serviceAgreed
        return TermSettingEntity(isAllRequiredTermsAgreed: isAllRequiredTermsAgreed)
    }
}
