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
        self.do {
            $0.font = font
            $0.makeAttribute(with: text)?
                .lineHeight(lineHeightMultiple)
                .kerning(kerningPixel: kerningPixel)
                .applyAttribute()
        }
    }
    
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
    
    func lineHeight(_ multiple: CGFloat) -> TextViewAttributeSet {
        let lineHeight = self.textView.font!.pointSize * multiple
        
        let style = NSMutableParagraphStyle().then {
            $0.maximumLineHeight = lineHeight
            $0.minimumLineHeight = lineHeight
        }
        
        self.attributedString.addAttribute(
            .paragraphStyle,
            value: style,
            range: NSRange(location: 0, length: attributedString.length)
        )
        
        self.attributedString.addAttribute(
            .baselineOffset,
            value: (lineHeight - self.textView.font!.lineHeight) / 2,
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
