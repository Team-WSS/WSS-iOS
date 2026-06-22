//
//  LibraryFilterViewModel.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/22/26.
//

import UIKit

import RxSwift
import RxCocoa

final class LibraryFilterViewModel: ViewModelType {

    //MARK: - Properties

    private let initialFilterOption: LibraryFilterOption

    private let selectedTab: BehaviorRelay<LibraryFilterTab>
    private let readStatusOptions = BehaviorRelay<[ReadStatus]>(value: [])
    private let genreOptions = BehaviorRelay<[NovelGenre]>(value: [])
    private let publicationStatusOptions = BehaviorRelay<[PublicationStatus]>(value: [])
    private let attractivePointOptions = BehaviorRelay<[AttractivePoint]>(value: [])
    private let keywordOptions = BehaviorRelay<[KeywordData]>(value: [])
    private let minRating = BehaviorRelay<CGFloat>(value: 0.0)
    private let maxRating = BehaviorRelay<CGFloat>(value: 5.0)
    private let notStarRated = BehaviorRelay<Bool>(value: false)

    /// 선택한 순서대로 칩을 노출하기 위한 선택 순서 추적 (탭 순서와 무관)
    private let chipOrder: BehaviorRelay<[LibraryFilterChip.Category]>

    // TODO: 서버 키워드 칩 목록 API 연동 후 교체
    private let keywordListData = BehaviorRelay<[KeywordData]>(
        value: ["웹툰화", "드라마화", "차원이동", "회귀", "빙의", "환생", "정통", "신화", "삼국지", "성장", "모험", "게임", "헌터/레이드", "성좌", "던전", "좀비", "히어로/빌런", "TS", "상태창/시스템", "탑등반", "신/종교", "초능력", "마법/정령"]
            .enumerated()
            .map { KeywordData(keywordId: $0.offset,
                               keywordName: $0.element) }
    )

    // Output

    private let selectedChips = BehaviorRelay<[LibraryFilterChip]>(value: [])
    private let activeTabs = BehaviorRelay<Set<LibraryFilterTab>>(value: [])
    private let dismissWithResult = PublishRelay<LibraryFilterOption>()

    //MARK: - Life Cycle

    init(libraryFilterOption: LibraryFilterOption,
         initialTab: LibraryFilterTab = .readStatus) {
        self.initialFilterOption = libraryFilterOption
        self.selectedTab = BehaviorRelay(value: initialTab)

        readStatusOptions.accept(libraryFilterOption.readStatusOptions)
        genreOptions.accept(libraryFilterOption.genreOptions)
        publicationStatusOptions.accept(libraryFilterOption.publicationStatusOptions)
        attractivePointOptions.accept(libraryFilterOption.attractivePointOptions)
        keywordOptions.accept(libraryFilterOption.keywordOptions)
        minRating.accept(libraryFilterOption.minimumStarRateOption)
        maxRating.accept(libraryFilterOption.maximumStarRateOption)
        notStarRated.accept(libraryFilterOption.notStarRatedOption)

        self.chipOrder = BehaviorRelay(value: Self.initialChipOrder(from: libraryFilterOption))
    }

    struct Input {
        let tabTapped: Observable<LibraryFilterTab>
        let readStatusButtonTapped: Observable<ReadStatus>
        let attractivePointButtonTapped: Observable<AttractivePoint>
        let publicationStatusButtonTapped: Observable<PublicationStatus>
        let genreSelected: Observable<IndexPath>
        let keywordSelected: Observable<IndexPath>
        let ratingChanged: Observable<(CGFloat, CGFloat)>
        let notRatedTapped: Observable<Void>
        let chipSelected: Observable<IndexPath>
        let resetButtonDidTap: ControlEvent<Void>
        let dismissButtonDidTap: ControlEvent<Void>
        let searchButtonDidTap: ControlEvent<Void>
    }

    struct Output {
        let selectedTab: Observable<LibraryFilterTab>
        let readStatusOptions: Observable<[ReadStatus]>
        let genreOptions: Observable<[NovelGenre]>
        let publicationStatusOptions: Observable<[PublicationStatus]>
        let attractivePointOptions: Observable<[AttractivePoint]>
        let keywordListData: Observable<[KeywordData]>
        let keywordSelection: Observable<[KeywordData]>
        let ratingState: Observable<(CGFloat, CGFloat, Bool)>
        let selectedChips: Observable<[LibraryFilterChip]>
        let activeTabs: Observable<Set<LibraryFilterTab>>
        let dismissWithResult: Observable<LibraryFilterOption>
    }

    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.tabTapped
            .bind(to: selectedTab)
            .disposed(by: disposeBag)

