//
//  FeedDetailAddImageViewerController.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/19/25.
//

import UIKit

import RxSwift

final class FeedDetailAddImageViewerController: UIViewController {
    
    //MARK: - Properties
    
    private let startIndex: Int
    private let imageURLs: [URL?]
    
    private let disposeBag = DisposeBag()
    
    private var hasScrolledToInitialIndex = false
    
    //MARK: - UI Components
    
    private let rootView = FeedDetailAddImageViewerView()
    
    //MARK: - Life Cycles
    
    override func loadView() {
        self.view = rootView
    }
    
    init(startIndex: Int, imageURLs: [URL?]) {
        self.startIndex = startIndex
        self.imageURLs = imageURLs
        
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        bindAction()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !hasScrolledToInitialIndex && startIndex < imageURLs.count {
            let indexPath = IndexPath(item: startIndex, section: 0)
            rootView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            hasScrolledToInitialIndex = true
            rootView.updatePageLabel(for: startIndex, imageCount: imageURLs.count)
        }
    }
    
    //MARK: - Bind
    
    private func setupCollectionView() {
        rootView.collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        rootView.collectionView.rx.setDataSource(self)
            .disposed(by: disposeBag)
        rootView.collectionView.register(FeedDetailAddImageViewerCell.self,
                                         forCellWithReuseIdentifier: FeedDetailAddImageViewerCell.cellIdentifier)
    }
    
    private func bindAction() {
        rootView.closeButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension FeedDetailAddImageViewerController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedDetailAddImageViewerCell.cellIdentifier,
                                                            for: indexPath) as? FeedDetailAddImageViewerCell else {
            return UICollectionViewCell()
        }
        cell.bindImage(url: imageURLs[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        rootView.updatePageLabel(for: pageIndex, imageCount: imageURLs.count)
    }
}
