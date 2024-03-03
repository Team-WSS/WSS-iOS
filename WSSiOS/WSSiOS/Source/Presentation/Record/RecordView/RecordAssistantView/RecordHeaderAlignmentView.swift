//
//  RecordHeaderAlignmentView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/12/24.
//

import UIKit

final class RecordHeaderAlignmentButton: UIButton {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.do {
            $0.setTitle(StringLiterals.Alignment.newest.title, for: .normal)
            $0.setTitleColor(.wssGray300, for: .normal)
            $0.titleLabel?.font = .Label1
            $0.titleLabel?.adjustsFontSizeToFitWidth = true
            $0.setImage(.icDropDown, for: .normal)
            $0.semanticContentAttribute = .forceRightToLeft
            $0.configuration?.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 0)
        }
    }
}
