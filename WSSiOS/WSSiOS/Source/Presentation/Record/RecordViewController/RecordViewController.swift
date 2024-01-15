//
//  RecordViewController.swift
//  WSSiOS
//
//  Created by 최서연 on 1/12/24.
//

import UIKit

import RxSwift

final class RecordViewController: UIViewController {
    
    //MARK: - Properties
    
    private let recordViewModel: RecordViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private let rootView = RecordResultView()
    
    init(recordViewModel: RecordViewModel) {
        self.recordViewModel = recordViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNavigationBar()
        
        bindRecordViewModel()
    }
    
    private func setUI() {
        self.view.do {
            $0.backgroundColor = .White
        }
    }
    
    private func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.title = "내 기록"
        
        // Navigation Bar의 title 폰트 설정
        if let navigationBar = self.navigationController?.navigationBar {
            let titleTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.Title2
            ]
            navigationBar.titleTextAttributes = titleTextAttributes
        }
    }
    
    private func bindRecordViewModel() {
        self.recordViewModel.transform(disposeBag: disposeBag)
    }
}
