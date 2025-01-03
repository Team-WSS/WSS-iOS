//
//  NovelReviewViewController.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 8/28/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

final class NovelReviewViewController: UIViewController {
    
    //MARK: - Properties
    
    private let novelReviewViewModel: NovelReviewViewModel
    private let disposeBag = DisposeBag()
    
    private let viewDidLoadEvent = PublishRelay<Void>()
    private let stopReviewingEvent = PublishRelay<Void>()
    
    //MARK: - Components
    
    private let rootView = NovelReviewView()
    
    //MARK: - Life Cycle
    
    init(viewModel: NovelReviewViewModel) {
        self.novelReviewViewModel = viewModel
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
        
        setNavigationBar()
        register()
        delegate()
        bindViewModel()
        
        viewDidLoadEvent.accept(())
    }
    
    //MARK: - UI
    
    private func setNavigationBar() {
        self.setNavigationBar(title: self.novelReviewViewModel.novelTitle, left: rootView.backButton, right: rootView.completeButton)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private func register() {
        rootView.novelReviewStatusView.statusCollectionView.register(NovelReviewStatusCollectionViewCell.self, forCellWithReuseIdentifier: NovelReviewStatusCollectionViewCell.cellIdentifier)
        rootView.novelReviewAttractivePointView.attractivePointCollectionView.register(NovelReviewAttractivePointCollectionViewCell.self, forCellWithReuseIdentifier: NovelReviewAttractivePointCollectionViewCell.cellIdentifier)
        rootView.novelReviewKeywordView.selectedKeywordCollectionView.register(NovelReviewSelectedKeywordCollectionViewCell.self, forCellWithReuseIdentifier: NovelReviewSelectedKeywordCollectionViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.novelReviewAttractivePointView.attractivePointCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        rootView.novelReviewKeywordView.selectedKeywordCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Bind
    
    private func bindViewModel() {
        let input = NovelReviewViewModel.Input(
            viewDidLoadEvent: viewDidLoadEvent.asObservable(),
            backButtonDidTap: rootView.backButton.rx.tap,
            completeButtonDidTap: rootView.completeButton.rx.tap,
            statusCollectionViewItemSelected: rootView.novelReviewStatusView.statusCollectionView.rx.itemSelected.asObservable(),
            dateLabelTapGesture: rootView.novelReviewStatusView.dateLabel.rx.tapGesture()
                .when(.recognized)
                .asObservable(),
            starRatingTapGesture: Observable.merge(
                rootView.novelReviewRatingView.starImageViews.enumerated().map { index, imageView in
                    imageView.rx.tapGesture()
                        .when(.recognized)
                        .map { recognizer in
                            let location = recognizer.location(in: imageView)
                            return (location, imageView.frame.width, index)
                        }
                }
            ),
            starRatingPanGesture: rootView.novelReviewRatingView.starImageStackView.rx.panGesture()
                .when(.changed)
                .map { recognizer in
                    let starImageStackView = self.rootView.novelReviewRatingView.starImageStackView
                    
                    let location = recognizer.location(in: starImageStackView)
                    let width = starImageStackView.frame.width
                    return (location, width)
                },
            attractivePointCollectionViewItemSelected: rootView.novelReviewAttractivePointView.attractivePointCollectionView.rx.itemSelected.asObservable(),
            attractivePointCollectionViewItemDeselected: rootView.novelReviewAttractivePointView.attractivePointCollectionView.rx.itemDeselected.asObservable(),
            keywordSearchViewDidTap: rootView.novelReviewKeywordView.keywordSearchBarView.rx.tapGesture().when(.recognized).asObservable(),
            selectedKeywordCollectionViewContentSize: rootView.novelReviewKeywordView.selectedKeywordCollectionView.rx.observe(CGSize.self, "contentSize"),
            selectedKeywordCollectionViewItemSelected: rootView.novelReviewKeywordView.selectedKeywordCollectionView.rx.itemSelected.asObservable(),
            novelReviewKeywordSelectedNotification: NotificationCenter.default.rx.notification(Notification.Name("NovelReviewKeywordSelected")).asObservable(),
            novelReviewDateSelectedNotification: NotificationCenter.default.rx.notification(Notification.Name("NovelReviewDateSelected")).asObservable(),
            novelReviewDateRemovedNotification: NotificationCenter.default.rx.notification(Notification.Name("NovelReviewDateRemoved")).asObservable(),
            stopReviewButtonDidTap: stopReviewingEvent.asObservable()
        )
        
        let output = self.novelReviewViewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.popViewController
            .subscribe(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.readStatusListData
            .bind(to: rootView.novelReviewStatusView.statusCollectionView.rx.items(cellIdentifier: NovelReviewStatusCollectionViewCell.cellIdentifier, cellType: NovelReviewStatusCollectionViewCell.self)) { item, element, cell in
                let indexPath = IndexPath(item: item, section: 0)
                
                if self.novelReviewViewModel.readStatus == element {
                    self.rootView.novelReviewStatusView.statusCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                } else {
                    self.rootView.novelReviewStatusView.statusCollectionView.deselectItem(at: indexPath, animated: false)
                }
                cell.bindData(status: element)
            }
            .disposed(by: disposeBag)
        
        output.presentNovelDateSelectModalViewController
            .subscribe(with: self, onNext: { owner, tuple in
                let (readStatus, startDate, endDate) = tuple
                owner.presentModalViewController(NovelDateSelectModalViewController(viewModel: NovelDateSelectModalViewModel(readStatus: readStatus, startDate: startDate, endDate: endDate)))
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(output.readStatusData, output.startDateEndDateData)
            .subscribe(with: self, onNext: { owner, combinedData in
                let (readStatus, startDateEndDate) = combinedData
                owner.rootView.novelReviewStatusView.bindData(readStatus: readStatus,
                                                              startDate: startDateEndDate[0],
                                                              endDate: startDateEndDate[1])

            })
            .disposed(by: disposeBag)
        
        output.starRating
            .subscribe(with: self, onNext: { owner, rating in
                owner.rootView.novelReviewRatingView.updateStarImages(rating: rating)
            })
            .disposed(by: disposeBag)
        
        output.attractivePointListData
            .bind(to: rootView.novelReviewAttractivePointView.attractivePointCollectionView.rx.items(cellIdentifier: NovelReviewAttractivePointCollectionViewCell.cellIdentifier, cellType: NovelReviewAttractivePointCollectionViewCell.self)) { item, element, cell in
                let indexPath = IndexPath(item: item, section: 0)
                
                if self.novelReviewViewModel.selectedAttractivePointList.contains(element.rawValue) {
                    self.rootView.novelReviewAttractivePointView.attractivePointCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                } else {
                    self.rootView.novelReviewAttractivePointView.attractivePointCollectionView.deselectItem(at: indexPath, animated: false)
                }
                cell.bindData(attractivePoint: element)
            }
            .disposed(by: disposeBag)
        
        output.isAttractivePointCountOverLimit
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.rootView.novelReviewAttractivePointView.attractivePointCollectionView.deselectItem(at: indexPath, animated: false)
                owner.showToast(.selectionOverLimit(count: 3))
            })
            .disposed(by: disposeBag)
        
        output.presentNovelKeywordSelectModalViewController
            .subscribe(with: self, onNext: { owner, selectedKeywordList in
                owner.presentModalViewController(NovelKeywordSelectModalViewController(viewModel: NovelKeywordSelectModalViewModel(keywordRepository: DefaultKeywordRepository(keywordService: DefaultKeywordService()), selectedKeywordList: selectedKeywordList)))
            })
            .disposed(by: disposeBag)
        
        output.selectedKeywordListData
            .bind(to: rootView.novelReviewKeywordView.selectedKeywordCollectionView.rx.items(cellIdentifier: NovelReviewSelectedKeywordCollectionViewCell.cellIdentifier, cellType: NovelReviewSelectedKeywordCollectionViewCell.self)) { item, element, cell in
                cell.bindData(keyword: element)
            }
        .disposed(by: disposeBag)
        
        output.selectedKeywordCollectionViewHeight
            .subscribe(with: self, onNext: { owner, height in
                owner.rootView.novelReviewKeywordView.updateCollectionViewHeight(height: height)
            })
            .disposed(by: disposeBag)
        
        output.showStopReviewingAlert
            .flatMapLatest { _ -> Observable<AlertButtonType> in
                return self.presentToAlertViewController(iconImage: .icModalWarning,
                                                         titleText: StringLiterals.NovelReview.Alert.titleText,
                                                         contentText: nil,
                                                         leftTitle: StringLiterals.NovelReview.Alert.stopTitle,
                                                         rightTitle: StringLiterals.NovelReview.Alert.writeTitle,
                                                         rightBackgroundColor: UIColor.wssPrimary100.cgColor)
            }
            .subscribe(with: self, onNext: { owner, buttonType in
                if buttonType == .left {
                    owner.stopReviewingEvent.accept(())
                }
            })
            .disposed(by: disposeBag)
    }
}

extension NovelReviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.rootView.novelReviewAttractivePointView.attractivePointCollectionView {
            var text: String?
            
            let attractivePointList = AttractivePoint.allCases.map { $0.koreanString }
            text = attractivePointList[indexPath.item]
            
            guard let unwrappedText = text else {
                return CGSize(width: 0, height: 0)
            }
            
            let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 26
            return CGSize(width: width, height: 35)
        } else if collectionView == self.rootView.novelReviewKeywordView.selectedKeywordCollectionView {
            var text: String?
            
            text = self.novelReviewViewModel.selectedKeywordListData.value[indexPath.item].keywordName
            
            guard let unwrappedText = text else {
                return CGSize(width: 0, height: 0)
            }
            
            let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 52
            return CGSize(width: width, height: 35)
        } else {
            return CGSize()
        }
    }
}
