//
//  UITextView+.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/17/24.
//

import UIKit

extension UITextView {
    func makeAttribute(with text: String?) -> TextViewAttributeSet? {
        guard let text = text, !text.isEmpty else { return nil }
        
        let textViewAttributeSet = TextViewAttributeSet(
            textView: self,
            attributeString: NSMutableAttributedString(string: text)
        )
        
        return textViewAttributeSet
    }
}

struct TextViewAttributeSet {
    var textView: UITextView
    var attributedString: NSMutableAttributedString

    init(textView: UITextView, attributeString: NSMutableAttributedString) {
        self.textView = textView
        self.attributedString = attributeString
    }
}

extension TextViewAttributeSet {
    func lineSpacing(spacingPercentage: Double) -> TextViewAttributeSet {
        let spacing = (self.textView.font!.pointSize * CGFloat(spacingPercentage/100) - self.textView.font!.pointSize)/2
        
        let style = NSMutableParagraphStyle().then { $0.lineSpacing = spacing }
        self.attributedString.addAttribute(
            .paragraphStyle,
            value: style,
            range: NSRange(location: 0, length: attributedString.length)
        )
        
        return self
    }
    
    func kerning(kerningPixel: Double) -> TextViewAttributeSet {
        self.attributedString.addAttribute(
            .kern,
            value: kerningPixel,
            range: NSRange(location: 0, length: attributedString.length - 1)
        )
        
        return self
    }
    
    func applyAttribute() {
        self.textView.attributedText = self.attributedString
    }
}
