//
//  TestViewController.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/13/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class TestViewController: UIViewController {

    private var rootView = TestView()
    var disposeBag = DisposeBag()
    
    // MARK: - Life Cycle

    override func loadView() {
        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.keywordLink.setText("내맘대로 텍스트 바꾸깅~")
        rootView.keywordLink.updateColor(true)
    }
}
