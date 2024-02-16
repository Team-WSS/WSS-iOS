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
    private var platformList: [UserNovelPlatform] = []
    private var minStarRating: Float = 0.0
    private var maxStarRating: Float = 5.0
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = StringLiterals.Register.Normal.DatePicker.dateFormat
        $0.timeZone = TimeZone(identifier: StringLiterals.Register.Normal.DatePicker.KoreaTimeZone)
    }
    private var requestStartDate: String?
    private var requestEndDate: String?
    private var requestRating: Float?
    
    // RxSwift
    private let disposeBag = DisposeBag()
    private var isNew = BehaviorRelay<Bool>(value: true)
    private var starRating = BehaviorRelay<Float>(value: 0.0)
    private var readStatus = BehaviorRelay<ReadStatus>(value: .FINISH)
    private var isDateExist = BehaviorRelay<Bool>(value: true)
    private var showDatePicker = BehaviorRelay<Bool>(value: false)
    private var startDate = BehaviorRelay<Date>(value: Date())
    private var endDate = BehaviorRelay<Date>(value: Date())
    private var internalStartDate = BehaviorRelay<Date>(value: Date())
    private var internalEndDate = BehaviorRelay<Date>(value: Date())
    private var isSelectingStartDate = BehaviorRelay<Bool>(value: true)
    private var platformCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    
    // MARK: - Components
    
    private let backButton = UIButton()
    private let rootView = RegisterNormalView()
    
    // MARK: - Life Cycle
    
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
        bindNavigation()
        setNavigationBar()
        swipeBackGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar()
        updateNavigationBarStyle(offset: rootView.pageScrollView.contentOffset.y)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        rootView.divider.isHidden = true
    }
    
    // MARK: - UI
    
    private func setUI() {
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    private func setNavigationBar() {
        rootView.divider.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.Title2,
            NSAttributedString.Key.foregroundColor: UIColor.wssBlack
        ]
    }
    
    // MARK: - Bind
    
    private func register() {
        rootView.novelSummaryView.platformCollectionView.register(NovelDetailInfoPlatformCollectionViewCell.self, forCellWithReuseIdentifier: "NovelDetailInfoPlatformCollectionViewCell")
        rootView.novelSummaryView.platformCollectionView.dataSource = self
        rootView.novelSummaryView.platformCollectionView.delegate = self
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
                owner.rootView.infoWithRatingView.updateStarImages(rating: rating)
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
                    owner.rootView.readDateView.updateDatePickerButton(status)
                }
                
                owner.rootView.customDatePicker.updateDatePickerTitle(status: status)
                
                if status == .FINISH || status == .READING {
                    owner.isSelectingStartDate.accept(true)
                } else if status == .DROP {
                    owner.isSelectingStartDate.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        isDateExist
            .asDriver()
            .drive(with: self, onNext: { owner, isDateExist in
                owner.rootView.readDateView.toggleButton.updateToggle(isDateExist)
                owner.rootView.readDateView.datePickerButton.isHidden = !isDateExist
            })
            .disposed(by: disposeBag)
        
        showDatePicker
            .asDriver()
            .drive(with: self, onNext: { owner, isShow in
                if isShow {
                    owner.internalStartDate.accept(owner.startDate.value)
                    owner.internalEndDate.accept(owner.endDate.value)
                    owner.rootView.customDatePicker
                        .updateDatePicker(date: owner.isSelectingStartDate.value ? owner.internalStartDate.value : owner.internalEndDate.value)
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
            .map { self.dateFormatter.string(from: $0) }
            .drive(with: self, onNext: { owner, text in
                owner.rootView.readDateView.setStartDateText(text: text)
            })
            .disposed(by: disposeBag)
        
        endDate
            .asDriver()
            .map { self.dateFormatter.string(from: $0) }
            .drive(with: self, onNext: { owner, text in
                owner.rootView.readDateView.setEndDateText(text: text)
            })
            .disposed(by: disposeBag)
        
        internalStartDate
            .asDriver()
            .map { self.dateFormatter.string(from: $0) }
            .drive(with: self, onNext: { owner, text in
                owner.rootView.customDatePicker.setStartDateText(text: text)
            })
            .disposed(by: disposeBag)
        
        internalEndDate
            .asDriver()
            .map { self.dateFormatter.string(from: $0) }
            .drive(with: self, onNext: { owner, text in
                owner.rootView.customDatePicker.setEndDateText(text: text)
            })
            .disposed(by: disposeBag)
        
        isSelectingStartDate
            .asDriver()
            .drive(with: self, onNext: { owner, isStart in
                owner.rootView.customDatePicker.updateButtons(isStart)
                owner.rootView.customDatePicker
                    .updateDatePicker(date: isStart ? owner.internalStartDate.value :
                                                      owner.internalEndDate.value)
            })
            .disposed(by: disposeBag)
        
        isNew
            .asDriver()
            .drive(with: self, onNext: { owner, isNew in
                owner.rootView.registerButton
                    .setTitle(isNew ? StringLiterals.Register.Normal.RegisterButton.new :
                                      StringLiterals.Register.Normal.RegisterButton.edit,
                              for: .normal)
            })
            .disposed(by: disposeBag)
        
        platformCollectionViewHeight
            .asDriver()
            .drive(with: self, onNext: { owner, height in
                owner.rootView.novelSummaryView.updateCollectionViewHeight(height: height)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    
    private func bindActions() {
        rootView.infoWithRatingView.starImageViews
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
        rootView.infoWithRatingView.starRatingStackView.addGestureRecognizer(panGesture)
        panGesture.rx.event
            .bind(with: self, onNext: { owner, recognizer in
                let location = recognizer.location(in: owner.rootView.infoWithRatingView.starRatingStackView)
                let rawRating = (Float(location.x / owner.rootView.infoWithRatingView.starRatingStackView.frame.width * 5) * 2)
                    .rounded(.toNearestOrAwayFromZero) / 2
                let rating = min(max(rawRating, owner.minStarRating), owner.maxStarRating)
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
        
        rootView.customDatePicker.startButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.isSelectingStartDate.accept(true)
            })
            .disposed(by: disposeBag)
        
        rootView.customDatePicker.endButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.isSelectingStartDate.accept(false)
            })
            .disposed(by: disposeBag)
        
        rootView.customDatePicker.datePicker.rx.date.changed
            .bind(with: self, onNext: { owner, date in
                var selectedDate = date
                if date > Date() {
                    owner.rootView.customDatePicker.updateDatePicker(date: Date())
                    selectedDate = Date()
                }
                
                let isStart = owner.isSelectingStartDate.value
                let startDate = owner.internalStartDate.value
                let endDate = owner.internalEndDate.value
                
                if (isStart && selectedDate >= endDate) || (!isStart && selectedDate <= startDate) {
                    owner.internalStartDate.accept(selectedDate)
                    owner.internalEndDate.accept(selectedDate)
                } else if isStart {
                    owner.internalStartDate.accept(selectedDate)
                } else if !isStart {
                    owner.internalEndDate.accept(selectedDate)
                }
            })
            .disposed(by: disposeBag)
        
        rootView.customDatePicker.completeButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.startDate.accept(owner.internalStartDate.value)
                owner.endDate.accept(owner.internalEndDate.value)
                owner.showDatePicker.accept(!owner.showDatePicker.value)
            })
            .disposed(by: disposeBag)
        
        rootView.novelSummaryView.platformCollectionView.rx.observe(CGSize.self, "contentSize")
            .map { $0?.height ?? 0 }
            .bind(to: platformCollectionViewHeight)
            .disposed(by: disposeBag)
    }
    
    private func bindNavigation() {
        backButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        rootView.registerButton.rx.tap
            .asDriver()
            .throttle(.seconds(3), latest: false)
            .drive(with: self, onNext: { owner, _ in
                owner.isNew.value ? owner.postUserNovel() : owner.patchUserNovel()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - API
    
    private func getNovel() {
        novelRepository.getNovelInfo(novelId: novelId)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in
                owner.bindData(data)
            },onError: { owner, error in
                print(error)
            }).disposed(by: disposeBag)
    }
    
    private func postUserNovel() {
        formatRequestBodyData()
        userNovelRepository.postUserNovel(novelId: novelId,
                                          userNovelRating: requestRating,
                                          userNovelReadStatus: readStatus.value,
                                          userNovelReadStartDate: requestStartDate,
                                          userNovelReadEndDate: requestEndDate)
        .observe(on: MainScheduler.instance)
        .subscribe(with: self, onNext: { owner, data in
            owner.userNovelId = data.userNovelId
            owner.pushToRegisterSuccessViewController(userNovelId: owner.userNovelId)
        }, onError: { owner, error in
            print(error)
        })
        .disposed(by: disposeBag)
    }
    
    private func patchUserNovel() {
        formatRequestBodyData()
        userNovelRepository.patchUserNovel(userNovelId: userNovelId,
                                           userNovelRating: requestRating,
                                           userNovelReadStatus: readStatus.value,
                                           userNovelReadStartDate: requestStartDate,
                                           userNovelReadEndDate: requestEndDate)
        .observe(on: MainScheduler.instance)
        .subscribe(with: self, onNext: { owner, data in
            owner.moveToNovelDetailViewController(userNovelId: owner.userNovelId)
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
        self.platformList = newData.platforms
        rootView.novelSummaryView.hiddenPlatformView(platformList.count)
        rootView.bindNewData(newData)
    }
    
    private func bindUserData(_ userData: EditNovelResult) {
        self.navigationTitle = userData.userNovelTitle
        self.userNovelId = userData.userNovelID
        self.platformList = userData.platforms
        rootView.novelSummaryView.hiddenPlatformView(platformList.count)
        rootView.bindUserData(userData)
        
        self.starRating.accept(userData.userNovelRating ?? minStarRating)
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
        
        self.startDate.accept( dateFormatter.date(from: start) ?? Date() )
        self.endDate.accept( dateFormatter.date(from: end) ?? Date() )
    }
    
    // MARK: - Custom Method
    
    private func updateNavigationBarStyle(offset: CGFloat) {
        if offset > 0 {
            rootView.statusBarView.backgroundColor = .wssWhite
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.backgroundColor = .wssWhite
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
    
    private func formatRequestBodyData() {
        requestStartDate = dateFormatter.string(from: startDate.value)
        requestEndDate = dateFormatter.string(from: endDate.value)
        
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
        
        requestRating = starRating.value <= minStarRating ? nil : starRating.value
    }
}

extension RegisterNormalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.platformList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NovelDetailInfoPlatformCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? NovelDetailInfoPlatformCollectionViewCell else { return UICollectionViewCell() }
        
        cell.bindData(
            platform: self.platformList[indexPath.item].platformName
        )
        
        return cell
    }
}

extension RegisterNormalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: self.platformList[indexPath.item].platformUrl) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}

extension RegisterNormalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text: String? = self.platformList[indexPath.item].platformName
        
        guard let unwrappedText = text else {
            return CGSize(width: 0, height: 0)
        }
        
        let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 48
        return CGSize(width: width, height: 37)
    }
}
