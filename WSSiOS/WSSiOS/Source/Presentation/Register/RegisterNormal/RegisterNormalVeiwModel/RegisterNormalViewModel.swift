//
//  RegisterNormalViewModel.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/10/24.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterNormalViewModel: ViewModelType {
    
    //MARK: - Properties
    
    let novelRepository: NovelRepository
    let userNovelRepository: UserNovelRepository
    let novelId: Int
    var userNovelId: Int
    
    private var minStarRating: Float = 0.0
    private var maxStarRating: Float = 5.0
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = StringLiterals.Register.Normal.DatePicker.dateFormat
        $0.timeZone = TimeZone(identifier: StringLiterals.Register.Normal.DatePicker.KoreaTimeZone)
    }
    
    private let disposeBag = DisposeBag()
    private let novelBasicData = PublishSubject<NovelBasicData>()
    private let isNew = BehaviorRelay<Bool>(value: true)
     let starRating = BehaviorRelay<Float>(value: 0.0)
    private let readStatus = BehaviorRelay<ReadStatus>(value: .FINISH)
    private let isDateExist = BehaviorRelay<Bool>(value: true)
    private let showDatePicker = BehaviorRelay<Bool>(value: false)
    private let startDate = BehaviorRelay<Date>(value: Date())
    private let endDate = BehaviorRelay<Date>(value: Date())
    private let internalStartDate = BehaviorRelay<Date>(value: Date())
    private let internalEndDate = BehaviorRelay<Date>(value: Date())
    private let isSelectingStartDate = BehaviorRelay<Bool>(value: true)
    private let isOverToday = BehaviorRelay<Bool>(value: false)
    private let platformCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    
    
    //MARK: - Life Cycle
    
    init(novelRepository: NovelRepository, userNovelRepository: UserNovelRepository, novelId: Int = 0, userNovelId: Int = 0) {
        self.novelRepository = novelRepository
        self.userNovelRepository = userNovelRepository
        self.novelId = novelId
        self.userNovelId = userNovelId
    }
    
    struct Input {
        let scrollContentOffset: ControlProperty<CGPoint>
        let backButtonTap: ControlEvent<Void>
        let readStatusButtonTap: Observable<ReadStatus>
        let readDateToggleButtonTap: ControlEvent<Void>
        let datePickerButtonTap: ControlEvent<Void>
        let customDatePickerBackgroundTap: ControlEvent<Void>
        let customDatePickerCompleteButtonTap: ControlEvent<Void>
        let customDatePickerStartButtonTap: ControlEvent<Void>
        let customDatePickerEndButtonTap: ControlEvent<Void>
        let customDatePickerDateChanged: ControlEvent<Date>
    }
    
    struct Output {
        let scrollContentOffset: Driver<CGPoint>
        let backButtonTap: Observable<Void>
        let novelBasicData: Observable<NovelBasicData>
        let isNew: Driver<Bool>
        let starRating: Driver<Float>
        let readStatus: Driver<ReadStatus>
        let isDateExist: Driver<Bool>
        let showDatePicker: Driver<Bool>
        let isOverToday: Driver<Bool>
        let isSelectingStartDate: Driver<Bool>
        let startDate: Driver<Date>
        let endDate: Driver<Date>
        let internalStartDate: Driver<Date>
        let internalEndDate: Driver<Date>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let scrollContentOffset = input.scrollContentOffset
        
        novelRepository.getNovelInfo(novelId: novelId)
            .subscribe(with: self, onNext: { owner, data in
                if let newData = data.newNovelResult {
                    owner.isNew.accept(true)
                    owner.novelBasicData
                        .onNext(NovelBasicData(novelTitle: newData.novelTitle,
                                               novelAuthor: newData.novelAuthor,
                                               novelGenre: newData.novelGenre,
                                               novelImg: newData.novelImg,
                                               novelDescription: newData.novelDescription,
                                               platforms: newData.platforms))
                } else if let userData = data.editNovelResult {
                    owner.isNew.accept(false)
                    owner.novelBasicData
                        .onNext(NovelBasicData(novelTitle: userData.userNovelTitle,
                                               novelAuthor: userData.userNovelAuthor,
                                               novelGenre: userData.userNovelGenre,
                                               novelImg: userData.userNovelImg,
                                               novelDescription: userData.userNovelDescription,
                                               platforms: userData.platforms))
                    owner.bindUserData(userData)
                }
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        let backButtonTap = input.backButtonTap.asObservable()
        
        input.readDateToggleButtonTap
            .bind(with: self, onNext: {owner, _ in
                owner.isDateExist.accept(!owner.isDateExist.value)
            })
            .disposed(by: disposeBag)
        
        input.readStatusButtonTap
            .bind(with: self, onNext: {owner, status in
                owner.readStatus.accept(status)
                
                if status == .FINISH || status == .READING {
                    owner.isSelectingStartDate.accept(true)
                } else if status == .DROP {
                    owner.isSelectingStartDate.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        Observable
            .of(input.datePickerButtonTap,
                input.customDatePickerBackgroundTap,
                input.customDatePickerCompleteButtonTap)
            .merge()
            .bind(with: self, onNext: { owner, _ in
                owner.showDatePicker.accept(!owner.showDatePicker.value)
            })
            .disposed(by: disposeBag)
        
        showDatePicker
            .bind(with: self, onNext: { owner, isShow in
                if isShow {
                    owner.internalStartDate.accept(owner.startDate.value)
                    owner.internalEndDate.accept(owner.endDate.value)
                }
            })
            .disposed(by: disposeBag)
        
        input.customDatePickerStartButtonTap
            .bind(with: self, onNext: { owner, _ in
                owner.isSelectingStartDate.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.customDatePickerEndButtonTap
            .bind(with: self, onNext: { owner, _ in
                owner.isSelectingStartDate.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.customDatePickerCompleteButtonTap
            .bind(with: self, onNext: { owner, _ in
                owner.startDate.accept(owner.internalStartDate.value)
                owner.endDate.accept(owner.internalEndDate.value)
            })
            .disposed(by: disposeBag)
        
        input.customDatePickerDateChanged
            .bind(with: self, onNext: { owner, date in
                var selectedDate = date
                if date > Date() {
                    owner.isOverToday.accept(true)
                    selectedDate = Date()
                } else {
                    owner.isOverToday.accept(false)
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
        
        return Output(
            scrollContentOffset: scrollContentOffset.asDriver(),
            backButtonTap: backButtonTap,
            novelBasicData: novelBasicData.asObservable(),
            isNew: isNew.asDriver(),
            starRating: starRating.asDriver(),
            readStatus: readStatus.asDriver(),
            isDateExist: isDateExist.asDriver(),
            showDatePicker: showDatePicker.asDriver(),
            isOverToday: isOverToday.asDriver(),
            isSelectingStartDate: isSelectingStartDate.asDriver(),
            startDate: startDate.asDriver(),
            endDate: endDate.asDriver(),
            internalStartDate: internalStartDate.asDriver(),
            internalEndDate: internalEndDate.asDriver()
        )
    }
    
    private func bindUserData(_ userData: EditNovelResult) {
        self.userNovelId = userData.userNovelID
        
        self.starRating.accept(userData.userNovelRating ?? minStarRating)
        let status = ReadStatus(rawValue: userData.userNovelReadStatus) ?? .FINISH
        var start = userData.userNovelReadDate.userNovelReadStartDate ?? ""
        var end = userData.userNovelReadDate.userNovelReadEndDate ?? ""
        
        if status == .READING {
            end = start
        } else if status == .DROP {
            start = end
        }
        
        self.readStatus.accept(status)
        self.isDateExist.accept(start != "" || end != "")
        self.startDate.accept( dateFormatter.date(from: start) ?? Date() )
        self.endDate.accept( dateFormatter.date(from: end) ?? Date() )
    }
}

struct NovelBasicData {
    let novelTitle, novelAuthor, novelGenre, novelImg: String
    let novelDescription: String
    let platforms: [UserNovelPlatform]
}
