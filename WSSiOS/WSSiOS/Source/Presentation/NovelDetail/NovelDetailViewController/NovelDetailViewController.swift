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

enum SelectedMenu {
    case memo
    case info
}

final class NovelDetailViewController: UIViewController {
    
    //MARK: - Properties

    private let repository: UserNovelRepository
    private let disposeBag = DisposeBag()
    private let userNovelDetail = BehaviorRelay<UserNovelDetail?>(value: nil)
    private let memoList = BehaviorRelay<[UserNovelMemo]>(value: [])
    private let platformList = BehaviorRelay<[UserNovelPlatform]>(value: [])
    private var selectedMenu = BehaviorRelay<SelectedMenu>(value: .memo)
    private let memoTableViewHeight = BehaviorRelay<CGFloat>(value: 0)
    private let keywordCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    private let platformCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    private let userNovelId: Int
    private var novelId: Int = 0
    private var novelTitle = ""
    private var novelAuthor = ""
    private var novelImage = ""
    
    private let novelDetailViewModel = NovelDetailViewModel()
    
    //MARK: - Components

    private let rootView = NovelDetailView()
    private let backButton = UIButton()
    private let novelSettingButton = UIButton()
    
    //MARK: - Life Cycle
    
    init(repository: UserNovelRepository, userNovelId: Int, selectedMenu: SelectedMenu = .memo) {
        self.repository = repository
        self.userNovelId = userNovelId
        self.selectedMenu.accept(selectedMenu)
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
        
        getUserNovel()
        updateNavigationBarStyle(offset: self.rootView.scrollView.contentOffset.y)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNavigationBar()
        setNotificationCenter()
        setTapGesture()
        register()
        delegate()
        bindUI()
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
    
    private func setTapGesture() {
        let memoCreateViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(memoCreateViewDidTap))
        self.rootView.novelDetailMemoView.novelDetailCreateMemoView.addGestureRecognizer(memoCreateViewTapGesture)
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
            novelSettingButtonDidTapEvent: novelSettingButton.rx.tap.asObservable(),
            viewDidTapEvent: rootView.novelDetailMemoSettingButtonView.rx.tapGesture().asObservable(),
            memoButtonDidTapEvent: rootView.novelDetailTabView.memoButton.rx.tap.asObservable(),
            infoButtonDidTapEvent: rootView.novelDetailTabView.infoButton.rx.tap.asObservable(),
            stickyMemoButtonDidTapEvent: rootView.stickyNovelDetailTabView.memoButton.rx.tap.asObservable(),
            stickyInfoButtonDidTapEvent: rootView.stickyNovelDetailTabView.infoButton.rx.tap.asObservable()
        )
        
        let output = self.novelDetailViewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.memoSettingButtonViewIsHidden.subscribe(with: self, onNext: { owner, isHidden in
            owner.rootView.novelDetailMemoSettingButtonView.isHidden = isHidden
        }).disposed(by: disposeBag)
        
        output.selectedMenu.subscribe(with: self, onNext: { owner, selectedMenu in
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
    
    private func bindUI() {
        memoList.bind(to: rootView.novelDetailMemoView.memoTableView.rx.items(
            cellIdentifier: NovelDetailMemoTableViewCell.cellIdentifier,
            cellType: NovelDetailMemoTableViewCell.self)) { row, element, cell in
                cell.selectionStyle = .none
                cell.bindData(memo: element)
            }
            .disposed(by: disposeBag)
        
        platformList.bind(to: rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformCollectionView.rx.items(
            cellIdentifier: NovelDetailInfoPlatformCollectionViewCell.cellIdentifier,
            cellType: NovelDetailInfoPlatformCollectionViewCell.self)) { item, element, cell in
                cell.bindData(platform: element.platformName)
            }
            .disposed(by: disposeBag)
        
        rootView.scrollView.rx.contentOffset
            .asDriver()
            .drive(with: self, onNext: { owner, offset in
                owner.updateNavigationBarStyle(offset: offset.y)
            })
            .disposed(by: disposeBag)
        
        selectedMenu
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
        
        rootView.novelDetailMemoView.memoTableView.rx.observe(CGSize.self, "contentSize")
            .map { $0?.height ?? 0 }
            .bind(to: memoTableViewHeight)
            .disposed(by: disposeBag)

        memoTableViewHeight
            .subscribe(with: self, onNext: { owner, height in
                owner.rootView.novelDetailMemoView.updateTableViewHeight(height: height)
            })
            .disposed(by: disposeBag)
        
        rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformCollectionView.rx.observe(CGSize.self, "contentSize")
            .map { $0?.height ?? 0 }
            .bind(to: platformCollectionViewHeight)
            .disposed(by: disposeBag)
        
        platformCollectionViewHeight
            .subscribe(with: self, onNext: { owner, height in
                owner.rootView.novelDetailInfoView.novelDetailInfoPlatformView.updateCollectionViewHeight(height: height)
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
        
        rootView.novelDetailMemoView.memoTableView.rx.itemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.pushToMemoReadViewController(memoId: owner.memoList.value[indexPath.row].memoId)
            })
            .disposed(by: disposeBag)
        
        rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformCollectionView.rx.itemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                if let url = URL(string: owner.platformList.value[indexPath.item].platformUrl) {
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
                owner.selectedMenu.accept(.info)
                owner.pushToRegisterNormalViewController(novelId: owner.novelId)
            })
            .disposed(by: disposeBag)
        
        rootView.createMemoButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.pushToMemoEditViewController(
                    userNovelId: owner.userNovelId,
                    novelTitle: owner.novelTitle,
                    novelAuthor: owner.novelAuthor,
                    novelImage: owner.novelImage
                )
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - API
    
    private func getUserNovel() {
        repository.getUserNovel(userNovelId: self.userNovelId)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in
                owner.bindData(data)
            },onError: { owner, error in
                print(error)
            }).disposed(by: disposeBag)
    }
    
    //MARK: - Custom Method
    
    private func bindData(_ novelData: UserNovelDetail) {
        self.memoList.accept(novelData.memos)
        self.platformList.accept(novelData.platforms)
        
        self.novelId = novelData.novelId
        self.novelTitle = novelData.userNovelTitle
        self.novelAuthor = novelData.userNovelAuthor
        self.novelImage = novelData.userNovelImg
        
        self.rootView.novelDetailHeaderView.bindData(
            title: novelData.userNovelTitle,
            author: novelData.userNovelAuthor,
            novelImage: novelData.userNovelImg,
            genreImage: novelData.userNovelGenreBadgeImg
        )
        self.rootView.novelDetailMemoView.bindData(
            memoCount: self.memoList.value.count
        )
        self.rootView.novelDetailInfoView.bindData(
            rating: novelData.userNovelRating,
            readStatus: novelData.userNovelReadStatus,
            startDate: novelData.userNovelReadStartDate,
            endDate: novelData.userNovelReadEndDate,
            description: novelData.userNovelDescription,
            genre: novelData.userNovelGenre,
            platformCount: self.platformList.value.count
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
            navigationItem.title = self.novelTitle
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
    
    @objc func memoCreateViewDidTap() {
        self.pushToMemoEditViewController(
            userNovelId: self.userNovelId,
            novelTitle: self.novelTitle,
            novelAuthor: self.novelAuthor,
            novelImage: self.novelImage
        )
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
        
        text = self.platformList.value[indexPath.item].platformName
        
        guard let unwrappedText = text else {
            return CGSize(width: 0, height: 0)
        }
        
        let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 48
        return CGSize(width: width, height: 37)
    }
}
