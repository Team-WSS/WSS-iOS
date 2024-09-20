//
//  LoginViewModel.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/17/24.
//

import UIKit

import RxSwift
import RxCocoa
import Then

final class LoginViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let bannerImages = BehaviorRelay<[UIImage]>(
        value: [UIImage(resource: .imgLoginBanner4),
                UIImage(resource: .imgLoginBanner1),
                UIImage(resource: .imgLoginBanner2),
                UIImage(resource: .imgLoginBanner3),
                UIImage(resource: .imgLoginBanner4),
                UIImage(resource: .imgLoginBanner1)])
    
    private let indicatorIndex = BehaviorRelay<Int>(value: 0)
    private let autoScrollTrigger = PublishRelay<Void>()
    private var autoScrollDisposable: Disposable?
    
    //MARK: - Life Cycle
    
    
    //MARK: - Transform
    
    struct Input {
        let bannerCollectionViewContentOffset: ControlProperty<CGPoint>
        //let manualScrollTrigger: Observable<Void>
    }
    
    struct Output {
        let bannerImages: Driver<[UIImage]>
        let indicatorIndex: Driver<Int>
        let autoScrollTrigger: Driver<Void>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.bannerCollectionViewContentOffset
            .bind(with: self, onNext: { owner, value in
                let scrollOffset = value.x
                
                var index = Int((scrollOffset + LoginBannerMetric.width/2.0)/LoginBannerMetric.width) - 1
                
                if index == 4 {
                    index = 0
                } else if index == -1 {
                    index = 3
                }
                
                owner.indicatorIndex.accept(index)
            })
            .disposed(by: disposeBag)
        
        let autoScrollTrigger = self.autoScrollTrigger
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            bannerImages: bannerImages.asDriver(),
            indicatorIndex: indicatorIndex.asDriver(),
            autoScrollTrigger: autoScrollTrigger
        )
    }
    
    //MARK: - Custom Method
    
    func pauseAutoScroll() {
        autoScrollDisposable?.dispose()
    }
    
    func resumeAutoScroll() {
        autoScrollDisposable?.dispose()
        autoScrollDisposable = Observable<Int>.interval(.milliseconds(2000), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.autoScrollTrigger.accept(())
            })
    }
}

//0.0 - 0.5 -> 3
//0.5 - 1.5 -> 0
//1.5 - 2.5 -> 1
//2.5 - 3.5 -> 2
//3.5 - 4.5 -> 3
//4.5 - 5.0 -> 0
