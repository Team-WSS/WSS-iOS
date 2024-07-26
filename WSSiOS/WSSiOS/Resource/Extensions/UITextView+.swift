//
//  UITextView+.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/17/24.
//

import UIKit

extension UITextView {
    func applyWSSFont(_ font: WSSFont, with text: String?) {
        self.applyFontAttribute(text: text,
                                lineHeightMultiple: font.lineHeightMultiple,
                                kerningPixel: font.kerningPixel,
                                font: font.font)
    }
    
    func applyFontAttribute(text: String?, lineHeightMultiple: CGFloat, kerningPixel: Double, font: UIFont) {
        self.font = font
        guard let text = text, !text.isEmpty else {
            self.attributedText = nil
            return
        }
        
        let attributedString = NSMutableAttributedString(string: text, attributes: [
            .font: font,
            .kern: kerningPixel
        ])
        
        let textViewAttributeSet = TextViewAttributeSet(textView: self, attributedString: attributedString)
            .lineHeight(lineHeightMultiple)
            .kerning(kerningPixel: kerningPixel)
        
        textViewAttributeSet.applyAttribute()
    }
}

struct TextViewAttributeSet {
    var textView: UITextView
    var attributedString: NSMutableAttributedString

    init(textView: UITextView, attributedString: NSMutableAttributedString) {
        self.textView = textView
        self.attributedString = attributedString
    }
}

extension TextViewAttributeSet {
    func lineSpacing(spacingPercentage: Double) -> TextViewAttributeSet {
        let spacing = (self.textView.font!.pointSize * CGFloat(spacingPercentage / 100) - self.textView.font!.pointSize) / 2
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        let range = NSRange(location: 0, length: attributedString.length)
        self.attributedString.addAttribute(.paragraphStyle, value: style, range: range)
        
        return self
    }
    
    func lineHeight(_ multiple: CGFloat) -> TextViewAttributeSet {
        let lineHeight = self.textView.font!.pointSize * multiple
        
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        
        let range = NSRange(location: 0, length: attributedString.length)
        self.attributedString.addAttribute(.paragraphStyle, value: style, range: range)
        
        self.attributedString.addAttribute(.baselineOffset, value: (lineHeight - self.textView.font!.lineHeight) / 2, range: range)
        
        return self
    }
    
    func kerning(kerningPixel: Double) -> TextViewAttributeSet {
        let range = NSRange(location: 0, length: attributedString.length)
        self.attributedString.addAttribute(.kern, value: kerningPixel, range: range)
        
        return self
    }
    
    func applyAttribute() {
        self.textView.attributedText = self.attributedString
    }
}
