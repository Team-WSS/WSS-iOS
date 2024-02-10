//
//  NovelDetailViewController.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/11/24.
//

import UIKit

import RxSwift
import RxCocoa

final class NovelDetailViewController: UIViewController {
    
    // MARK: - Properties

    private let repository: UserNovelRepository
    private let disposeBag = DisposeBag()
    private let userNovelDetail = BehaviorRelay<UserNovelDetail?>(value: nil)
    private let userNovelId: Int
    private var novelId: Int = 0
    private var novelTitle = ""
    private var novelAuthor = ""
    private var novelImage = ""
    private var selectedMenu = BehaviorSubject<Int>(value: 0)
    private let memoTableViewHeight = BehaviorSubject<CGFloat>(value: 0)
    private let keywordCollectionViewHeight = BehaviorSubject<CGFloat>(value: 0)
    private let platformCollectionViewHeight = BehaviorSubject<CGFloat>(value: 0)
    
    // MARK: - Components

    private let rootView = NovelDetailView()
    private let backButton = UIButton()
    private let novelSettingButton = UIButton()
    
    // MARK: - Life Cycle
    
    init(repository: UserNovelRepository, userNovelId: Int, selectedMenu: Int = 0) {
        self.repository = repository
        self.userNovelId = userNovelId
        self.selectedMenu.onNext(selectedMenu)
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
        
        setNavigationBar()
        setUI()
        setNotificationCenter()
        setTapGesture()
        register()
        delegate()
        setBinding()
    }
    
    // MARK: - UI
    
