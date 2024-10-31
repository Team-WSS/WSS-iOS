//
//  SearchViewController.swift
//  WSSiOS
//
//  Created by 최서연 on 1/6/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

final class SearchViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: SearchViewModel
    private let disposeBag = DisposeBag()
    
    private var isLoggedIn: Bool
    
    //MARK: - Components
    
    private let rootView = SearchView()
    
    //MARK: - Life Cycle
    
    init(viewModel: SearchViewModel, isLoggedIn: Bool) {
        self.viewModel = viewModel
        self.isLoggedIn = isLoggedIn
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showTabBar()
        setNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        registerCell()
        
        bindViewModel()
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.view.backgroundColor = .wssWhite
    }
    
    private func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Bind
    
    private func registerCell() {
        rootView.sosopickView.sosopickCollectionView.register(
            SosoPickCollectionViewCell.self,
            forCellWithReuseIdentifier: SosoPickCollectionViewCell.cellIdentifier)
    }
    
    private func bindViewModel() {
        let input = SearchViewModel.Input(
            searhBarDidTap: rootView.searchbarView.rx.tapGesture().when(.recognized).asObservable(),
            induceButtonDidTap: rootView.searchDetailInduceView.rx.tapGesture().when(.recognized).asObservable(),
            sosoPickCellSelected: rootView.sosopickView.sosopickCollectionView.rx.itemSelected.asObservable(),
            induceModalViewLoginButtonDidtap: rootView.induceLoginModalView.loginButton.rx.tap,
            induceModalViewCancelButtonDidtap: rootView.induceLoginModalView.cancelButton.rx.tap
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.sosoPickList
            .bind(to: rootView.sosopickView.sosopickCollectionView.rx.items(
                cellIdentifier: SosoPickCollectionViewCell.cellIdentifier,
                cellType: SosoPickCollectionViewCell.self)) { row, element, cell in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        output.pushToNormalSearchViewController
            .bind(with: self, onNext: { owner, _ in
                owner.pushToNormalSearchViewController(isLoggedIn: owner.isLoggedIn)
            })
            .disposed(by: disposeBag)
        
        output.pushToDetailSearchViewController
            .bind(with: self, onNext: { owner, _ in
                let detailSearchViewController = DetailSearchViewController(viewModel: DetailSearchViewModel(keywordRepository: DefaultKeywordRepository(keywordService: DefaultKeywordService()), selectedKeywordList: []))
                detailSearchViewController.navigationController?.isNavigationBarHidden = false
                detailSearchViewController.hidesBottomBarWhenPushed = true
                owner.presentModalViewController(detailSearchViewController)
            })
            .disposed(by: disposeBag)
        
        output.pushToNovelDetailViewController
            .withLatestFrom(output.sosoPickList) { indexPath, sosoPickList in
                sosoPickList[indexPath.row].novelId
            }
            .bind(with: self, onNext: { owner, novelId in
                owner.pushToDetailViewController(novelId: novelId)
            })
            .disposed(by: disposeBag)
        
        output.showInduceLoginModalView
            .bind(with: self, onNext: { owner, show in
                owner.rootView.induceLoginModalView.isHidden = !show
            })
            .disposed(by: disposeBag)
        
        output.pushToLoginViewController
            .bind(with: self, onNext: { owner, _ in
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                    return
                }
                sceneDelegate.setRootToLoginViewController()
            })
            .disposed(by: disposeBag)
    }
}
