//
//  LibrarySortBottomSheetViewController.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/22/26.
//

import UIKit

import RxSwift
import RxCocoa

final class LibrarySortBottomSheetViewController: UIViewController {

    //MARK: - Properties

    private let disposeBag = DisposeBag()

    /// 선택된 정렬. 행 탭 시 onNext + onCompleted, 배경 탭(취소) 시 onCompleted만.
    let selectedSort = PublishSubject<LibrarySortType>()

    //MARK: - Components

    private let rootView: LibrarySortBottomSheetView

    //MARK: - Life Cycle

    init(currentSort: LibrarySortType) {
        self.rootView = LibrarySortBottomSheetView(currentSort: currentSort)

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindAction()
    }

    //MARK: - Bind

    private func bindAction() {
        Observable.merge(
            rootView.sortRowButtons.map { button in
                button.rx.tap.map { button.sortType }
            }
        )
        .bind(with: self, onNext: { owner, sort in
            owner.selectedSort.onNext(sort)
            owner.selectedSort.onCompleted()
            owner.dismissModalViewController()
        })
        .disposed(by: disposeBag)

        rootView.backgroundButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.selectedSort.onCompleted()
                owner.dismissModalViewController()
            })
            .disposed(by: disposeBag)
    }
}
