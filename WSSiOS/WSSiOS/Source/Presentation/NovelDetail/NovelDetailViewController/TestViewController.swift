//
//  TestViewController.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/27/24.
//

import UIKit

import Kingfisher
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Then

/// Detail View
final class TestViewController: UIViewController {
    
    //MARK: - Properties
    
    let button = UIButton().then {
        $0.setTitle("Next", for: .normal)
    }
    
    let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    //MARK: - Life Cycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        button.rx.tap.bind {
            self.pushToDetailViewController(novelId: 5)
        }.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: - UI
    
    private func setUI() {
       
    }
    
    private func setNavigationBar() {
        
    }
}
