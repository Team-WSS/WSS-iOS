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
    
    //MARK: - set Properties
    
    private let userNovelDetail = BehaviorRelay<UserNovelDetail?>(value: nil)
    
    private let repository: UserNovelRepository
    private let disposeBag = DisposeBag()
    private var selectedMenu = BehaviorSubject<Int>(value: 0)
    private let memoTableViewHeight = BehaviorSubject<CGFloat>(value: 0)
    private let keywordCollectionViewHeight = BehaviorSubject<CGFloat>(value: 0)
    private let platformCollectionViewHeight = BehaviorSubject<CGFloat>(value: 0)
    
    // MARK: - UI Components
    
    private let rootView = NovelDetailView()
    
    // MARK: - Life Cycle
    
    init(repository: UserNovelRepository) {
        self.repository = repository
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
        
        getUserNovel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
        delegate()
        bind()
    }
    
    // MARK: - register

    private func register() {
        rootView.novelDetailMemoView.memoTableView.register(NovelDetailMemoTableViewCell.self, forCellReuseIdentifier: "NovelDetailMemoTableViewCell")
        rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformCollectionView.register(NovelDetailInfoPlatformCollectionViewCell.self, forCellWithReuseIdentifier: "NovelDetailInfoPlatformCollectionViewCell")
    }
    
    // MARK: - delegate
    
    private func delegate() {
        rootView.novelDetailMemoView.memoTableView.dataSource = self
        rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformCollectionView.dataSource = self
        rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformCollectionView.delegate = self
    }
    
    // MARK: - bind
    
    private func bind() {
        selectedMenu
            .subscribe(onNext: { selectedMenu in
                if selectedMenu == 0 {
                    self.rootView.createMemoButton.isHidden = false
                } else {
                    self.rootView.createMemoButton.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        rootView.novelDetailTabView.memoButton.rx.tap.bind {
            self.selectedMenu.onNext(0)
            self.rootView.memoButtonDidTap()
        }.disposed(by: disposeBag)
        
        rootView.novelDetailTabView.infoButton.rx.tap.bind {
            self.selectedMenu.onNext(1)
            self.rootView.infoButtonDidTap()
        }.disposed(by: disposeBag)
        
        rootView.novelDetailMemoView.memoTableView.rx.observe(CGSize.self, "contentSize")
            .map { $0?.height ?? 0 }
            .bind(to: memoTableViewHeight)
            .disposed(by: disposeBag)

        memoTableViewHeight
            .subscribe(onNext: { height in
                self.rootView.novelDetailMemoView.updateTableViewHeight(height: height)
            })
            .disposed(by: disposeBag)
        
        rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformCollectionView.rx.observe(CGSize.self, "contentSize")
            .map { $0?.height ?? 0 }
            .bind(to: platformCollectionViewHeight)
            .disposed(by: disposeBag)
        
        platformCollectionViewHeight
            .subscribe(onNext: { height in
                self.rootView.novelDetailInfoView.novelDetailInfoPlatformView.updateCollectionViewHeight(height: height)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - update UI

    private func updateUI(_ novelData: UserNovelDetail) {
        DispatchQueue.main.async {
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
    }
    
    // MARK: - API request
    
    private func getUserNovel() {
        repository.getUserNovel(userNovelId: 2)
            .subscribe(with: self, onNext: { owner, data in
                self.updateUI(data)
            },onError: { owner, error in
                print(error)
            }).disposed(by: disposeBag)
    }
}

extension NovelDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rootView.novelDetailMemoView.memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NovelDetailMemoTableViewCell.identifier,
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

extension NovelDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NovelDetailInfoPlatformCollectionViewCell.identifier,
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
