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
    
    func fontHeadline1Attribute(with text: String) {
        self.do {
            $0.makeAttribute(with: text)?
                .lineHeight(1.4)
                .kerning(kerningPixel: -1.2)
                .applyAttribute()
            $0.font = .HeadLine1
        }
    }
    
    func fontTitle1Attribute(with text: String) {
        self.do {
            $0.makeAttribute(with: text)?
                .lineHeight(1.4)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.font = .Title1
        }
    }
    
    func fontTitle2Attribute(with text: String) {
        self.do {
            $0.makeAttribute(with: text)?
                .lineHeight(1.4)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.font = .Title2
        }
    }
    
    func fontTitle3Attribute(with text: String) {
        self.do {
            $0.makeAttribute(with: text)?
                .lineHeight(1.5)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.font = .Title3
        }
    }
    
    func fontBody1Attribute(with text: String) {
        self.do {
            $0.makeAttribute(with: text)?
                .lineHeight(1.4)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.font = .Body1
        }
    }
    
    func fontBody2Attribute(with text: String) {
        self.do {
            $0.makeAttribute(with: text)?
                .lineHeight(1.5)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.font = .Body2
        }
    }
    
    func fontBody3Attribute(with text: String) {
        self.do {
            $0.makeAttribute(with: text)?
                .lineHeight(1.5)
                .kerning(kerningPixel: -0.4)
                .applyAttribute()
            $0.font = .Body3
        }
    }
    
    func fontBody4Attribute(with text: String) {
        self.do {
            $0.makeAttribute(with: text)?
                .lineHeight(1.45)
                .kerning(kerningPixel: -0.4)
                .applyAttribute()
            $0.font = .Body4
        }
    }
    
    func fontBody4_2Attribute(with text: String) {
        self.do {
            $0.makeAttribute(with: text)?
                .lineHeight(1.45)
                .kerning(kerningPixel: -0.4)
                .applyAttribute()
            $0.font = .Body4_2
        }
    }
    
    func fontBody5Attribute(with text: String) {
        self.do {
            $0.makeAttribute(with: text)?
                .lineHeight(1.45)
                .applyAttribute()
            $0.font = .Body5
        }
    }
    
    func fontBody5_2Attribute(with text: String) {
        self.do {
            $0.makeAttribute(with: text)?
                .lineHeight(1.45)
                .applyAttribute()
            $0.font = .Body5_2
        }
    }
    
    func fontLabel1Attribute(with text: String) {
        self.do {
            $0.makeAttribute(with: text)?
                .lineHeight(1.45)
                .kerning(kerningPixel: -0.4)
                .applyAttribute()
            $0.font = .Label1
        }
    }
    
    func fontLabel2Attribute(with text: String) {
        self.do {
            $0.makeAttribute(with: text)?
                .applyAttribute()
            $0.font = .Label2
        }
    }
}

extension UILabel {
    
    /*
     // 아래와 같이 함수를 View에서 만들어 사용하면 됩니다.
     // 단, 반드시 applyAttribute()로 attributedText 조작하는 부분을 마친 후,
     // label.### 으로 수정하는 부분을 작성해야 합니다.
     
     // Text가 바뀔 때 attributedText 설정이 초기화되므로, 재설정을 편하게 하기 위해
     // 추가한 Extension입니다.
     
     private func novelTitleAttribute(of label: UILabel) {
     label.do {
     $0.makeAttribute(with: label.text)?
     .lineSpacing(spacingPercentage: 140)
     .kerning(kerningPixel: -1.2)
     .applyAttribute()
     $0.font = .HeadLine1
     $0.textColor = .White
     $0.textAlignment = .center
     $0.lineBreakMode = .byTruncatingTail
     $0.lineBreakStrategy = .hangulWordPriority
     $0.numberOfLines = 3
     }
     }
     */
    
    
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
        let range = (self.attributedString.string as NSString).range(of: rangeString)
        if range.location != NSNotFound {
            self.attributedString.addAttribute(.foregroundColor, value: color, range: range)
        }
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
    
    func lineHeight(_ multiple: CGFloat) -> TextAttributeSet {
        let lineHeight = self.label.font.pointSize * multiple
        
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
            value: (lineHeight - self.label.font.lineHeight) / 2,
            range: NSRange(location: 0, length: attributedString.length)
        )

        return self
    }
    
    func applyAttribute() {
        self.label.attributedText = self.attributedString
    }
}
