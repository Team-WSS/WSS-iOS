//
//  NovelDetailViewController.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/11/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture
import Then

final class NovelDetailViewController: UIViewController {
    
    //MARK: - Properties

    private let novelDetailViewModel: NovelDetailViewModel
    private let disposeBag = DisposeBag()
    
    private let viewWillAppearEvent = BehaviorRelay<Int>(value: 0)
    private let userNovelDetail = BehaviorRelay<UserNovelDetail?>(value: nil)
    private let userNovelId: Int
    
    //MARK: - Components

    private let rootView = NovelDetailView()
    private let backButton = UIButton()
    private let novelSettingButton = UIButton()
    
    //MARK: - Life Cycle
    
    init(viewModel: NovelDetailViewModel, userNovelId: Int) {
        self.novelDetailViewModel = viewModel
        self.userNovelId = userNovelId
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
        
        hideTabBar()
        
        viewWillAppearEvent.accept(self.userNovelId)
        updateNavigationBarStyle(offset: self.rootView.scrollView.contentOffset.y)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNavigationBar()
        setNotificationCenter()
        register()
        delegate()
        bindViewModel()
        bindNavigation()
    }
    
    //MARK: - UI
    
    private func setUI() {
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        novelSettingButton.do {
            $0.setImage(.icMeatballMemo.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    private func setNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.novelSettingButton)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.Title2,
            NSAttributedString.Key.foregroundColor: UIColor.wssBlack
        ]
    }
    
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.postedMemo(_:)),
            name: NSNotification.Name("PostedMemo"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.deletedMemo(_:)),
            name: NSNotification.Name("DeletedMemo"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.avatarUnlocked(_:)),
            name: NSNotification.Name("AvatarUnlocked"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.deletedNovel(_:)),
            name: NSNotification.Name("DeletedNovel"),
            object: nil
        )
    }
    
    //MARK: - Bind

    private func register() {
        rootView.novelDetailMemoView.memoTableView.register(
            NovelDetailMemoTableViewCell.self,
            forCellReuseIdentifier: NovelDetailMemoTableViewCell.cellIdentifier
        )
        rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformCollectionView.register(
            NovelDetailInfoPlatformCollectionViewCell.self,
            forCellWithReuseIdentifier: NovelDetailInfoPlatformCollectionViewCell.cellIdentifier
        )
    }
    
    private func delegate() {
        rootView.novelDetailMemoView.memoTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = NovelDetailViewModel.Input(
            viewWillAppearEvent: viewWillAppearEvent.asObservable(),
            scrollViewContentOffset: rootView.scrollView.rx.contentOffset.asDriver(),
            memoTableViewContentSize: rootView.novelDetailMemoView.memoTableView.rx.observe(CGSize.self, "contentSize"),
            platformCollectionViewContentSize: rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformCollectionView.rx.observe(CGSize.self, "contentSize"),
            novelSettingButtonDidTapEvent: novelSettingButton.rx.tap.asObservable(),
            viewDidTapEvent: rootView.novelDetailMemoSettingButtonView.rx.tapGesture().asObservable(),
            memoButtonDidTapEvent: rootView.novelDetailTabView.memoButton.rx.tap.asObservable(),
            infoButtonDidTapEvent: rootView.novelDetailTabView.infoButton.rx.tap.asObservable(),
            stickyMemoButtonDidTapEvent: rootView.stickyNovelDetailTabView.memoButton.rx.tap.asObservable(),
            stickyInfoButtonDidTapEvent: rootView.stickyNovelDetailTabView.infoButton.rx.tap.asObservable(),
            novelDeleteButtonDidTapEvent: rootView.novelDetailMemoSettingButtonView.novelDeleteButton.rx.tap.asObservable(),
            novelEditButtonDidTapEvent: rootView.novelDetailMemoSettingButtonView.novelEditButon.rx.tap.asObservable()
        )
        
        let output = self.novelDetailViewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.userNovelDetail
            .subscribe(with: self, onNext: { owner, data in
                owner.bindData(data)
            })
            .disposed(by: disposeBag)
        
        output.memoList.bind(to: rootView.novelDetailMemoView.memoTableView.rx.items(
            cellIdentifier: NovelDetailMemoTableViewCell.cellIdentifier,
            cellType: NovelDetailMemoTableViewCell.self)) { row, element, cell in
                cell.selectionStyle = .none
                cell.bindData(memo: element)
            }
            .disposed(by: disposeBag)
        
        output.platformList.bind(to: rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformCollectionView.rx.items(
            cellIdentifier: NovelDetailInfoPlatformCollectionViewCell.cellIdentifier,
            cellType: NovelDetailInfoPlatformCollectionViewCell.self)) { item, element, cell in
                cell.bindData(platform: element.platformName)
            }
            .disposed(by: disposeBag)
        
        output.contentOffsetY
            .subscribe(with: self, onNext: { owner, offset in
                owner.updateNavigationBarStyle(offset: offset)
            })
            .disposed(by: disposeBag)
        
        output.memoTableViewHeight
            .subscribe(with: self, onNext: { owner, height in
                owner.rootView.novelDetailMemoView.updateTableViewHeight(height: height)
            })
            .disposed(by: disposeBag)
        
        output.platformCollectionViewHeight
            .subscribe(with: self, onNext: { owner, height in
                owner.rootView.novelDetailInfoView.novelDetailInfoPlatformView.updateCollectionViewHeight(height: height)
            })
            .disposed(by: disposeBag)
        
        output.memoSettingButtonViewIsHidden
            .subscribe(with: self, onNext: { owner, isHidden in
                owner.rootView.novelDetailMemoSettingButtonView.isHidden = isHidden
            })
            .disposed(by: disposeBag)
        
        output.selectedMenu
            .subscribe(with: self, onNext: { owner, selectedMenu in
                switch selectedMenu {
                case .memo:
                    owner.rootView.createMemoButton.isHidden = false
                    owner.rootView.changeCurrentMenu(menu: .memo)
                case .info:
                    owner.rootView.createMemoButton.isHidden = true
                    owner.rootView.changeCurrentMenu(menu: .info)
                }
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Actions
    
    private func bindNavigation() {
        backButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.novelDetailMemoView.novelDetailCreateMemoView.rx.tapGesture()
            .when(.recognized)
            .subscribe(with: self, onNext: { owner, _ in
                owner.pushToMemoEditViewController(
                    userNovelId: owner.userNovelId,
                    novelTitle: owner.userNovelDetail.value?.userNovelTitle ?? "",
                    novelAuthor: owner.userNovelDetail.value?.userNovelAuthor ?? "",
                    novelImage: owner.userNovelDetail.value?.userNovelImg ?? ""
                )
            })
            .disposed(by: disposeBag)
        
        rootView.novelDetailMemoView.memoTableView.rx.itemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.pushToMemoReadViewController(memoId: owner.userNovelDetail.value?.memos[indexPath.row].memoId ?? 0)
            })
            .disposed(by: disposeBag)
        
        rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformCollectionView.rx.itemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                if let url = URL(string: owner.userNovelDetail.value?.platforms[indexPath.item].platformUrl ?? "") {
                    UIApplication.shared.open(url, options: [:])
                }
            })
            .disposed(by: disposeBag)
        
        rootView.novelDetailMemoSettingButtonView.novelDeleteButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.presentDeleteUserNovelViewController(userNovelId: owner.userNovelId)
            })
            .disposed(by: disposeBag)
        
        rootView.novelDetailMemoSettingButtonView.novelEditButon.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.pushToRegisterNormalViewController(novelId: owner.userNovelDetail.value?.novelId ?? 0)
            })
            .disposed(by: disposeBag)
        
        rootView.createMemoButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.pushToMemoEditViewController(
                    userNovelId: owner.userNovelId,
                    novelTitle: owner.userNovelDetail.value?.userNovelTitle ?? "",
                    novelAuthor: owner.userNovelDetail.value?.userNovelAuthor ?? "",
                    novelImage: owner.userNovelDetail.value?.userNovelImg ?? ""
                )
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Custom Method
    
    private func bindData(_ novelData: UserNovelDetail) {
        self.userNovelDetail.accept(novelData)
        
        self.rootView.novelDetailHeaderView.bindData(
            title: novelData.userNovelTitle,
            author: novelData.userNovelAuthor,
            novelImage: novelData.userNovelImg,
            genreImage: novelData.userNovelGenreBadgeImg
        )
        self.rootView.novelDetailMemoView.bindData(
            memoCount: novelData.memos.count
        )
        self.rootView.novelDetailInfoView.bindData(
            rating: novelData.userNovelRating,
            readStatus: novelData.userNovelReadStatus,
            startDate: novelData.userNovelReadStartDate,
            endDate: novelData.userNovelReadEndDate,
            description: novelData.userNovelDescription,
            genre: novelData.userNovelGenre,
            platformCount: novelData.platforms.count
        )
    }
    
    private func updateNavigationBarStyle(offset: CGFloat) {
        if offset > rootView.novelDetailHeaderView.frame.size.height - view.safeAreaInsets.top {
            rootView.stickyNovelDetailTabView.isHidden = false
        } else {
            rootView.stickyNovelDetailTabView.isHidden = true
        }
        if offset > 0 {
            rootView.statusBarView.backgroundColor = .wssWhite
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.backgroundColor = .wssWhite
            navigationItem.title = self.userNovelDetail.value?.userNovelTitle ?? ""
            novelSettingButton.isHidden = true
        } else {
            rootView.statusBarView.backgroundColor = .clear
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.shadowImage = nil
            navigationController?.navigationBar.backgroundColor = .clear
            navigationItem.title = ""
            novelSettingButton.isHidden = false
        }
    }
    
    @objc func postedMemo(_ notification: Notification) {
        showToast(.memoSaveSuccess)
    }
    
    @objc func deletedMemo(_ notification: Notification) {
        showToast(.memoDelete)
    }
    
    @objc func avatarUnlocked(_ notification: Notification) {
        showToast(.avatarUnlock)
    }
    
    @objc func deletedNovel(_ notification: Notification) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NovelDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var text: String?
        
        text = self.userNovelDetail.value?.platforms[indexPath.item].platformName
        
        guard let unwrappedText = text else {
            return CGSize(width: 0, height: 0)
        }
        
        let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 48
        return CGSize(width: width, height: 37)
    }
}
