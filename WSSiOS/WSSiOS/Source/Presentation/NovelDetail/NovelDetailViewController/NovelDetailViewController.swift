//
//  NovelDetailViewController.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/25/24.
//

import UIKit

import Kingfisher
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Then

/// Detail View
final class NovelDetailViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: NovelDetailViewModel
    private let disposeBag = DisposeBag()
    
    private let viewWillAppearEvent = BehaviorRelay(value: false)
    
    private var navigationTitle: String = ""
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = StringLiterals.Register.Normal.DatePicker.dateFormat
        $0.timeZone = TimeZone(identifier: StringLiterals.Register.Normal.DatePicker.KoreaTimeZone)
    }
    
    //MARK: - Components
    
    private let backButton = UIButton()
    private let dropDownButton = UIButton()
    private let rootView = NovelDetailView()
    
    //MARK: - Life Cycle
    
    init(viewModel: NovelDetailViewModel) {
        self.viewModel = viewModel
        
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
        bindViewModel()
        register()
        delegate()
        swipeBackGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewWillAppearEvent.accept(true)
        setNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: - UI
    
    private func setUI() {
        backButton.do {
            $0.setImage(.icNavigateLeft.withTintColor(.wssWhite,
                                                      renderingMode: .alwaysOriginal),
                        for: .normal)
        }
        
        dropDownButton.do {
            $0.setImage(.icDropDownDot.withTintColor(.wssWhite,
                                                     renderingMode: .alwaysOriginal),
                        for: .normal)
        }
    }
    
    private func setNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.dropDownButton)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.Title2,
            NSAttributedString.Key.foregroundColor: UIColor.wssBlack
        ]
    }
    
    //MARK: - Bind
    
    private func register() {
        
    }
    
    private func delegate() {
        
    }
    
    private func bindViewModel() {
        let input = createViewModelInput()
        let output = viewModel.transform(from: input,
                                         disposeBag: disposeBag)
        bindViewModelOutput(output)
    }
    
    private func bindViewModelOutput(_ output: NovelDetailViewModel.Output) {
        output.detailBasicData
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in
                owner.rootView.bindData(data)
                owner.navigationTitle = data.novelTitle
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        output.scrollContentOffset
            .drive(with: self, onNext: { owner, offset in
                owner.updateNavigationBarStyle(offset: offset.y)
            })
            .disposed(by: disposeBag)
        
        output.showLargeNovelCoverImage
            .drive(with: self, onNext: { owner, isShow in
                owner.showLargeNovelCoverImageView(isShow)
            })
            .disposed(by: disposeBag)
        
        output.backButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Actions
    
    private func createViewModelInput() -> NovelDetailViewModel.Input {
        return NovelDetailViewModel.Input(
            viewWillAppearEvent:  viewWillAppearEvent.asObservable(),
            scrollContentOffset: rootView.scrollView.rx.contentOffset,
            novelCoverImageButtonDidTap: rootView.headerView.novelCoverImageButton.rx.tap,
            largeNovelCoverImageDismissButtonDidTap: rootView.largeNovelCoverImageView.dismissButton.rx.tap,
            backButtonDidTap: backButton.rx.tap
        )
    }
    
    //MARK: - Custom Method
    
    private func showLargeNovelCoverImageView(_ isShow: Bool) {
        rootView.largeNovelCoverImageView.isHidden = !isShow
        self.navigationController?.setNavigationBarHidden(isShow, animated: false)
    }
    
    private func updateNavigationBarStyle(offset: CGFloat) {
        if offset > 0 {
            rootView.statusBarView.backgroundColor = .wssWhite
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.backgroundColor = .wssWhite
            navigationItem.title = self.navigationTitle
        } else {
            rootView.statusBarView.backgroundColor = .clear
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.shadowImage = nil
            navigationController?.navigationBar.backgroundColor = .clear
            navigationItem.title = ""
        }
    }
}
