//
//  FeedFilterViewController.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/26/25.
//

import UIKit

import RxSwift
import RxRelay
import SnapKit
import Then

final class FeedFilterViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    
    //MARK: - Components
    
    let rootView = FeedFilterView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
        delegate()
        
        bindAction()
        bindOutput()
        
        AmplitudeManager.shared.track(AmplitudeEvent.Feed.feedAll)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: - Bind
    
    private func register() {
        //정보뷰
        rootView.genreView.genreCollectionView
            .register(FeedFilterGenreCollectionViewCell.self,
                      forCellWithReuseIdentifier: FeedFilterGenreCollectionViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.genreView
            .genreCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        Observable<[NewNovelGenre]>.just(NewNovelGenre.feedFilterGenres)
            .bind(to: rootView.genreView.genreCollectionView.rx.items(
                cellIdentifier: FeedFilterGenreCollectionViewCell.cellIdentifier,
                cellType: FeedFilterGenreCollectionViewCell .self)) { item, element, cell in
                    let indexPath = IndexPath(item: item, section: 0)
                    self.rootView.genreView.genreCollectionView.selectItem(at: indexPath,
                                                                           animated: false,
                                                                           scrollPosition: [])
                    cell.bindData(genre: element.withKorean)
                }
                .disposed(by: disposeBag)
    }
    
    private func bindAction() {
        rootView.dismissButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
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
