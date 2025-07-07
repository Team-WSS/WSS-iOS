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
    
    private let viewDidLoadEvent = PublishRelay<Void>()
    private let stopEditingEvent = PublishRelay<Void>()
    
    private var photoPickerManager: PhotoPickerManager?
    private let maximumImageCount = FeedEdit.imageMaxCount
    
    //MARK: - Components
    
    private let rootView = FeedEditView()
    
    //MARK: - Life Cycle
    
    init(viewModel: FeedEditViewModel) {
        self.feedEditViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideTabBar()
        setNotificationCenter()
        register()
        delegate()
        bindViewModel()
        
        viewDidLoadEvent.accept(())
        
        AmplitudeManager.shared.track(AmplitudeEvent.Feed.write)
    }
    
    //MARK: - UI
    
    private func setNavigationBar() {
        self.setWSSNavigationBar(title: nil, left: self.rootView.backButton, right: self.rootView.completeButton)
    }
    
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    //MARK: - Bind
    
    private func register() {
        rootView.feedEditCategoryView.categoryCollectionView
            .register(FeedCategoryCollectionViewCell.self,
                      forCellWithReuseIdentifier: FeedCategoryCollectionViewCell.cellIdentifier)
        
        rootView.feedEditAddImageView.addImageCollectionView
            .register(FeedAddImageCollectionViewCell.self,
                      forCellWithReuseIdentifier: FeedAddImageCollectionViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.feedEditCategoryView.categoryCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        rootView.feedEditAddImageView.addImageCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = FeedEditViewModel.Input(
            viewDidLoadEvent: viewDidLoadEvent.asObservable(),
            viewDidTap: view.rx.tapGesture(configuration: { gestureRecognizer, _ in
                gestureRecognizer.cancelsTouchesInView = false
            }).when(.recognized)
                .filter { [weak self] gesture in
                    guard let self = self else { return false }
                    let location = gesture.location(in: self.rootView)
                    if let touchedView = self.rootView.hitTest(location, with: nil) {
                        return !touchedView.isDescendant(of: self.rootView.feedEditContentView.feedTextWrapperView)
                    }
                    return true
                }
                .asObservable(),
            backButtonDidTap: rootView.backButton.rx.tap,
            completeButtonDidTap: rootView.completeButton.rx.tap,
            spoilerButtonDidTap: rootView.feedEditContentView.spoilerView.spoilerButton.rx.tap,
            publicButtonDidTap: rootView.feedEditPrivateSettingView.privateSettingButton.rx.tap,
            categoryCollectionViewItemSelected: rootView.feedEditCategoryView.categoryCollectionView.rx.itemSelected.asObservable(),
            categoryCollectionViewItemDeselected: rootView.feedEditCategoryView.categoryCollectionView.rx.itemDeselected.asObservable(),
            feedContentUpdated: rootView.feedEditContentView.feedTextView.rx.text.orEmpty.distinctUntilChanged().asObservable(),
            feedContentViewDidBeginEditing: rootView.feedEditContentView.feedTextView.rx.didBeginEditing,
            feedContentViewDidEndEditing: rootView.feedEditContentView.feedTextView.rx.didEndEditing,
            novelConnectViewDidTap: rootView.feedEditNovelConnectView.rx.tapGesture().when(.recognized).asObservable(),
            feedNovelConnectedNotification: NotificationCenter.default.rx.notification(NotificationName.feedNovelConnected).asObservable(),
            novelRemoveButtonDidTap: rootView.feedEditConnectedNovelView.removeButton.rx.tap,
            stopEditButtonDidTap: stopEditingEvent.asObservable(),
            photoAddButtonDidTap: rootView.feedEditContentView.photoAddButton.rx.tap
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
                
                if self.feedEditViewModel.newRelevantCategories.contains(element) {
                    self.rootView.feedEditCategoryView.categoryCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                } else {
                    self.rootView.feedEditCategoryView.categoryCollectionView.deselectItem(at: indexPath, animated: false)
                }
                
                cell.bindData(category: element)
            }
            .disposed(by: disposeBag)
        
        output.popViewController
            .subscribe(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.initialFeedContent
            .subscribe(with: self, onNext: { owner, feedContent in
                owner.rootView.feedEditContentView.bindData(feedContent: feedContent)
            })
            .disposed(by: disposeBag)
        
        output.isSpoiler
            .subscribe(with: self, onNext: { owner, isSpoiler in
                owner.rootView.feedEditContentView.spoilerView.spoilerButton.updateToggle(isSpoiler)
            })
            .disposed(by: disposeBag)
        
        output.isPublic
            .subscribe(with: self, onNext: { owner, isPublic in
                owner.rootView.feedEditPrivateSettingView.privateSettingButton.updateToggle(!isPublic)
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
        
        output.presentFeedEditNovelConnectModalViewController
            .subscribe(with: self, onNext: { owner, _ in
                owner.presentModalViewController(FeedNovelConnectModalViewController(viewModel: FeedNovelConnectModalViewModel(searchRepository: DefaultSearchRepository(searchService: DefaultSearchService()))))
            })
            .disposed(by: disposeBag)
        
        output.connectedNovelTitle
            .subscribe(with: self, onNext: { owner, novelTitle in
                owner.rootView.feedEditConnectedNovelView.bindData(novelTitle: novelTitle)
            })
            .disposed(by: disposeBag)
        
        output.showAlreadyConnectedToast
            .subscribe(with: self, onNext: { owner, _ in
                owner.showToast(.novelAlreadyConnected)
            })
            .disposed(by: disposeBag)
        
        output.showStopEditingAlert
            .flatMapLatest { _ -> Observable<AlertButtonType> in
                return self.presentToAlertViewController(iconImage: .icModalWarning,
                                                         titleText: StringLiterals.FeedEdit.Alert.titleText,
                                                         contentText: nil,
                                                         leftTitle: StringLiterals.FeedEdit.Alert.stopTitle,
                                                         rightTitle: StringLiterals.FeedEdit.Alert.writeTitle,
                                                         rightBackgroundColor: UIColor.wssPrimary100.cgColor)
            }
            .subscribe(with: self, onNext: { owner, buttonType in
                if buttonType == .left {
                    owner.stopEditingEvent.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        output.presentPhotoPicker
            .flatMapLatest { [weak self] _ -> Observable<(newImages: [UIImage], currentImages: [UIImage])> in
                guard let self = self else { return .empty() }
                
                let manager = PhotoPickerManager(presentingViewController: self)
                self.photoPickerManager = manager
                
                let selected: Observable<(newImages: [UIImage], currentImages: [UIImage])> =
                manager.selectedImages
                    .withLatestFrom(output.selectedImages) { newImages, currentImages in
                        return (newImages: newImages, currentImages: currentImages)
                    }
                
                manager.presentPicker()
                return selected
            }
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in
                let (newImages, currentImages) = data
                
                if currentImages.count + newImages.count > owner.maximumImageCount {
                    owner.showToast(.limitAddImage(limitCount: owner.maximumImageCount))
                    return
                }
                
                let updatedImages = currentImages + newImages
                owner.feedEditViewModel.selectedImages.accept(updatedImages)
                owner.rootView.feedEditAddImageView.addImageCollectionView.reloadData()
                owner.rootView.showAddImages(hasImage: !updatedImages.isEmpty)
            })
            .disposed(by: disposeBag)
        
        output.showAddImageView
            .subscribe(with: self, onNext: { owner, isShow in
                owner.rootView.showAddImages(hasImage: isShow)
            })
            .disposed(by: disposeBag)
        
        output.selectedImages
            .bind(to: rootView.feedEditAddImageView.addImageCollectionView.rx.items(
                cellIdentifier: FeedAddImageCollectionViewCell.cellIdentifier,
                cellType: FeedAddImageCollectionViewCell.self)) { item, element, cell in
                    cell.bindData(image: element)
                    
                    cell.cancelButtonTapped = {
                        var currentImages = self.feedEditViewModel.selectedImages.value
                        guard item < currentImages.count else { return }
                        
                        currentImages.remove(at: item)
                        self.feedEditViewModel.selectedImages.accept(currentImages)
                        
                        DispatchQueue.main.async {
                            self.rootView.feedEditAddImageView.addImageCollectionView.reloadData()
                        }
                    }
                }
                .disposed(by: disposeBag)
        
        output.showLoadingView
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, isShow in
                owner.rootView.showloadingView(isLoading: isShow)
            })
            .disposed(by: disposeBag)
        
        output.backButtonIsAbled
            .subscribe(with: self, onNext: { owner, isAbled in
                owner.rootView.enableBackButton(isEnabled: isAbled)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        UIView.animate(withDuration: 0.3) {
            self.rootView.scrollView.contentInset.bottom = keyboardHeight
            
            let feedEditContentBottomY = self.rootView.feedEditContentView.convert(self.rootView.feedEditContentView.bounds, to: self.view).maxY
            let keyboardTopY = self.view.frame.height - keyboardHeight
            
            if feedEditContentBottomY > keyboardTopY {
                let offset = feedEditContentBottomY - keyboardTopY
                self.rootView.scrollView.contentOffset.y += offset
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.rootView.scrollView.contentInset.bottom = 30
        }
    }
}

extension FeedEditViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == rootView.feedEditCategoryView.categoryCollectionView {
            // 카테고리 컬렉션뷰에 대한 셀 사이즈 지정
            var text: String?
            
            text = self.feedEditViewModel.relevantCategoryList[indexPath.item].withKorean
            
            guard let unwrappedText = text else {
                return CGSize(width: 0, height: 0)
            }
            
            let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 26
            return CGSize(width: width, height: 35)
        } else {
            // 이외: 첨부 이미지 컬렉션뷰에 대한 셀 사이즈 지정
            return CGSize(width: 100, height: 100)
        }
    }
}
