//
//  RegisterNormalViewController.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/6/24.
//

import UIKit

import Kingfisher
import RxSwift
import RxCocoa
import SnapKit
import Then

/// 1-3-1 RegisterNormal View
final class RegisterNormalViewController: UIViewController {
    
    // MARK: - Properties
    
    private let novelRepository: NovelRepository
    private let userNovelRepository: UserNovelRepository
    private let novelId: Int
    private var userNovelId: Int
    private var navigationTitle: String = ""
    private let stringToDate = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd"
        $0.timeZone = TimeZone(identifier: "ko_KR")
    }
    
    // RxSwift
    private var isNew = BehaviorRelay<Bool>(value: true)
    private let disposeBag = DisposeBag()
    private var starRating = BehaviorRelay<Float>(value: 0.0)
    private var readStatus = BehaviorRelay<ReadStatus>(value: .FINISH)
    private var isDateExist = BehaviorRelay<Bool>(value: true)
    private var showDatePicker = BehaviorRelay<Bool>(value: false)
    private var startDate = BehaviorRelay<Date>(value: Date())
    private var endDate = BehaviorRelay<Date>(value: Date())
    private let platformCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    
    // MARK: - Components
    
    private let backButton = UIButton()
    private let rootView = RegisterNormalView()
    
    // MARK: - View Life Cycle
    
    init(novelRepository: NovelRepository, userNovelRepository: UserNovelRepository, novelId: Int = 0, userNovelId: Int = 0) {
        self.novelRepository = novelRepository
        self.userNovelRepository = userNovelRepository
        self.novelId = novelId
        self.userNovelId = userNovelId
        
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
        getNovel()
        register()
        bindUI()
        bindActions()
        setNavigationBar()
    }
    
    // MARK: - UI
    
    private func setUI() {
        backButton.do {
            $0.setImage(ImageLiterals.icon.navigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    private func setNavigationBar() {
        rootView.divider.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.Title2,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
    }
    
    //MARK: - Bind
    
    private func register() {
        rootView.novelSummaryView.platformView.platformCollectionView.register(NovelDetailInfoPlatformCollectionViewCell.self, forCellWithReuseIdentifier: "NovelDetailInfoPlatformCollectionViewCell")
        rootView.novelSummaryView.platformView.platformCollectionView.dataSource = self
        rootView.novelSummaryView.platformView.platformCollectionView.delegate = self
    }
    
    private func bindUI() {
        rootView.pageScrollView.rx.contentOffset
            .asDriver()
            .drive(with: self, onNext: { owner, offset in
                owner.updateNavigationBarStyle(offset: offset.y)
            })
            .disposed(by: disposeBag)
        
        starRating
            .asDriver()
            .drive(with: self, onNext: { owner, rating in
                owner.rootView.infoWithRatingView.starRatingView.updateStarImages(rating: rating)
            })
            .disposed(by: disposeBag)
        
        readStatus
            .asDriver()
            .drive(with: self, onNext: { owner, status in
                owner.rootView.readStatusView.updateReadStatusButton(status: status)
                
                if status == .WISH {
                    owner.rootView.readDateView.isHidden = true
                } else {
                    owner.rootView.readDateView.isHidden = false
                    owner.rootView.readDateView.bindData(status)
                }
                
                owner.rootView.customDatePicker.updateDatePicker(status: status)
            })
            .disposed(by: disposeBag)
        
        isDateExist
            .asDriver()
            .drive(with: self, onNext: { owner, isDateExist in
                owner.rootView.readDateView.toggleButton.changeState(isDateExist)
                owner.rootView.readDateView.datePickerButton.isHidden = !isDateExist
            })
            .disposed(by: disposeBag)
        
        showDatePicker
            .asDriver()
            .drive(with: self, onNext: { owner, isShow in
                if isShow {
                    owner.rootView.customDatePicker.startDate = self.startDate.value
                    owner.rootView.customDatePicker.endDate = self.endDate.value
                }
                owner.rootView.customDatePicker.isHidden = !isShow
                
                if owner.rootView.pageScrollView.contentOffset.y == 0 {
                    owner.updateNavigationBarStyle(offset: owner.rootView.pageScrollView.contentOffset.y)
                } else {
                    owner.navigationController?.setNavigationBarHidden(isShow, animated: false)
                    owner.rootView.divider.isHidden = isShow
                }
            })
            .disposed(by: disposeBag)
        
        startDate
            .asDriver()
            .map { self.stringToDate.string(from: $0) }
            .drive(with: self, onNext: { owner, text in
                owner.rootView.readDateView.datePickerButton.setStartDateText(text: text)
            })
            .disposed(by: disposeBag)
        
        endDate
            .asDriver()
            .map { self.stringToDate.string(from: $0) }
            .drive(with: self, onNext: { owner, text in
                owner.rootView.readDateView.datePickerButton.setEndDateText(text: text)
            })
            .disposed(by: disposeBag)
        
        isNew
            .asDriver()
            .drive(with: self, onNext: { owner, isNew in
                if isNew {
                    owner.rootView.registerButton.setTitle(StringLiterals.Register.Normal.RegisterButton.new, for: .normal)
                } else {
                    owner.rootView.registerButton.setTitle(StringLiterals.Register.Normal.RegisterButton.edit, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        platformCollectionViewHeight
            .asDriver()
            .drive(with: self, onNext: { owner, height in
                owner.rootView.novelSummaryView.platformView.updateCollectionViewHeight(height: height)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Actions
    
    private func bindActions() {
        backButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.infoWithRatingView.starRatingView.starImageViews
            .enumerated().forEach { index, imageView in
                
                let tapGesture = UITapGestureRecognizer()
                imageView.addGestureRecognizer(tapGesture)
                tapGesture.rx.event
                    .bind(with: self, onNext: { owner, recognizer in
                        let location = recognizer.location(in: imageView)
                        let rating = Float(index) + (location.x > imageView.frame.width / 2 ? 1 : 0.5)
                        owner.starRating.accept(rating)
                    })
                    .disposed(by: disposeBag)
            }
        
        let panGesture = UIPanGestureRecognizer()
        rootView.infoWithRatingView.starRatingView.addGestureRecognizer(panGesture)
        panGesture.rx.event
            .bind(with: self, onNext: { owner, recognizer in
                let location = recognizer.location(in: owner.rootView.infoWithRatingView.starRatingView)
                let rawRating = (Float(location.x / owner.rootView.infoWithRatingView.starRatingView.frame.width * 5) * 2)
                    .rounded(.toNearestOrAwayFromZero) / 2
                let rating = min(max(rawRating, 0), 5)
                owner.starRating.accept(rating)
            })
            .disposed(by: disposeBag)
        
        for (index, readStatus) in ReadStatus.allCases.enumerated() {
            rootView.readStatusView.readStatusButtons[index].rx.tap
                .bind(with: self, onNext: { owner, _ in
                    owner.readStatus.accept(readStatus)
                })
                .disposed(by: disposeBag)
        }
        
        rootView.readDateView.toggleButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.isDateExist.accept(!owner.isDateExist.value)
            })
            .disposed(by: disposeBag)
        
        rootView.readDateView.datePickerButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.showDatePicker.accept(!owner.showDatePicker.value)
            })
            .disposed(by: disposeBag)
        
        rootView.customDatePicker.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.showDatePicker.accept(!owner.showDatePicker.value)
            })
            .disposed(by: disposeBag)
        
        rootView.customDatePicker.completeButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.startDate.accept(owner.rootView.customDatePicker.startDate)
                owner.endDate.accept(owner.rootView.customDatePicker.endDate)
                owner.showDatePicker.accept(!owner.showDatePicker.value)
            })
            .disposed(by: disposeBag)
        
        rootView.registerButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                if owner.isNew.value {
                    owner.postUserNovel()
                } else {
                    owner.patchUserNovel()
                }
                owner.rootView.registerButton.isEnabled = false
            })
            .disposed(by: disposeBag)
        
        rootView.novelSummaryView.platformView.platformCollectionView.rx.observe(CGSize.self, "contentSize")
            .map { $0?.height ?? 0 }
            .bind(to: platformCollectionViewHeight)
            .disposed(by: disposeBag)
    }
    
    //MARK: - API
    
    private func getNovel() {
        novelRepository.getNovelInfo(novelId: novelId)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in
                owner.bindData(data)
            },onError: { _, _ in
                print("ERROR!!!")
            }).disposed(by: disposeBag)
    }
    
    private func postUserNovel() {
        var requestStartDate: String? = stringToDate.string(from: startDate.value)
        var requestEndDate: String? = stringToDate.string(from: endDate.value)
        
        if !isDateExist.value {
            requestStartDate = nil
            requestEndDate = nil
        } else if readStatus.value == .READING  {
            requestEndDate = nil
        } else if readStatus.value == .DROP {
            requestStartDate = nil
        } else if readStatus.value == .WISH {
            requestStartDate = nil
            requestEndDate = nil
        }
        
        let requestRating: Float? = starRating.value <= 0.0 ? nil : starRating.value
        
        userNovelRepository.postUserNovel(novelId: novelId,
                                          userNovelRating: requestRating,
                                          userNovelReadStatus: readStatus.value,
                                          userNovelReadStartDate: requestStartDate,
                                          userNovelReadEndDate: requestEndDate)
        .observe(on: MainScheduler.instance)
        .subscribe(with: self, onNext: { owner, event in
            owner.userNovelId = event.userNovelId
            owner.navigationController?.pushViewController(RegisterSuccessViewController(userNovelId: owner.userNovelId),
                                                           animated: true)
        })
        .disposed(by: disposeBag)
    }
    
    private func patchUserNovel() {
        var requestStartDate: String? = stringToDate.string(from: startDate.value)
        var requestEndDate: String? = stringToDate.string(from: endDate.value)
        
        if !isDateExist.value {
            requestStartDate = nil
            requestEndDate = nil
        } else if readStatus.value == .READING  {
            requestEndDate = nil
        } else if readStatus.value == .DROP {
            requestStartDate = nil
        } else if readStatus.value == .WISH {
            requestStartDate = nil
            requestEndDate = nil
        }
        
        let requestRating: Float? = starRating.value <= 0.0 ? nil : starRating.value
        
        userNovelRepository.patchUserNovel(userNovelId: userNovelId,
                                           userNovelRating: requestRating,
                                           userNovelReadStatus: readStatus.value,
                                           userNovelReadStartDate: requestStartDate,
                                           userNovelReadEndDate: requestEndDate)
        .observe(on: MainScheduler.instance)
        .subscribe(with: self, onNext: { owner, data in
            if self.navigationController?.tabBarController?.selectedIndex == 0 {
                let tabBar = WSSTabBarController()
                tabBar.selectedIndex = 1
                let navigationController = UINavigationController(rootViewController: tabBar)
                navigationController.setNavigationBarHidden(true, animated: true)
                self.view.window?.rootViewController = navigationController
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    NotificationCenter.default.post(name: NSNotification.Name("ShowNovelInfo"), object: self.userNovelId)
                }
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }, onError: { owner, error in
            print(error)
        })
        .disposed(by: disposeBag)
    }
    
    private func bindData(_ data: NovelResult) {
        if let newNovelResult = data.newNovelResult {
            isNew.accept(true)
            bindNewData(newNovelResult)
        } else if let editNovelResult = data.editNovelResult {
            isNew.accept(false)
            bindUserData(editNovelResult)
        }
    }
    
    private func bindNewData(_ newData: NewNovelResult) {
        self.navigationTitle = newData.novelTitle
        rootView.bannerImageView.bindData(newData.novelImg)
        rootView.infoWithRatingView.bindData(coverImage: newData.novelImg,
                                             title: newData.novelTitle,
                                             author: newData.novelAuthor)
        rootView.novelSummaryView.bindData(plot: newData.novelDescription,
                                           genre: newData.novelGenre,
                                           platforms: newData.platforms)
        self.rootView.novelSummaryView.platformView.platformCollectionView.reloadData()
    }
    
    private func bindUserData(_ userData: EditNovelResult) {
        self.navigationTitle = userData.userNovelTitle
        self.userNovelId = userData.userNovelID
        rootView.bannerImageView.bindData(userData.userNovelImg)
        rootView.infoWithRatingView.bindData(coverImage: userData.userNovelImg,
                                             title: userData.userNovelTitle,
                                             author: userData.userNovelAuthor)
        self.starRating.accept(userData.userNovelRating ?? 0.0)
        
        
        let status = ReadStatus(rawValue: userData.userNovelReadStatus) ?? .FINISH
        self.readStatus.accept(status)
        
        // status에 따른 날짜 처리
        var start = userData.userNovelReadDate.userNovelReadStartDate ?? ""
        var end = userData.userNovelReadDate.userNovelReadEndDate ?? ""
        
        if status == .READING {
            end = start
        } else if status == .DROP {
            start = end
        }
        
        self.startDate.accept(
            stringToDate.date(from: start) ?? Date()
        )
        self.endDate.accept(
            stringToDate.date(from: end) ?? Date()
        )
        
        rootView.novelSummaryView.bindData(plot: userData.userNovelDescription,
                                           genre: userData.userNovelGenre,
                                           platforms: userData.platforms)
        self.rootView.novelSummaryView.platformView.platformCollectionView.reloadData()
    }
    
    //MARK: - Custom Method
    
    private func updateNavigationBarStyle(offset: CGFloat) {
        if offset > 0 {
            rootView.statusBarView.backgroundColor = .white
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.backgroundColor = .white
            navigationItem.title = self.navigationTitle
            rootView.divider.isHidden = false
        } else {
            rootView.statusBarView.backgroundColor = .clear
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.shadowImage = nil
            navigationController?.navigationBar.backgroundColor = .clear
            navigationItem.title = ""
            rootView.divider.isHidden = true
        }
    }
}

extension RegisterNormalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rootView.novelSummaryView.platformView.platformList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NovelDetailInfoPlatformCollectionViewCell.identifier,
            for: indexPath
        ) as? NovelDetailInfoPlatformCollectionViewCell else {return UICollectionViewCell()}
        
        cell.bindData(
            platform: rootView.novelSummaryView.platformView.platformList[indexPath.item].platformName
        )
        
        return cell
    }
}

extension RegisterNormalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: rootView.novelSummaryView.platformView.platformList[indexPath.item].platformUrl) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}

extension RegisterNormalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text: String? = rootView.novelSummaryView.platformView.platformList[indexPath.item].platformName
        
        guard let unwrappedText = text else {
            return CGSize(width: 0, height: 0)
        }
        
        let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 48
        return CGSize(width: width, height: 37)
    }
}
