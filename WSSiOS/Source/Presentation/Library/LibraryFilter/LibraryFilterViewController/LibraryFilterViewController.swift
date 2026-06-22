//
//  LibraryFilterViewController.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/26/25.
//

import UIKit

import RxSwift
import RxCocoa

final class LibraryFilterViewController: UIViewController {

    //MARK: - Properties

    private let libraryFilterViewModel: LibraryFilterViewModel
    private let disposeBag = DisposeBag()

    private let viewWillAppearRelay = PublishRelay<Void>()

    let filterOption = PublishSubject<LibraryFilterOption>()

    //MARK: - Components

    private let rootView = LibraryFilterView()

    //MARK: - Life Cycle

    init(viewModel: LibraryFilterViewModel) {
        self.libraryFilterViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewWillAppearRelay.accept(())
    }

    //MARK: - Bind

    private func bindViewModel() {
        let input = LibraryFilterViewModel.Input(
            viewWillAppear: viewWillAppearRelay.asObservable(),
            tabTapped: Observable.merge(
                rootView.tabBarView.tabButtons.map { button in
                    button.rx.tap.map { button.tab }
                }
            ),
            readStatusButtonTapped: Observable.merge(
                rootView.readStatusView.readStatusOptionButtons.map { button in
                    button.rx.tap.map { button.readStatus }
                }
            ),
            attractivePointButtonTapped: Observable.merge(
                rootView.attractivePointView.attractivePointOptionButtons.map { button in
                    button.rx.tap.map { button.attractivePoint }
                }
            ),
            publicationStatusButtonTapped: Observable.merge(
                rootView.publicationStatusView.statusButtons.map { button in
                    button.rx.tap.map { button.status }
                }
            ),
            genreSelected: rootView.genreView.collectionView.rx.itemSelected.asObservable(),
            keywordSelected: rootView.keywordView.collectionView.rx.itemSelected.asObservable(),
            ratingChanged: rootView.ratingView.ratingChanged,
            notRatedTapped: rootView.ratingView.notRatedTapped,
            chipSelected: rootView.selectedChipsView.collectionView.rx.itemSelected.asObservable(),
            resetButtonDidTap: rootView.bottomActionView.resetButton.rx.tap,
            dismissButtonDidTap: rootView.dismissButton.rx.tap,
            searchButtonDidTap: rootView.bottomActionView.searchButton.rx.tap
        )

        let output = libraryFilterViewModel.transform(from: input, disposeBag: disposeBag)

        output.selectedTab
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self, onNext: { owner, selectedTab in
                owner.rootView.showTab(selectedTab)
                owner.rootView.tabBarView.updateSelectedTab(selectedTab)
            })
            .disposed(by: disposeBag)

        output.readStatusOptions
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self, onNext: { owner, selectedOptions in
                owner.rootView.readStatusView.updateButtons(selectedOptions: selectedOptions)
            })
            .disposed(by: disposeBag)

        output.genreOptions
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self, onNext: { owner, selectedGenres in
                owner.rootView.genreView.updateSelection(selectedGenres)
            })
            .disposed(by: disposeBag)

        output.publicationStatusOptions
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self, onNext: { owner, selectedOptions in
                owner.rootView.publicationStatusView.updateSelection(selectedOptions)
            })
            .disposed(by: disposeBag)

        output.attractivePointOptions
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self, onNext: { owner, selectedOptions in
                owner.rootView.attractivePointView.updateButtons(selectedOptions: selectedOptions)
            })
            .disposed(by: disposeBag)

        output.keywordListData
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self, onNext: { owner, keywords in
                owner.rootView.keywordView.setKeywords(keywords)
            })
            .disposed(by: disposeBag)

        output.keywordSelection
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self, onNext: { owner, selectedKeywords in
                owner.rootView.keywordView.updateSelection(selectedKeywords)
            })
            .disposed(by: disposeBag)

        output.ratingState
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self, onNext: { owner, ratingState in
                let (minimumRating, maximumRating, isNotStarRated) = ratingState
                owner.rootView.ratingView.setNotRated(isNotStarRated)

                if !isNotStarRated {
                    owner.rootView.ratingView.setValues(lower: minimumRating,
                                                        upper: maximumRating)
                }
            })
            .disposed(by: disposeBag)

        output.selectedChips
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self, onNext: { owner, chips in
                owner.rootView.updateChips(chips)
            })
            .disposed(by: disposeBag)

        output.activeTabs
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self, onNext: { owner, activeTabs in
                owner.rootView.tabBarView.updateDots(activeTabs)
            })
            .disposed(by: disposeBag)

        output.dismissWithResult
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self, onNext: { owner, result in
                owner.filterOption.onNext(result)
                owner.filterOption.onCompleted()
                owner.dismissModalViewController()
            })
            .disposed(by: disposeBag)
    }
}
