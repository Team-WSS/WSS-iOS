//
//  FeedEditViewController.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 6/29/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

final class FeedEditViewController: UIViewController {
    
    //MARK: - Properties
    
    private let feedEditViewModel: FeedEditViewModel
    private let disposeBag = DisposeBag()
    
    private let viewWillAppearEvent = PublishRelay<Void>()
    
    //MARK: - Components

    private let rootView = FeedEditView()

    //MARK: - Life Cycle
    
    init(viewModel: FeedEditViewModel) {
        self.feedEditViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.rootView.feedEditContentView.bindData(isSpoiler: viewModel.isSpoiler)
        if let initialFeedContent = viewModel.initialFeedContent {
            self.rootView.feedEditContentView.bindData(feedContent: initialFeedContent)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

     override func loadView() {
         self.view = rootView
     }

     override func viewDidLoad() {
         super.viewDidLoad()
         
         hideTabBar()
         setNavigationBar()
         register()
         delegate()
         bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewWillAppearEvent.accept(())
    }
    
    //MARK: - UI
    
    private func setNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.rootView.backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.rootView.completeButton)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = .wssWhite
    }
    
    private func register() {
        rootView.feedEditCategoryView.categoryCollectionView.register(FeedCategoryCollectionViewCell.self, forCellWithReuseIdentifier: FeedCategoryCollectionViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.feedEditCategoryView.categoryCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }

    //MARK: - Bind
    
    private func bindViewModel() {
        let input = FeedEditViewModel.Input(
            viewWillAppearEvent: viewWillAppearEvent.asObservable(),
            viewDidTap: view.rx.tapGesture(configuration: { gestureRecognizer, delegate in
                gestureRecognizer.cancelsTouchesInView = false
            }).when(.recognized).asObservable(),
            backButtonDidTap: rootView.backButton.rx.tap,
            completeButtonDidTap: rootView.completeButton.rx.tap,
            spoilerButtonDidTap: rootView.feedEditContentView.spoilerButton.rx.tap,
            categoryCollectionViewItemSelected: rootView.feedEditCategoryView.categoryCollectionView.rx.itemSelected.asObservable(),
            categoryCollectionViewItemDeselected: rootView.feedEditCategoryView.categoryCollectionView.rx.itemDeselected.asObservable(),
            feedContentUpdated: rootView.feedEditContentView.feedTextView.rx.text.orEmpty.asObservable(),
            feedContentViewDidBeginEditing: rootView.feedEditContentView.feedTextView.rx.didBeginEditing,
            feedContentViewDidEndEditing: rootView.feedEditContentView.feedTextView.rx.didEndEditing
        )
        
        let output = self.feedEditViewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.endEditing
            .subscribe(with: self, onNext: { owner, endEditing in
                owner.view.endEditing(endEditing)
            })
            .disposed(by: disposeBag)
        
        output.categoryListData.bind(to: rootView.feedEditCategoryView.categoryCollectionView.rx.items(
            cellIdentifier: FeedCategoryCollectionViewCell.cellIdentifier,
            cellType: FeedCategoryCollectionViewCell.self)) { item, element, cell in
                let indexPath = IndexPath(item: item, section: 0)
                
                //TODO: - 성별에 따른 리스트는 추후 구현
                if let englishCategory = FeedDetailWomanKoreanGenre(rawValue: element)?.toEnglish {
                    if self.feedEditViewModel.relevantCategories.contains(englishCategory) {
                        self.rootView.feedEditCategoryView.categoryCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                    } else {
                        self.rootView.feedEditCategoryView.categoryCollectionView.deselectItem(at: indexPath, animated: false)
                    }
                }
                
                cell.bindData(category: element)
            }
            .disposed(by: disposeBag)
        
        output.popViewController
            .subscribe(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.isSpoiler
            .subscribe(with: self, onNext: { owner, hasSpoiler in
                owner.rootView.feedEditContentView.spoilerButton.updateToggle(hasSpoiler)
            })
            .disposed(by: disposeBag)
        
        output.feedContentWithLengthLimit
            .subscribe(with: self, onNext: { owner, feedContentWithLengthLimit in
                owner.rootView.feedEditContentView.bindData(feedContent: feedContentWithLengthLimit)
            })
            .disposed(by: disposeBag)
        
        output.completeButtonIsAbled
            .subscribe(with: self, onNext: { owner, isAbled in
                owner.rootView.enableCompleteButton(isAbled: isAbled)
            })
            .disposed(by: disposeBag)
        
        output.showPlaceholder
            .subscribe(with: self, onNext: { owner, showPlaceholder in
                owner.rootView.feedEditContentView.placeholderLabel.isHidden = !showPlaceholder
            })
            .disposed(by: disposeBag)
    }
}

extension FeedEditViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var text: String?
        
        text = self.feedEditViewModel.relevantCategoryList[indexPath.item]
        
        guard let unwrappedText = text else {
            return CGSize(width: 0, height: 0)
        }
        
        let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 26
        return CGSize(width: width, height: 37)
    }
}
