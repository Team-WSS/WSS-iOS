//
//  SearchViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 2/29/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture


final class SearchViewModel: ViewModelType {
    
    //MARK: - Properties

    private let disposeBag = DisposeBag()

    private let isLogined = APIConstants.isLogined
    
    //MARK: - Inputs
    
    struct Input {
        let searhBarDidTap: Observable<UITapGestureRecognizer>
        let induceButtonDidTap: Observable<UITapGestureRecognizer>
        let pushToDetailSearchResultNotification: Observable<Notification>
    }
    
    //MARK: - Outputs
    
    struct Output {
        let pushToNormalSearchViewController = PublishRelay<Void>()
        let pushToDetailSearchViewController = PublishRelay<Void>()
        let pushToDetailSearchResultView = PublishRelay<Notification>()
        let presentToInduceLoginView = PublishRelay<Void>()
    }
    
}

//MARK: - Methods

extension SearchViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.searhBarDidTap
            .subscribe(onNext: { _ in
                AmplitudeManager.shared.track(AmplitudeEvent.Search.generalSearch)
                if self.isLogined {
                    output.pushToNormalSearchViewController.accept(())
                } else {
                    output.presentToInduceLoginView.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        input.induceButtonDidTap
            .subscribe(onNext: { _ in
                AmplitudeManager.shared.track(AmplitudeEvent.Search.seek)
                if self.isLogined {
                    output.pushToDetailSearchViewController.accept(())
                } else {
                    output.presentToInduceLoginView.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        input.pushToDetailSearchResultNotification
            .subscribe(with: self, onNext: { owner, notification in
                output.pushToDetailSearchResultView.accept(notification)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
