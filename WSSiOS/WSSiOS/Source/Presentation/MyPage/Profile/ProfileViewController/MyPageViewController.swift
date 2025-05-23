//
//  MyPageViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 7/9/24.
//

import UIKit

import RxSwift
import RxCocoa

final class MyPageViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: MyPageViewModel
    private let viewWillAppearEvent = PublishSubject<Void>()
    private let headerViewHeightRelay = BehaviorRelay<Double>(value: 0)
    
    //MARK: - UI Components
    
    private var rootView = MyPageView()
    
    // MARK: - Life Cycle
    
    init(viewModel: MyPageViewModel) {
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
        
        delegate()
        register()
        bindViewModel()
        AmplitudeManager.shared.track(AmplitudeEvent.MyPage.mypage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewWillAppearEvent.onNext(())
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        setWSSNavigationBar(title: StringLiterals.Navigation.Title.myPage,
                            left: nil,
                            right: rootView.settingButton,
                            isVisibleBeforeScroll: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerViewHeightRelay.accept(rootView.myPageProfileView.layer.bounds.height)
    }
    
    //MARK: - Bind
    
    private func register() {
        rootView.myPagePreferencesView.myPageNovelPreferencesView.preferencesCollectionView.register(
            UserPageNovelPreferencesCollectionViewCell.self,
            forCellWithReuseIdentifier: UserPageNovelPreferencesCollectionViewCell.cellIdentifier)
        
        rootView.myPagePreferencesView.myPageGenrePreferencesView.userPageOtherGenreView.genreTableView
            .register(UserPageGenrePreferencesOtherTableViewCell.self,
                      forCellReuseIdentifier: UserPageGenrePreferencesOtherTableViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.scrollView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        rootView.myPagePreferencesView.myPageNovelPreferencesView.preferencesCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        rootView.myPagePreferencesView.myPageGenrePreferencesView.userPageOtherGenreView.genreTableView.delegate = self
    }
    
    private func bindViewModel() {
        let inventoryStatusButtonDidTap = Observable<Int>.merge(
            rootView.myPageLibraryStatusView.readStatusButtons.enumerated().map { index, button in
                button.rx.tap
                    .map { index }
            })
        
        let genrePreferenceButtonDidTap = Observable.merge(
            rootView.myPagePreferencesView.myPageGenrePreferencesView.userPageGenreOpenButton.rx.tap.map { true },
            rootView.myPagePreferencesView.myPageGenrePreferencesView.userPageGenreCloseButton.rx.tap.map { false }
        )
        
        let input = MyPageViewModel.Input(
            viewWillAppearEvent: self.viewWillAppearEvent,
            headerViewHeight: headerViewHeightRelay.asDriver(),
            resizeKeywordCollectionViewHeight: rootView.myPagePreferencesView.myPageNovelPreferencesView.preferencesCollectionView.rx.observe(CGSize.self, "contentSize"),
            scrollOffset: rootView.scrollView.rx.contentOffset.asDriver(),
            settingButtonDidTap: rootView.settingButton.rx.tap,
            editButtonDidTap: rootView.myPageProfileView.userImageChangeImageView.rx.tapGesture().when(.recognized).asObservable(),
            genrePreferenceButtonDidTap: genrePreferenceButtonDidTap,
            inventorySpecificPageViewDidTap: inventoryStatusButtonDidTap,
            editProfileNotification: NotificationCenter.default.rx.notification(NotificationName.editProfile).asObservable())
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.profileData
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, data in
                owner.rootView.myPageProfileView.bindData(data: data)
            })
            .disposed(by: disposeBag)
        
        output.pushToSettingViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.pushToSettingViewController()
            })
            .disposed(by: disposeBag)
        
        output.pushToEditViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, data in
                owner.pushToMyPageEditViewController(entryType: .myPage, profile: data)
            })
            .disposed(by: disposeBag)
        
        output.bindGenreData
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] data in
                self?.rootView.myPagePreferencesView.bindData(genreTotalCountText: data.genreTotalCount)
                self?.rootView.myPagePreferencesView.myPageGenrePreferencesView.bindData(data: data)
            })
            .map { Array($0.genrePreferences.dropFirst(3)) }
            .bind(to: rootView.myPagePreferencesView.myPageGenrePreferencesView.userPageOtherGenreView.genreTableView.rx.items(
                cellIdentifier: UserPageGenrePreferencesOtherTableViewCell.cellIdentifier,
                cellType: UserPageGenrePreferencesOtherTableViewCell.self)) { row, data, cell in
                    cell.bindData(data: data)
                    cell.selectionStyle = .none
                }
                .disposed(by: disposeBag)
        
        output.bindAttractivePointsData
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, data in
                owner.rootView.myPagePreferencesView.myPageNovelPreferencesView.bindPreferencesDetailData(data: data)
            })
            .disposed(by: disposeBag)
        
        output.isExistPreferneces
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, isExist in
                //TODO: emptyView 채우기
            })
            .disposed(by: disposeBag)
        
        output.bindKeywordCell
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.myPagePreferencesView.myPageNovelPreferencesView.preferencesCollectionView.rx.items(cellIdentifier: UserPageNovelPreferencesCollectionViewCell.cellIdentifier, cellType: UserPageNovelPreferencesCollectionViewCell.self)){ row, data, cell in
                cell.bindData(data: data)
            }
            .disposed(by: disposeBag)
        
        output.bindInventoryData
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, data in
                owner.rootView.myPageLibraryStatusView.bindData(data: data)
            })
            .disposed(by: disposeBag)
        
        output.showGenreOtherView
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, show in
                owner.rootView.myPagePreferencesView.myPageGenrePreferencesView.updateView(showOtherGenreView: show)
                owner.rootView.myPagePreferencesView.myPageGenrePreferencesView.updateGenreViewHeight(isExpanded: show)
                owner.rootView.myPagePreferencesView.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        output.pushToSpecificLibraryViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, pageIndex in
                NotificationCenter.default.post(name: NotificationName.moveToLibraryTab, object: pageIndex)
            })
            .disposed(by: disposeBag)
        
        output.updateKeywordCollectionViewHeight
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, height in
                owner.rootView.myPagePreferencesView.myPageNovelPreferencesView.updateKeywordViewHeight(height: height)
            })
            .disposed(by: disposeBag)
        
        output.showToastView
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.showToast(.editUserProfile)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Custom Method
    
    func scrollToTop() {
        self.rootView.scrollView.setContentOffset(CGPoint(x: 0, y: -self.rootView.scrollView.contentInset.top), animated: true)
    }
}

//MARK: - UIScroll 관련 Delegate

extension MyPageViewController: UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITableViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let keywords = viewModel.bindKeywordRelay.value
        guard indexPath.row < keywords.count else {
            return CGSize(width: 0, height: 0)
        }
        let keyword = keywords[indexPath.row]
        let text = "\(keyword.keywordName) \(keyword.keywordCount)"
        
        
        let width = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 24
        return CGSize(width: width, height: 37)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
}
