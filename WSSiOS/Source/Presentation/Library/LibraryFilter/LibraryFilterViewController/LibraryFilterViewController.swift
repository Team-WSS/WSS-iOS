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
    private let initialFilterOption: LibraryFilterOption
    let filterOption = PublishSubject<LibraryFilterOption>()
    private let readStatusOptions = BehaviorRelay<[ReadStatus]>(value: [])
    private let attractivePointOptions = BehaviorRelay<[AttractivePoint]>(value: [])
    private let ratingOption = BehaviorRelay<NovelRatingStatus?>(value: nil)
    
    //MARK: - Components
    
    private let rootView = LibraryFilterView()
    
    //MARK: - Life Cycle
    
    init(libraryFilterOption: LibraryFilterOption) {
        self.initialFilterOption = libraryFilterOption
        readStatusOptions.accept(libraryFilterOption.readStatusOptions)
        attractivePointOptions.accept(libraryFilterOption.attractivePointOptions)
        ratingOption.accept(libraryFilterOption.starRatingOption)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindInput()
        bindOutput()
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
            .withLatestFrom(ratingOption) { tappedButton, currentOption in
                if tappedButton == currentOption {
                    return nil
                } else {
                    return tappedButton
                }
            }
            .bind(to: ratingOption)
            .disposed(by: disposeBag)
        
        rootView.bottomActionView.resetButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.readStatusOptions.accept([])
                owner.attractivePointOptions.accept([])
                owner.ratingOption.accept(nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        readStatusOptions
            .asDriver()
            .drive(with: self, onNext: { owner, selectedOptions in
                owner.rootView.readStatusView.updateButtons(selectedOptions: selectedOptions)
            })
            .disposed(by: disposeBag)
        
        attractivePointOptions
            .asDriver()
            .drive(with: self, onNext: { owner, selectedOptions in
                owner.rootView.attractivePointView.updateButtons(selectedOptions: selectedOptions)
            })
            .disposed(by: disposeBag)
        
        ratingOption
            .asDriver()
            .drive(with: self, onNext: { owner, selectedOption in
                owner.rootView.ratingView.updateButtons(selectedOption: selectedOption)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAction() {
        rootView.dismissButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.filterOption.onNext(owner.initialFilterOption)
                owner.filterOption.onCompleted()
                owner.dismissModalViewController()
            })
            .disposed(by: disposeBag)
        
        let resultFilterOption = Observable.combineLatest(
            readStatusOptions,
            attractivePointOptions,
            ratingOption
        ) { readStatusOptions, attractivePointOptions, ratingOption in
            LibraryFilterOption(interestedOption: self.initialFilterOption.interestedOption,
                                readStatusOptions: readStatusOptions,
                                attractivePointOptions: attractivePointOptions,
                                starRatingOption: ratingOption)
        }
        
        rootView.bottomActionView.searchButton.rx.tap
            .withLatestFrom(resultFilterOption)
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, filterOption in
                owner.filterOption.onNext(filterOption)
                print(filterOption)
                owner.filterOption.onCompleted()
                owner.dismissModalViewController()
            })
            .disposed(by: disposeBag)
    }
}
