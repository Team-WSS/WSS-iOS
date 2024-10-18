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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.rootView.dotsButton)
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
            gestureRecognizer.cancelsTouchesInView = false
        })
            .when(.recognized)
            .asObservable()
        
        let replyCommentCollectionViewSwipeGesture = rootView.scrollView.rx.swipeGesture([.up, .down])
            .when(.recognized)
            .asObservable()
        
        let input = FeedDetailViewModel.Input(
            backButtonTapped: rootView.backButton.rx.tap,
            replyCollectionViewContentSize: rootView.replyView.replyCollectionView.rx.observe(CGSize.self, "contentSize"),
            likeButtonTapped: rootView.feedContentView.reactView.likeButton.rx.tap,
            linkNovelViewTapped: rootView.feedContentView.linkNovelView.rx.tapGesture().when(.recognized).asObservable(),
            viewDidTap: viewDidTap,
            commentContentUpdated: rootView.replyWritingView.replyWritingTextView.rx.text.orEmpty.distinctUntilChanged().asObservable(),
            commentContentViewDidBeginEditing: rootView.replyWritingView.replyWritingTextView.rx.didBeginEditing,
            commentContentViewDidEndEditing: rootView.replyWritingView.replyWritingTextView.rx.didEndEditing,
            replyCommentCollectionViewSwipeGesture: replyCommentCollectionViewSwipeGesture,
            sendButtonTapped: rootView.replyWritingView.replyButton.rx.tap)
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
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
                }
                .disposed(by: disposeBag)
        
        output.likeButtonEnabled
            .drive(with: self, onNext: { owner, isLiked in
                owner.rootView.feedContentView.reactView.updateLikeState(isLiked)
            })
            .disposed(by: disposeBag)
        
        output.likeCount
            .drive(with: self, onNext: { owner, count in
                owner.rootView.feedContentView.reactView.updateLikeCount(count)
            })
            .disposed(by: disposeBag)
        
        output.replyCollectionViewHeight
            .drive(with: self, onNext: { owner, height in
                owner.rootView.replyView.updateCollectionViewHeight(height: height)
            })
            .disposed(by: disposeBag)
        
        output.backButtonEnabled
            .drive(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
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
        
        output.presentNovelDetailViewController
            .subscribe(with: self, onNext: { owner, novelId in
                owner.pushToDetailViewController(novelId: novelId)
            })
            .disposed(by: disposeBag)
        
        output.endEditing
            .subscribe(with: self, onNext: { owner, endEditing in
                owner.rootView.scrollView.endEditing(endEditing)
            })
            .disposed(by: disposeBag)
        
        output.commentContentWithLengthLimit
            .subscribe(with: self, onNext: { owner, limit in
                
            })
            .disposed(by: disposeBag)
        
        output.sendButtonEnabled
            .subscribe(with: self, onNext: { owner, enabled in
                owner.rootView.replyWritingView.enableSendButton(enabled)
            })
            .disposed(by: disposeBag)
        
        output.showPlaceholder
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, showPlaceholder in
                owner.rootView.replyWritingView.replyWritingPlaceHolderLabel.isHidden = !showPlaceholder
            })
            .disposed(by: disposeBag)
        
        output.textViewEmpty
            .bind(with: self, onNext: { owner, isEmpty in
                if isEmpty {
                    owner.rootView.replyWritingView.makeTextViewEmpty()
                }
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
        
            print("boundingRect.height: \(boundingRect.height)")
            print("numberOfLines: \(numberOfLines)")

            let finalHeight = ceil(lineHeight * numberOfLines) + padding
            
            let cellWidth = UIScreen.main.bounds.width - 40

            return CGSize(width: cellWidth, height: finalHeight)
        }
}

extension FeedDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
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

