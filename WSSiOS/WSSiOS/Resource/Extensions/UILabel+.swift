//
//  UILabel+.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/10/24.
//

import UIKit

// Font
extension UILabel {
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
    
    func applyWSSFontWithUnderLine(_ font: WSSFont, with text: String?) {
        self.applyFontAttributeWithUnderline(text: text,
                                             lineHeightMultiple: font.lineHeightMultiple,
                                             kerningPixel: font.kerningPixel,
                                             font: font.font)
    }
    
    func applyFontAttributeWithUnderline(text: String?, lineHeightMultiple: CGFloat, kerningPixel: Double, font: UIFont) {
        self.do {
            $0.font = font
            $0.makeAttribute(with: text)?
                .lineHeight(lineHeightMultiple)
                .kerning(kerningPixel: kerningPixel)
                .underlineStyle(.single)
                .applyAttribute()
        }
    }
}

extension UILabel {
    func makeAttribute(with text: String?) -> TextAttributeSet? {
        guard let text = text, !text.isEmpty else { return nil }
        
        let textAttributeSet = TextAttributeSet(
            label: self,
            attributeString: NSMutableAttributedString(string: text)
        )
        
        return textAttributeSet
    }
}

struct TextAttributeSet {
    var label: UILabel
    var attributedString: NSMutableAttributedString
    
    init(label: UILabel, attributeString: NSMutableAttributedString) {
        self.label = label
        self.attributedString = attributeString
    }
}

extension TextAttributeSet {
    func lineSpacing(spacingPercentage: Double) -> TextAttributeSet {
        let spacing = (self.label.font.pointSize * CGFloat(spacingPercentage / 100) - self.label.font.pointSize) / 2
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        
        let length = self.attributedString.length
        
        self.attributedString.addAttribute(
            .paragraphStyle,
            value: style,
            range: NSRange(location: 0, length: length)
        )
        
        return self
    }
    
    func kerning(kerningPixel: Double) -> TextAttributeSet {
        let length = self.attributedString.length
        
        guard length > 1 else {
            return self
        }
        
        self.attributedString.addAttribute(
            .kern,
            value: kerningPixel,
            range: NSRange(location: 0, length: length)
        )
        
        return self
    }
    
    func underlineStyle(_ style: NSUnderlineStyle) -> TextAttributeSet {
        let length = self.attributedString.length
        
        self.attributedString.addAttribute(
            .underlineStyle,
            value: style.rawValue,
            range: NSRange(location: 0, length: length)
        )
        
        return self
    }
    
    func partialColor(color: UIColor, rangeString: String) -> TextAttributeSet {
        let nsString = self.attributedString.string as NSString
        let range = nsString.range(of: rangeString)
        
        if range.location != NSNotFound {
            self.attributedString.addAttribute(.foregroundColor, value: color, range: range)
        }
        return self
    }
    
    func lineHeight(_ multiple: CGFloat) -> TextAttributeSet {
        let lineHeight = self.label.font.pointSize * multiple
        
        guard lineHeight.isFinite else {
            return self
        }
        
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        
        let length = self.attributedString.length
        
        self.attributedString.addAttribute(
            .paragraphStyle,
            value: style,
            range: NSRange(location: 0, length: length)
        )
        
        self.attributedString.addAttribute(
            .baselineOffset,
            value: (lineHeight - self.label.font.lineHeight) / 2,
            range: NSRange(location: 0, length: length)
        )
        
        return self
    }
    
    func applyAttribute() {
        self.label.attributedText = self.attributedString
    }
}
