//
//  FeedDetailViewController.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 6/23/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard
import RxGesture

final class FeedDetailViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: FeedDetailViewModel
    private let disposeBag = DisposeBag()
    
    private let commentDotsButtonDidTap = PublishRelay<(Int, Bool)>()
    private let maximumCommentContentCount: Int = 500
    
    //MARK: - UI Components
    
    private let rootView = FeedDetailView()
    
    // MARK: - Life Cycle
    
    init(viewModel: FeedDetailViewModel) {
        self.viewModel = viewModel
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
        
        hideTabBar()
        setNavigationBar()
        swipeBackGesture()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        registerCell()
        delegate()
    }
    
    //MARK: - UI
    
    private func setNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.titleView = self.rootView.viewTitleLabel
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.rootView.backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.rootView.dropdownButton)
    }
    
    //MARK: - Bind
    
    private func registerCell() {
        rootView.replyView.replyCollectionView.register(FeedDetailReplyCollectionViewCell.self,
                                                        forCellWithReuseIdentifier: FeedDetailReplyCollectionViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.replyView.replyCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        rootView.replyWritingView.replyWritingTextView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let viewDidTap = view.rx.tapGesture(configuration: { gestureRecognizer, delegate in
            gestureRecognizer.cancelsTouchesInView = false })
            .when(.recognized)
            .asObservable()
        
        let replyCommentCollectionViewSwipeGesture = rootView.scrollView.rx.swipeGesture([.up, .down])
            .when(.recognized)
            .asObservable()
        
        let dropdownButtonDidTap = Observable.merge(
            rootView.dropdownView.topDropdownButton.rx.tap.map { DropdownButtonType.top },
            rootView.dropdownView.bottomDropdownButton.rx.tap.map { DropdownButtonType.bottom }
        )
        
        let commentDropdownButtonDidTap = Observable.merge(
            rootView.replyView.dropdownView.topDropdownButton.rx.tap.map { DropdownButtonType.top },
            rootView.replyView.dropdownView.bottomDropdownButton.rx.tap.map { DropdownButtonType.bottom }
        )
        
        let input = FeedDetailViewModel.Input(
            backButtonDidTap: rootView.backButton.rx.tap,
            replyCollectionViewContentSize: rootView.replyView.replyCollectionView.rx.observe(CGSize.self, "contentSize"),
            likeButtonDidTap: rootView.feedContentView.reactView.likeButton.rx.tap,
            linkNovelViewDidTap: rootView.feedContentView.linkNovelView.rx.tapGesture().when(.recognized).asObservable(),
            viewDidTap: viewDidTap,
            commentContentUpdated: rootView.replyWritingView.replyWritingTextView.rx.text.orEmpty.distinctUntilChanged().asObservable(),
            commentContentViewDidBeginEditing: rootView.replyWritingView.replyWritingTextView.rx.didBeginEditing,
            commentContentViewDidEndEditing: rootView.replyWritingView.replyWritingTextView.rx.didEndEditing,
            replyCommentCollectionViewSwipeGesture: replyCommentCollectionViewSwipeGesture,
            sendButtonDidTap: rootView.replyWritingView.replyButton.rx.tap,
            dotsButtonDidTap: rootView.dropdownButton.rx.tap,
            dropdownButtonDidTap: dropdownButtonDidTap,
            commentdotsButtonDidTap: commentDotsButtonDidTap.asObservable(),
            commentDropdownDidTap: commentDropdownButtonDidTap
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        // 전체
        output.feedData
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in
                owner.rootView.bindData(data)
            })
            .disposed(by: disposeBag)
        
        output.commentsData
            .drive(rootView.replyView.replyCollectionView.rx.items(
                cellIdentifier: FeedDetailReplyCollectionViewCell.cellIdentifier,
                cellType: FeedDetailReplyCollectionViewCell.self)) { row, element, cell in
                    cell.bindData(data: element)
                    cell.delegate = self
                }
                .disposed(by: disposeBag)
        
        output.popViewController
            .drive(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        output.replyCollectionViewHeight
            .drive(with: self, onNext: { owner, height in
                owner.rootView.replyView.updateCollectionViewHeight(height: height)
            })
            .disposed(by: disposeBag)
        
        // 관심 버튼
        output.likeCount
            .drive(with: self, onNext: { owner, count in
                owner.rootView.feedContentView.reactView.updateLikeCount(count)
            })
            .disposed(by: disposeBag)
        
        output.likeButtonToggle
            .drive(with: self, onNext: { owner, isLiked in
                owner.rootView.feedContentView.reactView.updateLikeState(isLiked)
            })
            .disposed(by: disposeBag)
        
        // 작품 연결
        output.presentNovelDetailViewController
            .subscribe(with: self, onNext: { owner, novelId in
                owner.pushToDetailViewController(novelId: novelId)
            })
            .disposed(by: disposeBag)
        
        // 댓글 작성
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(with: self, onNext: { owner, keyboardHeight in
                let height = keyboardHeight > 0 ? -keyboardHeight + self.rootView.safeAreaInsets.bottom : 0
                self.rootView.replyWritingView.snp.updateConstraints {
                    $0.bottom.equalTo(self.rootView.safeAreaLayoutGuide.snp.bottom).offset(height)
                }
                
                self.rootView.replyView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(height)
                }
                
                UIView.animate(withDuration: 0.25) {
                    self.rootView.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        
        rootView.scrollView.rx.tapGesture()
            .when(.recognized)
            .subscribe(with: self, onNext: { owner, _ in
                self.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        output.commentCount
            .drive(with: self, onNext: { owner, count in
                owner.rootView.feedContentView.reactView.updateCommentCount(count)
            })
            .disposed(by: disposeBag)
        
        output.showPlaceholder
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, showPlaceholder in
                owner.rootView.replyWritingView.replyWritingPlaceHolderLabel.isHidden = !showPlaceholder
            })
            .disposed(by: disposeBag)
        
        output.endEditing
            .subscribe(with: self, onNext: { owner, endEditing in
                owner.rootView.scrollView.endEditing(endEditing)
            })
            .disposed(by: disposeBag)
        
        output.textViewResignFirstResponder
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.rootView.replyWritingView.replyWritingTextView.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        output.sendButtonEnabled
            .subscribe(with: self, onNext: { owner, enabled in
                owner.rootView.replyWritingView.enableSendButton(enabled)
            })
            .disposed(by: disposeBag)
        
        output.textViewEmpty
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, isEmpty in
                if isEmpty {
                    owner.rootView.replyWritingView.makeTextViewEmpty()
                }
            })
            .disposed(by: disposeBag)
        
        // 피드 드롭다운
        output.showDropdownView
            .drive(with: self, onNext: { owner, isShow in
                owner.rootView.dropdownView.isHidden = !isShow
            })
            .disposed(by: disposeBag)
        
        output.isMyFeed
            .drive(with: self, onNext: { owner, isMyFeed in
                owner.rootView.dropdownView.configureDropdown(isMine: isMyFeed)
            })
            .disposed(by: disposeBag)
        
        // 피드 드롭다운 내 이벤트
        output.showSpoilerAlertView
            .flatMapLatest { _ -> Observable<AlertButtonType> in
                return self.presentToAlertViewController(
                    iconImage: .icAlertWarningCircle,
                    titleText: StringLiterals.FeedDetail.spoilerTitle,
                    contentText: nil,
                    leftTitle: StringLiterals.FeedDetail.cancel,
                    rightTitle: StringLiterals.FeedDetail.report,
                    rightBackgroundColor: UIColor.wssPrimary100.cgColor
                )
            }
            .subscribe(with: self, onNext: { owner, buttonType in
                owner.rootView.dropdownView.isHidden = true
                if buttonType == .right {
                    owner.viewModel.postSpoilerFeed(owner.viewModel.feedId)
                        .subscribe()
                        .disposed(by: owner.disposeBag)
                    owner.dismiss(animated: true) {
                        _ = owner.presentToAlertViewController(
                            iconImage: .icReportCheck,
                            titleText: StringLiterals.FeedDetail.reportResult,
                            contentText: nil,
                            leftTitle: nil,
                            rightTitle: StringLiterals.FeedDetail.confirm,
                            rightBackgroundColor: UIColor.wssPrimary100.cgColor
                        )
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.showImproperAlertView
            .flatMapLatest { _ -> Observable<AlertButtonType> in
                return self.presentToAlertViewController(
                    iconImage: .icAlertWarningCircle,
                    titleText: StringLiterals.FeedDetail.impertinentTitle,
                    contentText: nil,
                    leftTitle: StringLiterals.FeedDetail.cancel,
                    rightTitle: StringLiterals.FeedDetail.report,
                    rightBackgroundColor: UIColor.wssPrimary100.cgColor
                )
            }
            .subscribe(with: self, onNext: { owner, buttonType in
                owner.rootView.dropdownView.isHidden = true
                if buttonType == .right {
                    owner.viewModel.postImpertinenceFeed(owner.viewModel.feedId)
                        .subscribe()
                        .disposed(by: owner.disposeBag)
                    owner.dismiss(animated: true) {
                        _ = owner.presentToAlertViewController(
                            iconImage: .icReportCheck,
                            titleText: StringLiterals.FeedDetail.reportResult,
                            contentText: StringLiterals.FeedDetail.impertinentContent,
                            leftTitle: nil,
                            rightTitle: StringLiterals.FeedDetail.confirm,
                            rightBackgroundColor: UIColor.wssPrimary100.cgColor
                        )
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.pushToFeedEditViewController
            .subscribe(with: self, onNext: { owner, _ in
                owner.rootView.dropdownView.isHidden = true
                owner.pushToFeedEditViewController(feedId: owner.viewModel.feedId)
            })
            .disposed(by: disposeBag)
        
        output.showDeleteAlertView
            .flatMapLatest { _ -> Observable<AlertButtonType> in
                return self.presentToAlertViewController(
                    iconImage: .icAlertWarningCircle,
                    titleText: StringLiterals.FeedDetail.deleteTitle,
                    contentText: StringLiterals.FeedDetail.deleteContent,
                    leftTitle: StringLiterals.FeedDetail.cancel,
                    rightTitle: StringLiterals.FeedDetail.delete,
                    rightBackgroundColor: UIColor.wssSecondary100.cgColor
                )
            }
            .subscribe(with: self, onNext: { owner, buttonType in
                owner.rootView.dropdownView.isHidden = true
                if buttonType == .right {
                    owner.viewModel.deleteFeed(owner.viewModel.feedId)
                        .subscribe()
                        .disposed(by: owner.disposeBag)
                    owner.popToLastViewController()
                }
            })
            .disposed(by: disposeBag)
        
        // 댓글 드롭다운
        output.showCommentDropdownView
            .subscribe(with: self, onNext: { owner, data in
                let (indexPath, isMyComment) = data
                owner.rootView.replyView.showDropdownView(indexPath: indexPath,
                                                          isMyComment: isMyComment)
            })
            .disposed(by: disposeBag)
        
        output.hideCommentDropdownView
            .subscribe(with: self, onNext: { owner, _ in
                owner.rootView.replyView.hideDropdownView()
            })
            .disposed(by: disposeBag)
        
        output.toggleDropdownView
            .subscribe(with: self, onNext: { owner, _ in
                owner.rootView.replyView.toggleDropdownView()
            })
            .disposed(by: disposeBag)
        
        // 댓글 드롭다운 내 이벤트
        output.showCommentSpoilerAlertView
            .flatMapLatest { postSpoilerComment, commentId in
                self.presentToAlertViewController(
                    iconImage: .icAlertWarningCircle,
                    titleText: StringLiterals.FeedDetail.spoilerTitle,
                    contentText: nil,
                    leftTitle: StringLiterals.FeedDetail.cancel,
                    rightTitle: StringLiterals.FeedDetail.report,
                    rightBackgroundColor: UIColor.wssPrimary100.cgColor
                )
                .flatMapLatest { buttonType in
                    if buttonType == .right {
                        return postSpoilerComment(self.viewModel.feedId, commentId)
                    } else {
                        return Observable.empty()
                    }
                }
            }
            .subscribe(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true) {
                    _ = owner.presentToAlertViewController(
                        iconImage: .icReportCheck,
                        titleText: StringLiterals.FeedDetail.reportResult,
                        contentText: nil,
                        leftTitle: nil,
                        rightTitle: StringLiterals.FeedDetail.confirm,
                        rightBackgroundColor: UIColor.wssPrimary100.cgColor
                    )
                }
            }, onError: { owner, error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
        
        
        output.showCommentImproperAlertView
            .flatMapLatest { postImpertinenceComment, commentId in
                self.presentToAlertViewController(
                    iconImage: .icAlertWarningCircle,
                    titleText: StringLiterals.FeedDetail.impertinentTitle,
                    contentText: nil,
                    leftTitle: StringLiterals.FeedDetail.cancel,
                    rightTitle: StringLiterals.FeedDetail.report,
                    rightBackgroundColor: UIColor.wssPrimary100.cgColor
                )
                .flatMapLatest { buttonType in
                    if buttonType == .right {
                        return postImpertinenceComment(self.viewModel.feedId, commentId)
                    } else {
                        return Observable.empty()
                    }
                }
            }
            .subscribe(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true) {
                    _ = owner.presentToAlertViewController(
                        iconImage: .icReportCheck,
                        titleText: StringLiterals.FeedDetail.reportResult,
                        contentText: StringLiterals.FeedDetail.impertinentContent,
                        leftTitle: nil,
                        rightTitle: StringLiterals.FeedDetail.confirm,
                        rightBackgroundColor: UIColor.wssPrimary100.cgColor
                    )
                }
            }, onError: { owner, error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
        
        output.myCommentEditing
            .subscribe(with: self, onNext: { owner, _ in
                owner.rootView.replyWritingView.replyWritingTextView.becomeFirstResponder()
                owner.rootView.replyWritingView.setCommentText(owner.viewModel.initialCommentContent)
            })
            .disposed(by: disposeBag)
        
        output.showCommentDeleteAlertView
            .flatMapLatest { deleteComment, commentId in
                self.presentToAlertViewController(
                    iconImage: .icAlertWarningCircle,
                    titleText: StringLiterals.FeedDetail.deleteMineTitle,
                    contentText: StringLiterals.FeedDetail.deleteContent,
                    leftTitle: StringLiterals.FeedDetail.cancel,
                    rightTitle: StringLiterals.FeedDetail.delete,
                    rightBackgroundColor: UIColor.wssSecondary100.cgColor
                )
                .flatMapLatest { buttonType in
                    if buttonType == .right {
                        return deleteComment(self.viewModel.feedId, commentId)
                    } else {
                        return Observable.empty()
                    }
                }
            }
            .subscribe(with: self, onNext: { owner, _ in
                // 피드 리로딩
            }, onError: { owner, error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
extension FeedDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let text = viewModel.replyContentForItemAt(indexPath: indexPath) else {
            return CGSize(width: 0, height: 0)
        }
        
        let labelWidth: CGFloat = 247
        
        let font = UIFont.Body2
        
        let boundingRect = (text as NSString).boundingRect(
            with: CGSize(width: labelWidth, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.kern: -0.6
            ],
            context: nil
        )
        
        let lineHeight = font.lineHeight
        let numberOfLines = ceil(boundingRect.height / lineHeight)
        let padding: CGFloat = 28
        
        let finalHeight = ceil(lineHeight * numberOfLines) + padding
        
        let cellWidth = UIScreen.main.bounds.width
        
        return CGSize(width: cellWidth, height: finalHeight)
    }
}

extension FeedDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > maximumCommentContentCount {
            textView.deleteBackward()
        }
        
        let size = CGSize(width: rootView.replyWritingView.replyWritingTextView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        let lineHeight = textView.font?.lineHeight ?? 0
        let numberOfLines = Int(estimatedSize.height / lineHeight)
        
        let backgroundHeight: CGFloat
        
        backgroundHeight = numberOfLines == 1 ? 42 : min(estimatedSize.height + 14, 84)
        
        rootView.replyWritingView.replyWritingTextView.snp.updateConstraints {
            $0.height.equalTo(min(estimatedSize.height, 84))
        }
        
        rootView.replyWritingView.textViewBackgroundView.snp.updateConstraints {
            $0.height.equalTo(backgroundHeight)
        }
        
        rootView.replyWritingView.replyWritingTextView.isScrollEnabled = numberOfLines > 3
        
        self.rootView.replyWritingView.layoutIfNeeded()
    }
}

extension FeedDetailViewController: FeedDetailReplyCollectionDelegate {
    func dotsButtonDidTap(commentId: Int, isMyComment: Bool) {
        self.commentDotsButtonDidTap.accept((commentId, isMyComment))
    }
}
