//
//  NovelKeywordSelectModalViewController.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/17/24.
//

import UIKit

import RxSwift
import RxCocoa

final class NovelKeywordSelectModalViewController: UIViewController {
    
    //MARK: - Properties
    
    private let novelKeywordSelectModalViewModel: NovelKeywordSelectModalViewModel
    private let disposeBag = DisposeBag()
    
    private let viewDidLoadEvent = PublishRelay<Void>()
    
    //MARK: - Components
    
    private let rootView = NovelKeywordSelectModalView()
    
    //MARK: - Life Cycle
    
    init(viewModel: NovelKeywordSelectModalViewModel) {
        self.novelKeywordSelectModalViewModel = viewModel
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
    }
}
