//
//  String+.swift
//  WSSiOS
//
//  Created by 신지원 on 6/3/24.
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
    
    // 띄어쓰기만으로 이루어진 Text 인지 체크
    func textIsEmpty() -> Bool {
        let trimmedText = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedText.isEmpty { return true } else { return false }
    }
}
