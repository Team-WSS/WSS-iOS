//
//  NovelDateSelectModalViewController.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/21/24.
//

import UIKit

import RxSwift
import RxCocoa

final class NovelDateSelectModalViewController: UIViewController {
    
    //MARK: - Properties
    
    private let novelDateSelectModalViewModel: NovelDateSelectModalViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    //MARK: - Life Cycle
    
    init(viewModel: NovelDateSelectModalViewModel) {
        self.novelDateSelectModalViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - UI
    
    //MARK: - Bind
    
    private func bindViewModle() {
        let input = NovelDateSelectModalViewModel.Input()
        
        let outptu = self.novelDateSelectModalViewModel.transform(from: input, disposeBag: self.disposeBag)
    }
}
