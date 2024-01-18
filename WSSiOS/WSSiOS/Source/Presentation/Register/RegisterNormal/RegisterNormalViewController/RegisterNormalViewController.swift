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
    
    // 서버 통신을 위한 properties
    private let novelRepository: NovelRepository
    private let userNovelRepository: UserNovelRepository
    private let novelId: Int
    private var userNovelId: Int
    private var novelTitle: String = ""
    let localData: EditNovelResult?
    
    // RxSwift
    private var isNew = BehaviorRelay<Bool>(value: true)
    private let disposeBag = DisposeBag()
    private var starRating = BehaviorRelay<Float>(value: 0.0)
    private var readStatus = BehaviorRelay<ReadStatus>(value: .FINISH)
    private var isDateExist = BehaviorRelay<Bool>(value: true)
    private var showDatePicker = BehaviorRelay<Bool>(value: false)
    private var startDate = BehaviorRelay<Date>(value: Date())
    private var endDate = BehaviorRelay<Date>(value: Date())
    private let platformCollectionViewHeight = BehaviorSubject<CGFloat>(value: 0)
    
    private let rootView = RegisterNormalView()
    
    // Date -> String
    let dateToString = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd"
    }
    // String -> Date
    let stringToDate = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd"
        $0.timeZone = TimeZone(identifier: "ko_KR")
    }
    
    
    private let backButton = UIButton()
    
    // MARK: - View Life Cycle
    
    init(novelRepository: NovelRepository, userNovelRepository: UserNovelRepository, novelId: Int = 0, userNovelId: Int = 0, userNovelModel: EditNovelResult? = nil) {
        self.novelRepository = novelRepository
        self.userNovelRepository = userNovelRepository
        self.novelId = novelId
        self.userNovelId = userNovelId
        self.localData = userNovelModel
        
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
        setNavigationBar()
        getNovel()
        register()
        delegate()
        bindRx()
    }
    
    // MARK: - Custom Method
    private func setNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.Title2,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
    }
    
    private func setUI() {
        backButton.do {
            $0.setImage(ImageLiterals.icon.navigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    private func postUserNovel() {
        var requestStartDate: String? = dateToString.string(from: startDate.value)
        var requestEndDate: String? = dateToString.string(from: endDate.value)
        
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
        var requestStartDate: String? = dateToString.string(from: startDate.value)
        var requestEndDate: String? = dateToString.string(from: endDate.value)
        
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
                navigationController.isNavigationBarHidden = true
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
    
    private func getNovel() {
        novelRepository.getNovelInfo(novelId: novelId)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { data in
                self.bindData(data)
            },onError: { error in
                print("ERROR!!!")
                if let localData = self.localData {
                    self.bindUserData(localData)
                }
            }).disposed(by: disposeBag)
    }
    
    private func register() {
        rootView.novelSummaryView.platformView.platformCollectionView.register(NovelDetailInfoPlatformCollectionViewCell.self, forCellWithReuseIdentifier: "NovelDetailInfoPlatformCollectionViewCell")
    }
    
    private func delegate() {
        rootView.novelSummaryView.platformView.platformCollectionView.dataSource = self
        rootView.novelSummaryView.platformView.platformCollectionView.delegate = self
    }
    
    private func bindData(_ data: NovelResult) {
        if let newNovelResult = data.newNovelResult {
            isNew.accept(true)
            bindNewData(newNovelResult)
            print("New!")
            print(newNovelResult.novelID)
        } else if let editNovelResult = data.editNovelResult {
            isNew.accept(false)
            bindUserData(editNovelResult)
            print("Edit!")
        }
    }
    
    private func bindNewData(_ newData: NewNovelResult) {
        self.novelTitle = newData.novelTitle
        rootView.bannerImageView.bindData(newData.novelImg)
        rootView.infoWithRatingView.bindData(coverImage: newData.novelImg,
                                             title: newData.novelTitle,
                                             author: newData.novelAuthor)
        rootView.novelSummaryView.bindData(plot: newData.novelDescription, genre: newData.novelGenre, platforms: newData.platforms)
        self.rootView.novelSummaryView.platformView.platformCollectionView.reloadData()
    }
    
    private func bindUserData(_ userData: EditNovelResult) {
        self.novelTitle = userData.userNovelTitle
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
            dateToString.date(from: start) ?? Date()
        )
        self.endDate.accept(
            dateToString.date(from: end) ?? Date()
        )
        
        rootView.novelSummaryView.bindData(plot: userData.userNovelDescription, genre: userData.userNovelGenre, platforms: userData.platforms)
        self.rootView.novelSummaryView.platformView.platformCollectionView.reloadData()
    }
    
    private func bindRx() {
        backButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.pageScrollView.rx.contentOffset
            .asDriver()
            .drive(onNext: { [weak self] offset in
                self?.updateNavigationBarStyle(offset: offset.y)
            })
            .disposed(by: disposeBag)
        
        rootView.infoWithRatingView.starRatingView.do { view in
            
            view.starImageViews.enumerated().forEach { index, imageView in
                
                // StarRating 탭 제스처 인식기 생성 및 설정
                let tapGesture = UITapGestureRecognizer()
                imageView.addGestureRecognizer(tapGesture)
                tapGesture.rx.event
                    .bind(onNext: { recognizer in
                        let location = recognizer.location(in: imageView)
                        let rating = Float(index) + (location.x > imageView.frame.width / 2 ? 1 : 0.5)
                        self.starRating.accept(rating)
                    })
                    .disposed(by: disposeBag)
                
                // StarRating 팬 제스처 인식기 생성 및 설정
                let panGesture = UIPanGestureRecognizer()
                view.addGestureRecognizer(panGesture)
                panGesture.rx.event
                    .bind(onNext: { recognizer in
                        let location = recognizer.location(in: view)
                        let rawRating = (Float(location.x / view.frame.width * 5) * 2).rounded(.toNearestOrAwayFromZero) / 2
                        let rating = min(max(rawRating, 0), 5)
                        self.starRating.accept(rating)
                    })
                    .disposed(by: disposeBag)
            }
            
            // 별점이 변경될 때마다 별 이미지 업데이트
            starRating.asObservable()
                .subscribe(with: self, onNext: { owner, rating in
                    view.updateStarImages(rating: rating)
                })
                .disposed(by: disposeBag)
        }
        
        // ReadStatus 에 따른 ReadStatus 선택 뷰 변화
        rootView.readStatusView.do { view in
            for (index, status) in ReadStatus.allCases.enumerated() {
                view.readStatusButtons[index].rx.tap
                    .bind {
                        self.readStatus.accept(status)
                    }
                    .disposed(by: disposeBag)
            }
            
            readStatus
                .subscribe(onNext: { status in
                    view.bindReadStatus(status: status)
                })
                .disposed(by: disposeBag)
        }
        
        // ReadStatus 에 따른 날짜 선택 뷰 변화
        rootView.readDateView.do { view in
            readStatus
                .subscribe(with: self, onNext: { owner, status in
                    if status == .WISH {
                        view.isHidden = true
                    } else {
                        view.isHidden = false
                        view.bindData(status)
                    }
                })
                .disposed(by: disposeBag)
        }
        
        rootView.readDateView.do { view in
            view.toggleButton.rx.tap
                .subscribe(with: self, onNext: { owner, status in
                    let next = !self.isDateExist.value
                    self.isDateExist.accept(next)
                })
                .disposed(by: disposeBag)
            
            isDateExist
                .subscribe(with: self, onNext: { owner, status in
                    view.toggleButton.changeState(status)
                    view.datePickerButton.isHidden = !status
                })
                .disposed(by: disposeBag)
            
            view.datePickerButton.rx.tap
                .subscribe(with: self, onNext: { owner, status in
                    let next = !self.showDatePicker.value
                    self.showDatePicker.accept(next)
                })
                .disposed(by: disposeBag)
        }
        
        rootView.do { view in
            showDatePicker.subscribe(with: self, onNext: { owner, show in
                if show {
                    view.customDatePicker.startDate = self.startDate.value
                    view.customDatePicker.endDate = self.endDate.value
                }
                view.customDatePicker.isHidden = !show
            })
            .disposed(by: disposeBag)
            
            view.customDatePicker.rx.tap
                .subscribe(with: self, onNext: { owner, status in
                    let next = !self.showDatePicker.value
                    self.showDatePicker.accept(next)
                    print(next)
                })
                .disposed(by: disposeBag)
            
            view.customDatePicker.completeButton.rx.tap
                .subscribe(with: self, onNext: { owner, status in
                    self.startDate.accept(view.customDatePicker.startDate)
                    self.endDate.accept(view.customDatePicker.endDate)
                    let next = !self.showDatePicker.value
                    self.showDatePicker.accept(next)
                })
                .disposed(by: disposeBag)
            
            startDate.asObservable()
                .map { self.dateToString.string(from: $0) }
                .bind(to: view.readDateView.datePickerButton.startDateLabel.rx.text)
                .disposed(by: disposeBag)
            
            endDate.asObservable()
                .map { self.dateToString.string(from: $0) }
                .bind(to: view.readDateView.datePickerButton.endDateLabel.rx.text)
                .disposed(by: disposeBag)
            
            readStatus
                .subscribe(with: self, onNext: { owner, status in
                    view.customDatePicker.bindReadStatus(status: status)
                })
                .disposed(by: disposeBag)
        }
        
        rootView.registerButton.rx.tap
            .subscribe(with: self, onNext: { _,_ in
                if self.isNew.value {
                    self.postUserNovel()
                } else {
                    self.patchUserNovel()
                }
                self.rootView.registerButton.isEnabled = false
            })
            .disposed(by: disposeBag)
        
        isNew.subscribe(with: self, onNext: { owner, status in
            if status {
                self.rootView.registerButton.setTitle(StringLiterals.Register.Normal.new, for: .normal)
            } else {
                self.rootView.registerButton.setTitle(StringLiterals.Register.Normal.edit, for: .normal)
            }
        })
        .disposed(by: disposeBag)
        
        rootView.novelSummaryView.platformView.platformCollectionView.rx.observe(CGSize.self, "contentSize")
            .map { $0?.height ?? 0 }
            .bind(to: platformCollectionViewHeight)
            .disposed(by: disposeBag)
        
        platformCollectionViewHeight
            .subscribe(onNext: { height in
                self.rootView.novelSummaryView.platformView.updateCollectionViewHeight(height: height)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateNavigationBarStyle(offset: CGFloat) {
        if offset > 0 {
            rootView.statusBarView.backgroundColor = .white
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.backgroundColor = .white
            navigationItem.title = self.novelTitle
        } else {
            rootView.statusBarView.backgroundColor = .clear
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.shadowImage = nil
            navigationController?.navigationBar.backgroundColor = .clear
            navigationItem.title = ""
        }
    }
}

extension RegisterNormalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Hello")
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
        var text: String?
        
        text = rootView.novelSummaryView.platformView.platformList[indexPath.item].platformName
        
        guard let unwrappedText = text else {
            return CGSize(width: 0, height: 0)
        }
        
        let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 48
        return CGSize(width: width, height: 37)
    }
}
