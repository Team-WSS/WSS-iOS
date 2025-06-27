//
//  FeedFilterViewController.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/26/25.
//

import UIKit

import RxCocoa
import RxSwift
import RxRelay
import SnapKit
import Then

final class FeedFilterViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let initialFilterOption: FeedFilterOption
    let filterOption = PublishSubject<FeedFilterOption>()
    private let genreOptions = BehaviorRelay<[NewNovelGenre]>(value: NewNovelGenre.feedFilterGenres)
    private let visibilityOptions = BehaviorRelay<[FeedVisibilityOption]>(value: FeedVisibilityOption.allCases)
    
    //MARK: - Components
    
    private let rootView = FeedFilterView()
    
    // MARK: - Life Cycle
    
    init(feedFilterOption: FeedFilterOption) {
        self.initialFilterOption = feedFilterOption
        genreOptions.accept(feedFilterOption.genres)
        visibilityOptions.accept(feedFilterOption.visibilityOptions)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
        delegate()
        
        bindInput()
        bindAction()
        bindOutput()
        
        AmplitudeManager.shared.track(AmplitudeEvent.Feed.feedAll)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: - Bind
    
    private func register() {
        rootView.genreView.genreCollectionView
            .register(FeedFilterGenreCollectionViewCell.self,
                      forCellWithReuseIdentifier: FeedFilterGenreCollectionViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.genreView.genreCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindInput() {
        Observable.merge(
            rootView.visibilityView.publicOptionView.optionButton.rx.tap.map { FeedVisibilityOption.public },
            rootView.visibilityView.privateOptionView.optionButton.rx.tap.map { FeedVisibilityOption.private }
        )
        .withLatestFrom(visibilityOptions) { tapped, current in
            (tapped, current)
        }
        .map { tapped, current in
            var updated = current
            
            if let index = updated.firstIndex(of: tapped) {
                updated.remove(at: index)
            } else {
                updated.append(tapped)
            }

            if updated.isEmpty {
                updated.append(tapped.opposite)
            }

            return updated
        }
        .bind(to: visibilityOptions)
        .disposed(by: disposeBag)
        
        Observable.merge(
            rootView.genreView.genreCollectionView.rx.itemSelected.asObservable(),
            rootView.genreView.genreCollectionView.rx.itemDeselected.asObservable()
        )
        .subscribe(with: self, onNext: { owner, _ in
            let selectedIndexPaths = owner.rootView.genreView.genreCollectionView.indexPathsForSelectedItems ?? []
            let selectedGenres = selectedIndexPaths.map { indexPath in
                NewNovelGenre.feedFilterGenres[indexPath.row]
            }
            
            owner.genreOptions.accept(selectedGenres)
        })
        .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        Observable<[NewNovelGenre]>.just(NewNovelGenre.feedFilterGenres)
            .bind(to: rootView.genreView.genreCollectionView.rx.items(
                cellIdentifier: FeedFilterGenreCollectionViewCell.cellIdentifier,
                cellType: FeedFilterGenreCollectionViewCell .self)) { item, element, cell in
                    
                    let isSelected = self.genreOptions.value.contains(element)
                    let indexPath = IndexPath(item: item, section: 0)
                    
                    if isSelected {
                        self.rootView.genreView.genreCollectionView.selectItem(
                            at: indexPath,
                            animated: false,
                            scrollPosition: []
                        )
                    }
                    
                    cell.bindData(genre: element.withKorean)
                }
                .disposed(by: disposeBag)
        
        visibilityOptions
            .asDriver()
            .drive(with: self, onNext: { owner, options in
                owner.rootView.visibilityView.updateVisibilityOptionButtons(selectedOptions: options)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAction() {
        rootView.dismissButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.filterOption.onNext(owner.initialFilterOption)
                owner.filterOption.onCompleted()
                owner.dismissModalViewController()
            })
            .disposed(by: disposeBag)
        
        let filterOption = Observable.combineLatest(genreOptions, visibilityOptions)
            .map { genres, visibilities in
                FeedFilterOption(genres: genres, visibilityOptions: Array(visibilities))
            }
        
        rootView.bottomButton.rx.tap
            .withLatestFrom(filterOption)
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, filterOption in
                owner.filterOption.onNext(filterOption)
                owner.filterOption.onCompleted()
                owner.dismissModalViewController()
            })
            .disposed(by: disposeBag)
    }
}

extension FeedFilterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var text: String?
        
        let novelGenreList = NewNovelGenre.feedFilterGenres.map { $0.withKorean }
        text = novelGenreList[indexPath.item]
        
        guard let unwrappedText = text else {
            return CGSize(width: 0, height: 0)
        }
        
        let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 26
        return CGSize(width: width, height: 37)
    }
}
