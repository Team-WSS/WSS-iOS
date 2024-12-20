//
//  BirthPickerViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 10/28/24.
//

import UIKit

import RxSwift

final class BirthPickerViewController: UIViewController {
    
    //MARK: - Properties
    
    private var birth: Int
    
    private let birthRange = Observable.just(Array(1900...2025))
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = MyPageChangeUserBirthView()
    
    // MARK: - Life Cycle
    
    init(birth: Int) {
        self.birth = birth
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate()
        register()
        bindAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollToSelectedCell(year: birth)
        checkCenterCell()
    }
    
    //MARK: - Bind
    
    private func register() {
        rootView.tableView.register(MyPageChangeUserBirthTableViewCell.self,
                                    forCellReuseIdentifier: MyPageChangeUserBirthTableViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindAction() {
        rootView.cancelButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.dismissModalViewController()
            })
            .disposed(by: disposeBag)
        
        rootView.completeButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                if let centerYear = owner.getCenterCellYear() {
                    owner.birth = centerYear
                    
                    NotificationCenter.default.post(name: NSNotification.Name("Birth"), object: nil, userInfo: ["Birth": owner.birth])
                }
                
                owner.dismissModalViewController()
            })
            .disposed(by: disposeBag)
        
        self.birthRange
            .bind(to: rootView.tableView.rx.items(
                cellIdentifier: MyPageChangeUserBirthTableViewCell.cellIdentifier,
                cellType: MyPageChangeUserBirthTableViewCell.self)) { row, year, cell in
                    cell.bindYear(year: year)
                }
                .disposed(by: disposeBag)
        
        rootView.tableView.rx.modelSelected(Int.self)
            .subscribe(with: self, onNext: { owner, year in
                owner.scrollToSelectedCell(year: year)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - UIScrollViewDelegate

extension BirthPickerViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        checkCenterCell()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkCenterCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let tableView = scrollView as? UITableView else { return }
        
        let currentY = targetContentOffset.pointee.y
        
        let cellHeight = tableView.rowHeight
        let closestCellIndex = round(currentY / cellHeight)
        let clesestCellY = closestCellIndex * cellHeight
        
        targetContentOffset.pointee.y = clesestCellY
    }
}

//MARK: - Custom Method

extension BirthPickerViewController {
    private func scrollToSelectedCell(year: Int) {
        let cellRow = year - 1900
        let cellIndexPath = IndexPath(row: cellRow, section: 0)
        self.rootView.tableView.scrollToRow(at: cellIndexPath, at: .middle, animated: true)
    }
    
    private func checkCenterCell() {
        let centerPoint = CGPoint(x: rootView.tableView.bounds.midX, y: rootView.tableView.bounds.midY)
        if let centerIndexPath = rootView.tableView.indexPathForRow(at: centerPoint) {
            for indexPath in rootView.tableView.indexPathsForVisibleRows ?? [] {
                if let cell = rootView.tableView.cellForRow(at: indexPath) as? MyPageChangeUserBirthTableViewCell {
                    let isCenter = indexPath == centerIndexPath
                    cell.highlightedCell(isHighlighted: isCenter)
                }
            }
        }
    }
    
    private func getCenterCellYear() -> Int? {
        let centerPoint = CGPoint(x: rootView.tableView.bounds.midX, y: rootView.tableView.bounds.midY)
        if let centerIndexPath = rootView.tableView.indexPathForRow(at: centerPoint) {
            return 1900 + centerIndexPath.row
        }
        return nil
    }
}
