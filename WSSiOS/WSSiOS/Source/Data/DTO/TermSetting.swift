//
//  TermSetting.swift
//  WSSiOS
//
//  Created by YunhakLee on 2/12/25.
//

import Foundation

struct TermSettingDTO: Codable {
    let serviceAgreed: Bool
    let privacyAgreed: Bool
    let marketingAgreed: Bool
}