    private func setNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.novelSettingButton)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.Title2,
            NSAttributedString.Key.foregroundColor: UIColor.wssBlack
        ]
    }
    
    private func setUI() {
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        novelSettingButton.do {
            $0.setImage(.icMeatballMemo.withRenderingMode(.alwaysOriginal), for: .normal)
        }
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
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        self.rootView.novelDetailMemoSettingButtonView.addGestureRecognizer(viewTapGesture)
        
        let memoCreateViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(memoCreateViewDidTap))
        self.rootView.novelDetailMemoView.novelDetailCreateMemoView.addGestureRecognizer(memoCreateViewTapGesture)
    }
    
    // MARK: - Bind

    private func register() {
        rootView.novelDetailMemoView.memoTableView.register(NovelDetailMemoTableViewCell.self, forCellReuseIdentifier: NovelDetailMemoTableViewCell.cellIdentifier)
        rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformCollectionView.register(NovelDetailInfoPlatformCollectionViewCell.self, forCellWithReuseIdentifier: NovelDetailInfoPlatformCollectionViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.novelDetailMemoView.memoTableView.dataSource = self
        rootView.novelDetailMemoView.memoTableView.delegate = self
        rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformCollectionView.dataSource = self
        rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformCollectionView.delegate = self
    }
    
    private func setBinding() {
        rootView.scrollView.rx.contentOffset
            .asDriver()
            .drive(with: self, onNext: { owner, offset in
                owner.updateNavigationBarStyle(offset: offset.y)
            })
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        novelSettingButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.rootView.novelDetailMemoSettingButtonView.isHidden = false
            })
            .disposed(by: disposeBag)
        
        rootView.novelDetailMemoSettingButtonView.novelDeleteButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.rootView.novelDetailMemoSettingButtonView.isHidden = true
                let vc = DeletePopupViewController(
                    userNovelRepository: DefaultUserNovelRepository(
                        userNovelService: DefaultUserNovelService()
                    ),
                    popupStatus: .novelDelete,
                    userNovelId: owner.userNovelId
                )
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                owner.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.novelDetailMemoSettingButtonView.novelEditButon.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.rootView.novelDetailMemoSettingButtonView.isHidden = true
                owner.selectedMenu.onNext(1)
                owner.navigationController?.pushViewController(
                    RegisterNormalViewController(
                        novelRepository: DefaultNovelRepository(
                            novelService: DefaultNovelService()),
                        userNovelRepository: DefaultUserNovelRepository(
                            userNovelService: DefaultUserNovelService()),
                        novelId: owner.novelId),
                    animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.createMemoButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.navigationController?.pushViewController(MemoEditViewController(
                    repository: DefaultMemoRepository(
                        memoService: DefaultMemoService()
                    ),
                    userNovelId: owner.userNovelId,
                    novelTitle: owner.novelTitle,
                    novelAuthor: owner.novelAuthor,
                    novelImage: owner.novelImage
                ), animated: true)
            })
            .disposed(by: disposeBag)
        
        selectedMenu
            .subscribe(with: self, onNext: { owner, selectedMenu in
                if selectedMenu == 0 {
                    owner.rootView.createMemoButton.isHidden = false
                    owner.rootView.changeCurrentMenu(menu: 0)
                } else {
                    owner.rootView.createMemoButton.isHidden = true
                    owner.rootView.changeCurrentMenu(menu: 1)
                }
            })
            .disposed(by: disposeBag)
        
        rootView.novelDetailTabView.memoButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.selectedMenu.onNext(0)
            })
            .disposed(by: disposeBag)
        
        rootView.novelDetailTabView.infoButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.selectedMenu.onNext(1)
            })
            .disposed(by: disposeBag)
        
        rootView.stickyNovelDetailTabView.memoButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.selectedMenu.onNext(0)
            })
            .disposed(by: disposeBag)
        
        rootView.stickyNovelDetailTabView.infoButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.selectedMenu.onNext(1)
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
    
    // MARK: - API
    
    private func getUserNovel() {
        repository.getUserNovel(userNovelId: self.userNovelId)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in
                owner.updateUI(data)
            },onError: { owner, error in
                print(error)
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
    private func updateUI(_ novelData: UserNovelDetail) {
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
            memos: novelData.memos
        )
        self.rootView.novelDetailInfoView.bindData(
            rating: novelData.userNovelRating,
            readStatus: novelData.userNovelReadStatus,
            startDate: novelData.userNovelReadStartDate,
            endDate: novelData.userNovelReadEndDate,
            description: novelData.userNovelDescription,
            genre: novelData.userNovelGenre,
            platforms: novelData.platforms
        )
        
        self.rootView.novelDetailMemoView.memoTableView.reloadData()
        self.rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformCollectionView.reloadData()
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
    
    @objc func viewDidTap() {
        self.rootView.novelDetailMemoSettingButtonView.isHidden = true
    }
    
    @objc func memoCreateViewDidTap() {
        self.navigationController?.pushViewController(MemoEditViewController(
            repository: DefaultMemoRepository(
                memoService: DefaultMemoService()
            ),
            userNovelId: self.userNovelId,
            novelTitle: self.novelTitle,
            novelAuthor: self.novelAuthor,
            novelImage: self.novelImage
        ), animated: true)
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

extension NovelDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rootView.novelDetailMemoView.memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NovelDetailMemoTableViewCell.cellIdentifier,
            for: indexPath
        ) as? NovelDetailMemoTableViewCell else {return UITableViewCell()}
        
        cell.selectionStyle = .none
        cell.bindData(
            date: rootView.novelDetailMemoView.memoList[indexPath.row].createdDate,
            content: rootView.novelDetailMemoView.memoList[indexPath.row].memoContent
        )
        return cell
    }
}

extension NovelDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(
            MemoReadViewController(
                repository: DefaultMemoRepository(
                    memoService: DefaultMemoService()),
                memoId: rootView.novelDetailMemoView.memoList[indexPath.row].memoId
            ), animated: true)
    }
}

extension NovelDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NovelDetailInfoPlatformCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? NovelDetailInfoPlatformCollectionViewCell else {return UICollectionViewCell()}
        
        cell.bindData(
            platform: rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformList[indexPath.item].platformName
        )
        
        return cell
    }
}

extension NovelDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformList[indexPath.item].platformUrl) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}

extension NovelDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var text: String?
        
        text = rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformList[indexPath.item].platformName
        
        guard let unwrappedText = text else {
            return CGSize(width: 0, height: 0)
        }
        
        let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 48
        return CGSize(width: width, height: 37)
    }
}
