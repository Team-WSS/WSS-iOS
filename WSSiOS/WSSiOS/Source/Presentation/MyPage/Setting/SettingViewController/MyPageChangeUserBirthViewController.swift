//
//  MyPageChangeUserBirthViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 9/23/24.
//

import UIKit

import RxSwift

final class MyPageChangeUserBirthViewController: UIViewController {
    
    
    //MARK: - Properties
    
    private let userBirth: Int
    
    private let birthRange = Observable.just(Array(1900...2024))
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = MyPageChangeUserBirthView()
    
    // MARK: - Life Cycle
    
    init(userBirth: Int) {
        self.userBirth = userBirth
        
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
        
        register()
        bindAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollToSelectedCell(year: userBirth)
        checkCenterCell()
    }
    
    //MARK: - Bind
    
    private func register() {
        rootView.tableView.register(MyPageChangeUserBirthTableViewCell.self,
                                    forCellReuseIdentifier: MyPageChangeUserBirthTableViewCell.cellIdentifier)
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
                //로직 추가
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

extension MyPageChangeUserBirthViewController: UIScrollViewDelegate {
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

extension MyPageChangeUserBirthViewController {
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
}
