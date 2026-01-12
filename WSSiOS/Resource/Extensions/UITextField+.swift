//
//  UITextField+.swift
//  WSSiOS
//
//  Created by 신지원 on 7/26/24.
//

import UIKit

extension UITextField {
    func applyWSSFont(_ font: WSSFont, with text: String?) {
        self.applyFontAttribute(text: text,
                                lineHeightMultiple: font.lineHeightMultiple,
                                kerningPixel: font.kerningPixel,
                                font: font.font)
    }
    
    func applyFontAttribute(text: String?, lineHeightMultiple: CGFloat, kerningPixel: Double, font: UIFont) {
        self.font = font
        let textFieldAttributeSet = self.makeAttribute(with: text)
            .lineHeight(lineHeightMultiple)
            .kerning(kerningPixel: kerningPixel)
        textFieldAttributeSet.applyAttribute()
    }
    
    func makeAttribute(with text: String?) -> TextFieldAttributeSet {
        guard let text = text, !text.isEmpty else {
            return TextFieldAttributeSet(textField: self, attributedString: NSMutableAttributedString(string: ""))
        }
        
        let textFieldAttributeSet = TextFieldAttributeSet(
            textField: self,
            attributedString: NSMutableAttributedString(string: text)
        )
        
        return textFieldAttributeSet
    }
}

struct TextFieldAttributeSet {
    var textField: UITextField
    var attributedString: NSMutableAttributedString
    
    init(textField: UITextField, attributedString: NSMutableAttributedString) {
        self.textField = textField
        self.attributedString = attributedString
    }
}

extension TextFieldAttributeSet {
    func lineSpacing(spacingPercentage: Double) -> TextFieldAttributeSet {
        let spacing = (self.textField.font!.pointSize * CGFloat(spacingPercentage/100) - self.textField.font!.pointSize)/2
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        let range = NSRange(location: 0, length: attributedString.length)
        self.attributedString.addAttribute(
            .paragraphStyle,
            value: style,
            range: range
        )
        
        return self
    }
    
    func lineHeight(_ multiple: CGFloat) -> TextFieldAttributeSet {
        let lineHeight = self.textField.font!.pointSize * multiple
        
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        
        let range = NSRange(location: 0, length: attributedString.length)
        self.attributedString.addAttribute(
            .paragraphStyle,
            value: style,
            range: range
        )
        
        self.attributedString.addAttribute(
            .baselineOffset,
            value: (lineHeight - self.textField.font!.lineHeight) / 2,
            range: range
        )
        
        return self
    }
    
    func kerning(kerningPixel: Double) -> TextFieldAttributeSet {
        let range = NSRange(location: 0, length: attributedString.length)
        self.attributedString.addAttribute(
            .kern,
            value: kerningPixel,
            range: range
        )
        
        return self
    }
    
    func applyAttribute() {
        self.textField.attributedText = self.attributedString
    }
}
