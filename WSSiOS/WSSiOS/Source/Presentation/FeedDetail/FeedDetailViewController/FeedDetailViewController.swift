//
//  FeedDetailViewController.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 6/23/24.
//

import UIKit

import RxSwift
import RxCocoa

final class FeedDetailViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: FeedDetailViewModel
    private let disposeBag = DisposeBag()
    
    private let comments = BehaviorRelay<[Comment]>(value: [])
    
    //MARK: - UI Components
    
    private let rootView = FeedDetailView()
    
    private var backButton = UIButton()
    private var dotsButton = UIButton()
    
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
        
        preparationSetNavigationBar(title: StringLiterals.FeedDetail.title,
                                    left: self.backButton,
                                    right: self.dotsButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        bindViewModel()
        registerCell()
        delegate()
    }
    
    private func setUI() {
        self.view.backgroundColor = .wssWhite
        
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal).withTintColor(.wssBlack), for: .normal)
        }
        
        dotsButton.do {
            $0.setImage(.icThreedots.withRenderingMode(.alwaysOriginal).withTintColor(.wssGray100), for: .normal)
        }
    }
    
    //MARK: - Bind
    
    private func registerCell() {
        rootView.replyView.replyCollectionView.register(FeedDetailReplyCollectionViewCell.self,
                                                        forCellWithReuseIdentifier: FeedDetailReplyCollectionViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.replyView.replyCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = FeedDetailViewModel.Input(
            replyCollectionViewContentSize: rootView.replyView.replyCollectionView.rx.observe(CGSize.self, "contentSize"))
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.feedProfileData
            .drive(with: self, onNext: { owner, data in
                owner.rootView.profileView.bindData(data: data)
            })
            .disposed(by: disposeBag)
        
        output.feedDetailData
            .drive(with: self, onNext: { owner, data in
                owner.rootView.feedContentView.bindData(data: data)
            })
            .disposed(by: disposeBag)
        
        output.commentCountLabel
            .drive(with: self, onNext: { owner, data in
                owner.rootView.replyView.bindData(commentCount: data)
            })
            .disposed(by: disposeBag)
        
        output.commentsData
            .drive(rootView.replyView.replyCollectionView.rx.items(
                cellIdentifier: FeedDetailReplyCollectionViewCell.cellIdentifier,
                cellType: FeedDetailReplyCollectionViewCell.self)) { row, element, cell in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        output.replyCollectionViewHeight
            .drive(with: self, onNext: { owner, height in
                owner.rootView.replyView.updateCollectionViewHeight(height: height)
            })
            .disposed(by: disposeBag)
    }
}

extension FeedDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let text = viewModel.replyContentForItemAt(indexPath: indexPath) else {
            return CGSize(width: 0, height: 0)
        }
        
        guard let numberOfLines = viewModel.replyContentNumberOfLines(indexPath: indexPath) else {
            return CGSize(width: 0, height: 0)
        }
        
        let height = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2,
                                                              NSAttributedString.Key.kern: -0.6]).height
        let finalHeight = height * CGFloat(numberOfLines) + 28
        return CGSize(width: UIScreen.main.bounds.width - 40, height: finalHeight)
    }
}
