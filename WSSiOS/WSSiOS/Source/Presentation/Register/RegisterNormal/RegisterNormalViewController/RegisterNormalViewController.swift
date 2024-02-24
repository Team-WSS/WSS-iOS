//
//  RegisterNormalViewController.swift
//  WSSiOS
//
//  Created by 이윤학 on 2/18/24.
//

import UIKit

import Kingfisher
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Then

/// 1-3-1 RegisterNormal View
final class RegisterNormalViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: RegisterViewModel
    private let disposeBag = DisposeBag()
    
    private var navigationTitle: String = ""
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = StringLiterals.Register.Normal.DatePicker.dateFormat
        $0.timeZone = TimeZone(identifier: StringLiterals.Register.Normal.DatePicker.KoreaTimeZone)
    }
    
    //MARK: - Components
    
    private let backButton = UIButton()
    private let rootView = RegisterNormalView()
    
    //MARK: - Life Cycle
    
    init(viewModel: RegisterViewModel) {
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
        
        setNavigationBar()
        updateNavigationBarStyle(offset: rootView.pageScrollView.contentOffset.y)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        rootView.divider.isHidden = true
    }
    
    //MARK: - UI
    
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
    
    //MARK: - Bind
    
    private func register() {
        rootView.novelSummaryView.platformCollectionView
            .register(NovelDetailInfoPlatformCollectionViewCell.self,
                      forCellWithReuseIdentifier: "NovelDetailInfoPlatformCollectionViewCell")
    }
    
    private func delegate() {
        rootView.novelSummaryView.platformCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = createViewModelInput()
        let output = viewModel.transform(from: input,
                                         disposeBag: disposeBag)
        bindViewModelOutput(output)
    }
    
    private func bindViewModelOutput(_ output: RegisterViewModel.Output) {
        output.novelBasicData
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in
                owner.rootView.bindData(data)
                owner.navigationTitle = data.novelTitle
            },onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        output.scrollContentOffset
            .drive(with: self, onNext: { owner, offset in
                owner.updateNavigationBarStyle(offset: offset.y)
            })
            .disposed(by: disposeBag)
        
        output.starRating
            .drive(with: self, onNext: { owner, rating in
                owner.rootView.infoWithRatingView.updateStarImages(rating: rating)
            })
            .disposed(by: disposeBag)
        
        output.readStatus
            .drive(with: self, onNext: { owner, status in
                owner.rootView.readStatusView.updateReadStatusButton(status: status)
                
                if status == .WISH {
                    owner.showReadDateView(false)
                } else {
                    owner.showReadDateView(true)
                    owner.rootView.customDatePicker.updateDatePickerTitle(status: status)
                    owner.rootView.readDateView.updateDatePickerButton(status)
                }
            })
            .disposed(by: disposeBag)
        
        output.isDateExist
            .drive(with: self, onNext: { owner, isDateExist in
                owner.rootView.readDateView.toggleButton.updateToggle(isDateExist)
                owner.showDatePickerButton(isDateExist)
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
        
        output.showDatePicker
            .drive(with: self, onNext: { owner, isShow in
                owner.showCustomDatePickerView(isShow)
                owner.updateNavigationBarStyleWithDatePicker(isShow)
            })
            .disposed(by: disposeBag)
        
        output.isSelectingStartDate
            .flatMapLatest { isSelectingStartDate in
                return isSelectingStartDate ? output.internalStartDate : output.internalEndDate
            }
            .drive(with: self, onNext: { owner, date in
                owner.rootView.customDatePicker.updateDatePicker(date: date)
            })
            .disposed(by: disposeBag)
        
        output.isOverToday
            .drive(with: self, onNext: { owner, isOverToday in
                if isOverToday {
                    owner.rootView.customDatePicker.updateDatePicker(date: Date())
                }
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
        
        output.platformList
            .drive(with: self, onNext: { owner, list in
                owner.rootView.novelSummaryView.hiddenPlatformView(when: list.isEmpty)
            })
            .disposed(by: disposeBag)
        
        output.platformCollectionViewHeight
            .drive(with: self, onNext: { owner, height in
                owner.rootView.novelSummaryView.updateCollectionViewHeight(height: height)
            })
            .disposed(by: disposeBag)
        
        output.platformList
            .asObservable()
            .bind(to: rootView.novelSummaryView.platformCollectionView.rx.items(
                cellIdentifier: NovelDetailInfoPlatformCollectionViewCell.cellIdentifier,
                cellType: NovelDetailInfoPlatformCollectionViewCell.self)) { item, element, cell in
                    cell.bindData(platform: element.platformName)
                }
                .disposed(by: disposeBag)
        
        rootView.novelSummaryView.platformCollectionView.rx.itemSelected
            .withLatestFrom(output.platformList) {(indexPath: $0, platformList: $1)}
            .subscribe(with: self, onNext: { owner, data in
                if let url = URL(string: data.platformList[data.indexPath.item].platformUrl) {
                    UIApplication.shared.open(url, options: [:])
                }
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
        
        output.backButtonTap
            .bind(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Actions
    
    private func createViewModelInput() -> RegisterViewModel.Input {
        let starRatingTapGesture = Observable.merge(
            rootView.infoWithRatingView.starImageViews.enumerated().map { index, imageView in
                imageView.rx.tapGesture()
                    .when(.recognized)
                    .map { recognizer in
                        let location = recognizer.location(in: imageView)
                        return (location: location, width: imageView.frame.width, index: index)
                    }
            }
        )
        
        let starRatingPanGesture = rootView.infoWithRatingView.starRatingStackView.rx.panGesture()
            .when(.changed)
            .map { recognizer in
                let location = recognizer.location(in: self.rootView.infoWithRatingView.starRatingStackView)
                let width = self.rootView.infoWithRatingView.starRatingStackView.frame.width
                return (location: location, width: width)
            }
        
        let readStatusButtonTap = Observable.merge(
            rootView.readStatusView.readStatusButtons.map {button in
                button.rx.tap.map { button.status }
            })
        
        let platformCollectionViewHeight = rootView.novelSummaryView.platformCollectionView.rx.observe(CGSize.self, "contentSize")
        
        return RegisterViewModel.Input(
            scrollContentOffset: rootView.pageScrollView.rx.contentOffset,
            starRatingTapGesture: starRatingTapGesture,
            starRatingPanGesture: starRatingPanGesture,
            readStatusButtonTap: readStatusButtonTap,
            readDateToggleButtonTap: rootView.readDateView.toggleButton.rx.tap,
            datePickerButtonTap: rootView.readDateView.datePickerButton.rx.tap,
            customDatePickerBackgroundTap: rootView.customDatePicker.rx.tap,
            customDatePickerStartButtonTap: rootView.customDatePicker.startButton.rx.tap,
            customDatePickerEndButtonTap: rootView.customDatePicker.endButton.rx.tap,
            customDatePickerDateChanged: rootView.customDatePicker.datePicker.rx.date.changed,
            customDatePickerCompleteButtonTap: rootView.customDatePicker.completeButton.rx.tap,
            platformCollectionViewHeight: platformCollectionViewHeight,
            registerButtonTap: rootView.registerButton.rx.tap,
            backButtonTap: backButton.rx.tap)
    }
    
    //MARK: - Custom Method
    
    private func showDatePickerButton(_ isShow: Bool) {
        rootView.readDateView.datePickerButton.isHidden = !isShow
    }
    
    private func showCustomDatePickerView(_ isShow: Bool) {
        rootView.customDatePicker.isHidden = !isShow
    }
    
    private func showReadDateView(_ isShow: Bool) {
        rootView.readDateView.isHidden = !isShow
    }
    
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
    
    private func updateNavigationBarStyleWithDatePicker(_ isShow: Bool) {
        if self.rootView.pageScrollView.contentOffset.y != 0 {
            self.navigationController?.setNavigationBarHidden(isShow, animated: false)
            self.rootView.divider.isHidden = isShow
        } else {
            self.updateNavigationBarStyle(offset: self.rootView.pageScrollView.contentOffset.y)
        }
    }
}

extension RegisterNormalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let text = viewModel.platFormNameForItemAt(indexPath: indexPath) else {
            return CGSize(width: 0, height: 0)
        }
        
        let width = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 48
        return CGSize(width: width, height: 37)
    }
}
