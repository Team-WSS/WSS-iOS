//
//  RegisterNormalViewController.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/6/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

/// 1-3-1 RegisterNormal View
final class RegisterNormalViewController: ViewController {
    
    // MARK: - Properties
    
    // RxSwift에서 메모리 관리를 위한 DisposeBag
    private let disposeBag = DisposeBag()
    
    // 별점의 현재 값을 저장하고, 변경사항을 관찰하기 위한 BehaviorRelay
    private let starRatingRelay = BehaviorRelay<Float>(value: 0.0)
    
    
    private let rootView = RegisterNormalView()
    
    // MARK: - View Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    // MARK: - Custom Method
    
    private func bind() {
        rootView.infoWithRatingView.starRatingView.do { view in

            view.starImageViews.enumerated().forEach { index, imageView in
                
                // 탭 제스처 인식기 생성 및 설정
                let tapGesture = UITapGestureRecognizer()
                imageView.addGestureRecognizer(tapGesture)
                tapGesture.rx.event.bind(onNext: { recognizer in
                    let location = recognizer.location(in: imageView)
                    let rating = Float(index) + (location.x > imageView.frame.width / 2 ? 1 : 0.5)
                    self.starRatingRelay.accept(rating)
                }).disposed(by: disposeBag)
                
                // 팬 제스처 인식기 생성 및 설정
                let panGesture = UIPanGestureRecognizer()
                view.addGestureRecognizer(panGesture)
                panGesture.rx.event.bind(onNext: { recognizer in
                    let location = recognizer.location(in: view)
                    let rawRating = (Float(location.x / view.frame.width * 5) * 2).rounded(.toNearestOrAwayFromZero) / 2
                    let rating = min(max(rawRating, 0), 5)
                    self.starRatingRelay.accept(rating)
                }).disposed(by: disposeBag)
            }
            
            // 별점이 변경될 때마다 별 이미지 업데이트
            starRatingRelay.asObservable().subscribe(onNext: { rating in
                view.updateStarImages(rating: rating)
            }).disposed(by: disposeBag)
        }
    }
}
