//
//  UIScreen+.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/19/24.
//

import UIKit

extension UIScreen {
    static var isSE: Bool { UIScreen.main.bounds.height < 680 }
}
