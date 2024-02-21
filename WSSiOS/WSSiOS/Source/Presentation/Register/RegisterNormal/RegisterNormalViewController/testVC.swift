//
//  testVC.swift
//  WSSiOS
//
//  Created by 이윤학 on 2/18/24.
//

import UIKit

import Kingfisher
import RxSwift
import RxCocoa
import SnapKit
import Then

/// 1-3-1 RegisterNormal View
final class TestVC: UIViewController{
    
    // MARK: - Properties
    
    //    private let novelRepository: NovelRepository
    //    private let userNovelRepository: UserNovelRepository
    //    private let novelId: Int
    //    private var userNovelId: Int
    
    private let viewModel: RegisterNormalViewModel
    
    private var navigationTitle: String = ""
    private var platformList: [UserNovelPlatform] = []
    private var minStarRating: Float = 0.0
    private var maxStarRating: Float = 5.0
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = StringLiterals.Register.Normal.DatePicker.dateFormat
        $0.timeZone = TimeZone(identifier: StringLiterals.Register.Normal.DatePicker.KoreaTimeZone)
    }
    
    // RxSwift
    private let disposeBag = DisposeBag()
    private var platformCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    
    // MARK: - Components
    
    private let backButton = UIButton()
    private let rootView = RegisterNormalView()
    
    // MARK: - Life Cycle
    
    init(viewModel: RegisterNormalViewModel) {
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
        VMbind()
        register()
        bindUI()
        bindActions()
        setNavigationBar()
        swipeBackGesture()
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
                        owner.viewModel.starRating.accept(rating)
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
                owner.viewModel.starRating.accept(rating)
            })
            .disposed(by: disposeBag)
        
        rootView.novelSummaryView.platformCollectionView.rx.observe(CGSize.self, "contentSize")
            .map { $0?.height ?? 0 }
            .bind(to: platformCollectionViewHeight)
            .disposed(by: disposeBag)
    }
    
    // MARK: - API
    
    private func VMbind() {
        let readStatusButtonTap = Observable.merge(
            rootView.readStatusView.readStatusButtons.enumerated().map { index, button in
                button.rx.tap.map { ReadStatus.allCases[index] }
            })
        let input = RegisterNormalViewModel
            .Input(scrollContentOffset: rootView.pageScrollView.rx.contentOffset,
                   backButtonTap: backButton.rx.tap, 
                   registerButtonTap:  rootView.registerButton.rx.tap,
                   readStatusButtonTap: readStatusButtonTap,
                   readDateToggleButtonTap: rootView.readDateView.toggleButton.rx.tap,
                   datePickerButtonTap: rootView.readDateView.datePickerButton.rx.tap,
                   customDatePickerBackgroundTap: rootView.customDatePicker.rx.tap,
                   customDatePickerCompleteButtonTap: rootView.customDatePicker.completeButton.rx.tap,
                   customDatePickerStartButtonTap: rootView.customDatePicker.startButton.rx.tap,
                   customDatePickerEndButtonTap: rootView.customDatePicker.endButton.rx.tap,
                   customDatePickerDateChanged: rootView.customDatePicker.datePicker.rx.date.changed)
        let output = viewModel.transform(from: input,
                                         disposeBag: disposeBag)
        
        output.novelBasicData
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in
                owner.rootView.bindData(data)
                owner.navigationTitle = data.novelTitle
                owner.platformList = data.platforms
                owner.rootView.novelSummaryView.hiddenPlatformView(when: owner.platformList.isEmpty)
            },onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        output.scrollContentOffset
            .drive(with: self, onNext: { owner, offset in
                owner.updateNavigationBarStyle(offset: offset.y)
            })
            .disposed(by: disposeBag)
        
        output.backButtonTap
            .bind(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        output.isNew
            .drive(with: self, onNext: { owner, isNew in
                let text = isNew ? StringLiterals.Register.Normal.RegisterButton.new :
                StringLiterals.Register.Normal.RegisterButton.edit
                owner.rootView.registerButton.setTitle(text,
                                                       for: .normal)
            })
            .disposed(by: disposeBag)
        
        output.isDateExist
            .drive(with: self, onNext: { owner, isDateExist in
                owner.rootView.readDateView.toggleButton.updateToggle(isDateExist)
                owner.showDatePickerButton(isDateExist)
            })
            .disposed(by: disposeBag)
        
        Driver
            .combineLatest(output.showDatePicker,
                           output.isSelectingStartDate)
            .flatMapLatest{ isShow, isSelectingStartDate in
                self.showCustomDatePickerView(isShow)
                self.updateNavigationBarStyleWithDatePicker(isShow)
                return isSelectingStartDate ? output.internalStartDate : output.internalEndDate
            }.drive(with: self, onNext: { owner, date in
                owner.rootView.customDatePicker.updateDatePicker(date: date)
            })
            .disposed(by: disposeBag)
        
        
        output.readStatus
            .drive(with: self, onNext: { owner, status in
                owner.rootView.readStatusView.updateReadStatusButton(status: status)
                owner.rootView.customDatePicker.updateDatePickerTitle(status: status)
                
                if status == .WISH {
                    owner.showReadDateView(false)
                } else {
                    owner.showReadDateView(true)
                    owner.rootView.readDateView.updateDatePickerButton(status)
                }
            })
            .disposed(by: disposeBag)
        
        output.isOverToday
            .drive(with: self, onNext: { owner, status in
                if status {
                    owner.rootView.customDatePicker.updateDatePicker(date: Date())
                }
            })
            .disposed(by: disposeBag)
        
        output.startDate
            .map { self.dateFormatter.string(from: $0) }
            .drive(with: self, onNext: { owner, text in
                owner.rootView.readDateView.setStartDateText(text: text)
            })
            .disposed(by: disposeBag)
        
        output.endDate
            .map { self.dateFormatter.string(from: $0) }
            .drive(with: self, onNext: { owner, text in
                owner.rootView.readDateView.setEndDateText(text: text)
            })
            .disposed(by: disposeBag)
        
        output.internalStartDate
            .map { self.dateFormatter.string(from: $0) }
            .drive(with: self, onNext: { owner, text in
                owner.rootView.customDatePicker.setStartDateText(text: text)
            })
            .disposed(by: disposeBag)
        
        output.internalEndDate
            .map { self.dateFormatter.string(from: $0) }
            .drive(with: self, onNext: { owner, text in
                owner.rootView.customDatePicker.setEndDateText(text: text)
            })
            .disposed(by: disposeBag)
        
        output.isSelectingStartDate
            .flatMapLatest { isStart in
                self.rootView.customDatePicker.updateButtons(isStart)
                return isStart ? output.internalStartDate : output.internalEndDate
            }
            .drive(with: self, onNext: { owner, date in
                owner.rootView.customDatePicker.updateDatePicker(date: date)
            })
            .disposed(by: disposeBag)
        
        output.starRating
            .drive(with: self, onNext: { owner, rating in
                owner.rootView.infoWithRatingView.updateStarImages(rating: rating)
            })
            .disposed(by: disposeBag)
        
        output.endAPIRequest
            .observe(on: MainScheduler.instance)
            .withLatestFrom(output.isNew) { (userNovelId: $0, isNew: $1) }
            .subscribe(with: self, onNext: { owner, values in
                values.isNew ? owner.pushToRegisterSuccessViewController(userNovelId: values.userNovelId) :
                               owner.moveToNovelDetailViewController(userNovelId: values.userNovelId)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
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
    
    private func showDatePickerButton(_ isShow: Bool) {
        rootView.readDateView.datePickerButton.isHidden = !isShow
    }
    
    private func showCustomDatePickerView(_ isShow: Bool) {
        rootView.customDatePicker.isHidden = !isShow
    }
    
    private func showReadDateView(_ isShow: Bool) {
        rootView.readDateView.isHidden = !isShow
    }
    
    private func updateNavigationBarStyleWithDatePicker(_ isShow: Bool) {
        if self.rootView.pageScrollView.contentOffset.y != 0 {
            self.navigationController?.setNavigationBarHidden(isShow, animated: false)
            self.rootView.divider.isHidden = isShow
        } else {
            self.updateNavigationBarStyle(offset: self.rootView.pageScrollView.contentOffset.y)
        }
    }
}

extension TestVC: UICollectionViewDataSource {
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

extension TestVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: self.platformList[indexPath.item].platformUrl) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}

extension TestVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text: String? = self.platformList[indexPath.item].platformName
        
        guard let unwrappedText = text else {
            return CGSize(width: 0, height: 0)
        }
        
        let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 48
        return CGSize(width: width, height: 37)
    }
}
