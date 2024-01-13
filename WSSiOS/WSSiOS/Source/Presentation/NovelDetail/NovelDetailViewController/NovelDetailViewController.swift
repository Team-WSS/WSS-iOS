//
//  NovelDetailViewController.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/11/24.
//

import UIKit

import RxSwift
import RxCocoa

final class NovelDetailViewController: UIViewController {
    
    private let memos = Observable<[[String: String]]>.just([
        ["memoDate": "2023-12-23 오전 10:12", "memoContent": "답을 모르겠어서 잠이나 자야겠다. 그러나 졸리지는 않다. 왜냐하면 UI를 아직 다 끝내지 못했기 때문이다. 별 하나의 추억과, 별 하나의 사랑과, 별하나의 어머니, 어머니, 어머님 당신은 북간도에 계십니다. 어머니, 어머니, 어머님 당신은 북간도에 계십니다. 어머니, 어머니, 어머님 당신은 북간도에 계"],
        ["memoDate": "2023-12-23 오전 10:12", "memoContent": "뿡"],
        ["memoDate": "2023-12-23 오전 10:12", "memoContent": "깨달았다. 사람은 사람을 절대 이해할 수 없다. 공감할수는 있어도. 그렇기에 나는 절대로 사람을 이해하려 노력하지 않을"]
    ])
    
    private let rating = Observable<Float>.just(3.5)
    
    private let readStatus = Observable<String>.just("WISH")
    
    private let keywords = Observable<[String]>.just([
        "#가상시대물",
        "#판타지물",
        "#오해",
        "#상처녀",
        "#존댓말남",
        "#소유욕/독점욕/질투",
        "#운명적사랑",
        "#소유욕"
    ])
    
    private let platforms = Observable<[String]>.just([
        "네이버시리즈",
        "카카오페이지"
    ])
    
    private let disposeBag = DisposeBag()
    private let memoTableViewHeight = BehaviorSubject<CGFloat>(value: 0)
    private let keywordCollectionViewHeight = BehaviorSubject<CGFloat>(value: 0)
    private let platformCollectionViewHeight = BehaviorSubject<CGFloat>(value: 0)
    
    // MARK: - UI Components
    
