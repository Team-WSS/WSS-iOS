//
//  UILabel+.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/10/24.
//

import UIKit

extension UILabel {
    func setLineSpacingAndKerning(spacingPercentage: Double, kerningPixel: Double) {
        let kerning = kerningPixel
        let spacing = (self.font.pointSize * CGFloat(spacingPercentage/100) - self.font.pointSize)/2
        guard let text = text, !text.isEmpty else { return }
        
        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        attributeString.addAttribute(
            .paragraphStyle,
            value: style,
            range: NSRange(location: 0, length: attributeString.length)
        )
        
        attributeString.addAttribute(
            .kern,
            value: kerning,
            range: NSRange(location: 0, length: attributeString.length - 1))
        
        attributedText = attributeString
    }
    func makeAttribute() -> TextAttributeSet? {
        guard let text = text, !text.isEmpty else { return nil }
        
        let textAttributeSet = TextAttributeSet(
            label: self,
            attributeString: NSMutableAttributedString(string: text)
        )
        
        return textAttributeSet
    }
    
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
        let spacing = (self.label.font.pointSize * CGFloat(spacingPercentage/100) - self.label.font.pointSize)/2
        
        let style = NSMutableParagraphStyle().then { $0.lineSpacing = spacing }
        self.attributedString.addAttribute(
            .paragraphStyle,
            value: style,
            range: NSRange(location: 0, length: attributedString.length)
        )
        
        return self
    }
    
    func kerning(kerningPixel: Double) -> TextAttributeSet {
        self.attributedString.addAttribute(
            .kern,
            value: kerningPixel,
            range: NSRange(location: 0, length: attributedString.length - 1)
        )
        
        return self
    }
    
    func partialColor(color: UIColor, rangeString: String) -> TextAttributeSet {
        self.attributedString.addAttribute(
            .foregroundColor,
            value: color,
            range: ((self.label.text ?? "") as NSString).range(of: rangeString)
        )
        
        return self
    }
    
    func partialColor(color: UIColor, from: Int, to: Int) -> TextAttributeSet{
        self.attributedString.addAttribute(
            .foregroundColor,
            value: color,
            range: NSRange(location: from, length: to+1-from)
        )
        
        return self
    }
    
//    func textAlignment(_ align: NSTextAlignment) -> TextAttributeSet {
//        self.label.textAlignment = align
//        
//        return self
//    }
//    
//    func lineBreakMode(_ mode: NSLineBreakMode) -> TextAttributeSet {
//        self.label.lineBreakMode = mode
//        
//        return self
//    }
   
        
    func applyAttribute() {
        self.label.attributedText = self.attributedString
    }
}
