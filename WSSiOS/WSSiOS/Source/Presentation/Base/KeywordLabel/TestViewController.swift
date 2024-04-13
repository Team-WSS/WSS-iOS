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
        
        rootView.keywordTag.setText("내맘대로 텍스트 바꾸깅~")
        rootView.keywordTag.tapEvent.bind {
            print("이렇게 탭 했을 때 작업 넣기~")
        }
        .disposed(by: disposeBag)
    }
}