    private let rootView = NovelDetailView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
        delegate()
        bind()
    }
    
    // MARK: - register

    private func register() {
        rootView.novelDetailMemoView.memoTableView.register(NovelDetailMemoTableViewCell.self, forCellReuseIdentifier: "NovelDetailMemoTableViewCell")
        rootView.novelDetailInfoView.novelDetailInfoKeywordView.keywordCollectionView.register(NovelDetailInfoKeywordCollectionViewCell.self, forCellWithReuseIdentifier: "NovelDetailInfoKeywordCollectionViewCell")
        rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformCollectionView.register(NovelDetailInfoPlatformCollectionViewCell.self, forCellWithReuseIdentifier: "NovelDetailInfoPlatformCollectionViewCell")
    }
    
    // MARK: - delegate
    
    private func delegate() {
        rootView.novelDetailInfoView.novelDetailInfoKeywordView.keywordCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    // MARK: - bind
    
    private func bind() {
        rootView.novelDetailTabView.memoButton.rx.tap.bind {
            self.memoButtonDidTap()
        }.disposed(by: disposeBag)
        
        rootView.novelDetailTabView.infoButton.rx.tap.bind {
            self.infoButtonDidTap()
        }.disposed(by: disposeBag)
        
        memos.bind(to: rootView.novelDetailMemoView.memoTableView.rx.items(
            cellIdentifier: "NovelDetailMemoTableViewCell",
            cellType: NovelDetailMemoTableViewCell.self)) { row, element, cell in
                cell.selectionStyle = .none
                cell.bindData(date: element["memoDate"]!, content: element["memoContent"]!)
            }
            .disposed(by: disposeBag)
        
        memos
            .map { $0.count == 0 }
            .subscribe(onNext: { isEmpty in
                if isEmpty {
                    self.rootView.novelDetailMemoView.novelDetailCreateMemoView.createMemoLabel.text = "아직 작성된 메모가 없어요"
                } else {
                    self.rootView.novelDetailMemoView.novelDetailCreateMemoView.createMemoLabel.text = "새로운 메모를 작성해보세요"
                }
            })
            .disposed(by: disposeBag)

        
        rootView.novelDetailMemoView.memoTableView.rx.observe(CGSize.self, "contentSize")
            .map { $0?.height ?? 0 }
            .bind(to: memoTableViewHeight)
            .disposed(by: disposeBag)

        memoTableViewHeight
            .subscribe(onNext: { height in
                self.rootView.novelDetailMemoView.updateTableViewHeight(height: height)
            })
            .disposed(by: disposeBag)
        
        rating
            .subscribe(onNext: { rating in
                self.rootView.novelDetailInfoView.novelDetailInfoRatingView.bindData(rating: rating)
            })
            .disposed(by: disposeBag)
        
        readStatus
            .subscribe(onNext: { readStatus in
                self.rootView.novelDetailInfoView.novelDetailInfoReadStatusView.bindData(status: readStatus)
            })
            .disposed(by: disposeBag)
        
        keywords.bind(to: rootView.novelDetailInfoView.novelDetailInfoKeywordView.keywordCollectionView.rx.items(
            cellIdentifier: "NovelDetailInfoKeywordCollectionViewCell",
            cellType: NovelDetailInfoKeywordCollectionViewCell.self)) { item, element, cell in
                cell.bindData(keyword: element)
            }
            .disposed(by: disposeBag)
        
        rootView.novelDetailInfoView.novelDetailInfoKeywordView.keywordCollectionView.rx.observe(CGSize.self, "contentSize")
            .map { $0?.height ?? 0 }
            .bind(to: keywordCollectionViewHeight)
            .disposed(by: disposeBag)
        
        keywordCollectionViewHeight
            .subscribe(onNext: { height in
                self.rootView.novelDetailInfoView.novelDetailInfoKeywordView.updateCollectionViewHeight(height: height)
            })
            .disposed(by: disposeBag)
        
        platforms.bind(to: rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformCollectionView.rx.items(
            cellIdentifier: "NovelDetailInfoPlatformCollectionViewCell",
            cellType: NovelDetailInfoPlatformCollectionViewCell.self)) { item, element, cell in
                cell.bindData(platform: element)
            }
            .disposed(by: disposeBag)
        
        rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformCollectionView.rx.observe(CGSize.self, "contentSize")
            .map { $0?.height ?? 0 }
            .bind(to: platformCollectionViewHeight)
            .disposed(by: disposeBag)
        
        platformCollectionViewHeight
            .subscribe(onNext: { height in
                self.rootView.novelDetailInfoView.novelDetailInfoPlatformView.updateCollectionViewHeight(height: height)
            })
            .disposed(by: disposeBag)
    }
    
    private func memoButtonDidTap() {
        rootView.novelDetailInfoView.removeFromSuperview()
        rootView.contentView.addArrangedSubview(rootView.novelDetailMemoView)
        rootView.novelDetailTabView.memoButton.isSelected = true
        rootView.novelDetailTabView.infoButton.isSelected = false
        rootView.novelDetailTabView.highlightMemoButton()
    }
    
    private func infoButtonDidTap() {
        rootView.novelDetailMemoView.removeFromSuperview()
        rootView.contentView.addArrangedSubview(rootView.novelDetailInfoView)
        rootView.novelDetailTabView.memoButton.isSelected = false
        rootView.novelDetailTabView.infoButton.isSelected = true
        rootView.novelDetailTabView.highlightInfoButton()
    }
}

extension NovelDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var text: String?
        
        switch collectionView {
        case rootView.novelDetailInfoView.novelDetailInfoKeywordView.keywordCollectionView:
            keywords.subscribe(onNext: { items in
                guard indexPath.item < items.count else { return }
                text = items[indexPath.item]
            })
            .disposed(by: disposeBag)
            
            guard let unwrappedText = text else {
                return CGSize(width: 0, height: 0)
            }
            
            let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 27
            return CGSize(width: width, height: 37)
        case rootView.novelDetailInfoView.novelDetailInfoPlatformView.platformCollectionView:
            platforms.subscribe(onNext: { items in
                guard indexPath.item < items.count else { return }
                text = items[indexPath.item]
            })
            .disposed(by: disposeBag)
            
            guard let unwrappedText = text else {
                return CGSize(width: 0, height: 0)
            }
            
            let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 48
            return CGSize(width: width, height: 37)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}