        input.readStatusButtonTapped
            .bind(with: self, onNext: { owner, item in
                owner.toggleOption(item, relay: owner.readStatusOptions) { .readStatus($0) }
            })
            .disposed(by: disposeBag)

        input.attractivePointButtonTapped
            .bind(with: self, onNext: { owner, item in
                owner.toggleOption(item, relay: owner.attractivePointOptions) { .attractivePoint($0) }
            })
            .disposed(by: disposeBag)

        input.publicationStatusButtonTapped
            .bind(with: self, onNext: { owner, item in
                owner.toggleOption(item, relay: owner.publicationStatusOptions) { .publicationStatus($0) }
            })
            .disposed(by: disposeBag)

        input.genreSelected
            .bind(with: self, onNext: { owner, indexPath in
                let genres = NovelGenre.detailSearchGenres
                guard indexPath.item < genres.count else { return }
                owner.toggleOption(genres[indexPath.item], relay: owner.genreOptions) { .genre($0) }
            })
            .disposed(by: disposeBag)

        input.keywordSelected
            .bind(with: self, onNext: { owner, indexPath in
                let keywords = owner.keywordListData.value
                guard indexPath.item < keywords.count else { return }
                owner.toggleOption(keywords[indexPath.item], relay: owner.keywordOptions) { .keyword($0) }
            })
            .disposed(by: disposeBag)

        input.ratingChanged
            .withLatestFrom(notStarRated) { ($0, $1) }
            .filter { _, isNotStarRated in
                return !isNotStarRated
            }
            .bind(with: self, onNext: { owner, value in
                let (rating, _) = value
                owner.updateRating(lower: rating.0, upper: rating.1)
            })
            .disposed(by: disposeBag)

        input.notRatedTapped
            .bind(with: self, onNext: { owner, _ in
                owner.toggleNotRated()
            })
            .disposed(by: disposeBag)

        input.chipSelected
            .bind(with: self, onNext: { owner, indexPath in
                let chips = owner.makeChips()
                guard indexPath.item < chips.count else { return }
                owner.removeChip(chips[indexPath.item])
            })
            .disposed(by: disposeBag)

