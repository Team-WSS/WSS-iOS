//
//  LibraryFilterViewController.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/26/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class LibraryFilterViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let readStatusOptions = BehaviorRelay<[ReadStatus]>(value: [])
    private let attractivePointOptions = BehaviorRelay<[AttractivePoint]>(value: [])
    private let ratingOption = BehaviorRelay<NovelRatingStatus?>(value: nil)
    
    //MARK: - Components
    
    private let rootView = LibraryFilterView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindInput()
        
        bindAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: - Bind
    
    private func bindInput() {
        Observable.from(rootView.readStatusView.readStatusOptionButtons)
            .flatMap { button in
                button.rx.tap.map { button.readStatus }
            }
            .withLatestFrom(readStatusOptions) { ($0, $1) }
            .map { (tapped, currentOptions) in
                var updated = currentOptions
                
                if let index = currentOptions.firstIndex(of: tapped) {
                    updated.remove(at: index)
                } else {
                    updated.append(tapped)
                }
                return updated
            }
            .bind(to: readStatusOptions)
            .disposed(by: disposeBag)
        
        Observable.from(rootView.attractivePointView.attractivePointOptionButtons)
            .flatMap { button in
                button.rx.tap.map { button.attractivePoint }
            }
            .withLatestFrom(attractivePointOptions) { ($0, $1) }
            .map { (tapped, currentOptions) in
                var updated = currentOptions
                
                if let index = currentOptions.firstIndex(of: tapped) {
                    updated.remove(at: index)
                } else {
                    updated.append(tapped)
                }
                return updated
            }
            .bind(to: attractivePointOptions)
            .disposed(by: disposeBag)
        
        Observable.from(rootView.ratingView.novelRatingStatusButtons)
            .flatMap { button in
                button.rx.tap.map { button.status }
            }
            .bind(to: ratingOption)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        readStatusOptions.asDriver()
            .drive(with: self, onNext: { owner, readStatusOptions in
                rootView
            })
    }
    
    private func bindAction() {
        rootView.dismissButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.dismissModalViewController()
            })
            .disposed(by: disposeBag)
        
    }
}
