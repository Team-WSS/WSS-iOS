//
//  TermSetting.swift
//  WSSiOS
//
//  Created by YunhakLee on 2/12/25.
//

import Foundation

struct TermSettingResponse: Decodable {
    let serviceAgreed: Bool
    let privacyAgreed: Bool
    let marketingAgreed: Bool
}

struct TermSettingRequest: Encodable {
    let serviceAgreed: Bool
    let privacyAgreed: Bool
    let marketingAgreed: Bool
}