        input.resetButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                owner.resetFilterOptions()
            })
            .disposed(by: disposeBag)

        input.dismissButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                owner.dismissWithResult.accept(owner.initialFilterOption)
            })
            .disposed(by: disposeBag)

        input.searchButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                owner.dismissWithResult.accept(owner.makeResultOption())
            })
            .disposed(by: disposeBag)

        // 칩(선택 순서) + 탭 점 인디케이터 — chipOrder + 별점 값에 반응
        Observable.combineLatest(chipOrder,
                                 minRating,
                                 maxRating,
                                 notStarRated)
            .bind(with: self, onNext: { owner, _ in
                owner.selectedChips.accept(owner.makeChips())
                owner.activeTabs.accept(owner.makeActiveTabs())
            })
            .disposed(by: disposeBag)

        let ratingState = Observable.combineLatest(minRating,
                                                   maxRating,
                                                   notStarRated)

        return Output(selectedTab: selectedTab.asObservable(),
                      readStatusOptions: readStatusOptions.asObservable(),
                      genreOptions: genreOptions.asObservable(),
                      publicationStatusOptions: publicationStatusOptions.asObservable(),
                      attractivePointOptions: attractivePointOptions.asObservable(),
                      keywordListData: keywordListData.asObservable(),
                      keywordSelection: keywordOptions.asObservable(),
                      ratingState: ratingState,
                      selectedChips: selectedChips.asObservable(),
                      activeTabs: activeTabs.asObservable(),
                      dismissWithResult: dismissWithResult.asObservable())
    }

    //MARK: - Custom Method

    /// 옵션 토글 + 선택 순서(chipOrder) 동기화
    private func toggleOption<Option: Equatable>(_ option: Option,
                                                 relay: BehaviorRelay<[Option]>,
                                                 category: (Option) -> LibraryFilterChip.Category) {
        var currentOptions = relay.value
        var order = chipOrder.value
        let key = category(option)

        if let index = currentOptions.firstIndex(of: option) {
            currentOptions.remove(at: index)
            order.removeAll { $0 == key }
        } else {
            currentOptions.append(option)
            order.append(key)
        }

        relay.accept(currentOptions)
        chipOrder.accept(order)
    }

    private func updateRating(lower: CGFloat, upper: CGFloat) {
        minRating.accept(lower)
        maxRating.accept(upper)
        reconcileRatingOrder()
    }

    private func toggleNotRated() {
        let isOn = !notStarRated.value
        notStarRated.accept(isOn)

        if isOn {
            minRating.accept(0.0)
            maxRating.accept(5.0)
        }

        reconcileRatingOrder()
    }

    /// 별점 칩(.rating)의 활성 여부에 따라 chipOrder를 동기화
    private func reconcileRatingOrder() {
        var order = chipOrder.value
        let contains = order.contains(.rating)

        if isRatingActive {
            if !contains { order.append(.rating) }
        } else {
            order.removeAll { $0 == .rating }
        }

        chipOrder.accept(order)
    }

    private func removeChip(_ chip: LibraryFilterChip) {
        switch chip.category {
        case .readStatus(let readStatus):
            toggleOption(readStatus, relay: readStatusOptions) { .readStatus($0) }
        case .genre(let genre):
            toggleOption(genre, relay: genreOptions) { .genre($0) }
        case .publicationStatus(let publicationStatus):
            toggleOption(publicationStatus, relay: publicationStatusOptions) { .publicationStatus($0) }
        case .attractivePoint(let attractivePoint):
            toggleOption(attractivePoint, relay: attractivePointOptions) { .attractivePoint($0) }
        case .keyword(let keyword):
            toggleOption(keyword, relay: keywordOptions) { .keyword($0) }
        case .rating:
            minRating.accept(0.0)
            maxRating.accept(5.0)
            notStarRated.accept(false)
            reconcileRatingOrder()
        }
    }

    private func resetFilterOptions() {
        readStatusOptions.accept([])
        genreOptions.accept([])
        publicationStatusOptions.accept([])
        minRating.accept(0.0)
        maxRating.accept(5.0)
        notStarRated.accept(false)
        attractivePointOptions.accept([])
        keywordOptions.accept([])
        chipOrder.accept([])
    }

    private func makeResultOption() -> LibraryFilterOption {
        return LibraryFilterOption(
            interestedOption: initialFilterOption.interestedOption,
            readStatusOptions: readStatusOptions.value,
            genreOptions: genreOptions.value,
            publicationStatusOptions: publicationStatusOptions.value,
            minimumStarRateOption: minRating.value,
            maximumStarRateOption: maxRating.value,
            notStarRatedOption: notStarRated.value,
            attractivePointOptions: attractivePointOptions.value,
            keywordOptions: keywordOptions.value
        )
    }

    /// 선택 순서의 역순으로 칩 생성 (나중에 선택한 게 앞, 먼저 선택한 게 뒤)
    private func makeChips() -> [LibraryFilterChip] {
        return chipOrder.value.reversed().map { category in
            LibraryFilterChip(category: category, title: title(for: category))
        }
    }

    private func makeActiveTabs() -> Set<LibraryFilterTab> {
        return Set(chipOrder.value.map { tab(for: $0) })
    }

    private var isRatingActive: Bool {
        return notStarRated.value || minRating.value != 0.0 || maxRating.value != 5.0
    }

    private func title(for category: LibraryFilterChip.Category) -> String {
        switch category {
        case .readStatus(let readStatus):
            return readStatus.statusName
        case .genre(let genre):
            return genre.withKorean
        case .publicationStatus(let publicationStatus):
            return publicationStatus.description
        case .attractivePoint(let attractivePoint):
            return attractivePoint.koreanString
        case .keyword(let keyword):
            return keyword.keywordName
        case .rating:
            if notStarRated.value {
                return "별점 없음"
            }
            return "\(String(format: "%.1f", minRating.value))~\(String(format: "%.1f", maxRating.value))"
        }
    }

    private func tab(for category: LibraryFilterChip.Category) -> LibraryFilterTab {
        switch category {
        case .readStatus: return .readStatus
        case .genre: return .genre
        case .publicationStatus: return .publicationStatus
        case .rating: return .rating
        case .attractivePoint: return .attractivePoint
        case .keyword: return .keyword
        }
    }

    private static func initialChipOrder(from option: LibraryFilterOption) -> [LibraryFilterChip.Category] {
        var order: [LibraryFilterChip.Category] = []
        order.append(contentsOf: option.readStatusOptions.map { .readStatus($0) })
        order.append(contentsOf: option.genreOptions.map { .genre($0) })
        order.append(contentsOf: option.publicationStatusOptions.map { .publicationStatus($0) })
        if option.notStarRatedOption || option.minimumStarRateOption != 0.0 || option.maximumStarRateOption != 5.0 {
            order.append(.rating)
        }
        order.append(contentsOf: option.attractivePointOptions.map { .attractivePoint($0) })
        order.append(contentsOf: option.keywordOptions.map { .keyword($0) })
        return order
    }
}
