//
//  String+.swift
//  WSSiOS
//
//  Created by 신지원 on 5/20/24.
//

import Foundation

extension String {
    
    // 말줄임표 만들어주는 extension
    func truncateText(maxLength: Int) -> String {
        if self.count > maxLength {
            let endIndex = self.index(self.startIndex, offsetBy: maxLength)
            return self[self.startIndex..<endIndex] + "..."
        } else {
            return self
        }
    }
}
