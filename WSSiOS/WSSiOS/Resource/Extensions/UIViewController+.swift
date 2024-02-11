//
//  UIViewController+.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/17/24.
//

import UIKit

import SnapKit
import Then

extension UIViewController {
    func showToast(_ toastStatus: ToastStatus) {
        let toastView = WSSToastView(toastStatus)
        
        self.view.addSubview(toastView)
        
        toastView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.snp.bottom).offset(-212)
        }
        
        UIView.animate(withDuration: 0, animations: {
            toastView.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 3.0) {
                toastView.alpha = 0
            }
        })
    }
    
    func showTabBar() {
        if let tabBarController = self.tabBarController as? WSSTabBarController {
            tabBarController.tabBar.isHidden = false
            tabBarController.shadowView.isHidden = false
        }
    }
    
    func hideTabBar() {
        if let tabBarController = self.tabBarController as? WSSTabBarController {
            tabBarController.tabBar.isHidden = true
            tabBarController.shadowView.isHidden = true
        }
    }
    
    func swipeBackGesture() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    // 이미 만들어 놓은 네비게이션 함수랑 네이밍 겹쳐서 우선 이렇게 해놓음
    // 추후 이름 고치기
    func preparationSetNavigationBar(title: String, left: UIButton?, right: UIButton?) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = title
        
        if let navigationBar = self.navigationController?.navigationBar {
            let titleTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.Title2
            ]
            navigationBar.titleTextAttributes = titleTextAttributes
        }
        
        self.navigationItem.leftBarButtonItem = left != nil ? UIBarButtonItem(customView: left!) : nil
        self.navigationItem.rightBarButtonItem = right != nil ? UIBarButtonItem(customView: right!) : nil
    }
    
    func pushToRegisterSuccessViewController(userNovelId: Int) {
        self.navigationController?.pushViewController(RegisterSuccessViewController(userNovelId: userNovelId),
                                                       animated: true)
    }
    
    func moveToNovelDetailViewController(userNovelId: Int) {
        if self.navigationController?.tabBarController?.selectedIndex == 0 {
            let tabBar = WSSTabBarController()
            tabBar.selectedIndex = 1
            let navigationController = UINavigationController(rootViewController: tabBar)
            navigationController.setNavigationBarHidden(true, animated: true)
            self.view.window?.rootViewController = navigationController
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                NotificationCenter.default.post(name: NSNotification.Name("ShowNovelInfo"), object: userNovelId)
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func pushToMemoReadViewController(memoId: Int) {
        self.navigationController?.pushViewController(
            MemoReadViewController(
                repository: DefaultMemoRepository(
                    memoService: DefaultMemoService()),
                memoId: memoId
            ), animated: true)
    }
    
    func pushToRegisterNormalViewController(novelId: Int) {
        self.navigationController?.pushViewController(
            RegisterNormalViewController(
                novelRepository: DefaultNovelRepository(
                    novelService: DefaultNovelService()),
                userNovelRepository: DefaultUserNovelRepository(
                    userNovelService: DefaultUserNovelService()),
                novelId: novelId),
            animated: true)
    }
    
    func pushToMemoEditViewController(userNovelId: Int, novelTitle: String, novelAuthor: String, novelImage: String) {
        self.navigationController?.pushViewController(MemoEditViewController(
            repository: DefaultMemoRepository(
                memoService: DefaultMemoService()
            ),
            userNovelId: userNovelId,
            novelTitle: novelTitle,
            novelAuthor: novelAuthor,
            novelImage: novelImage
        ), animated: true)
    }
    
    func presentDeletePopupViewController(userNovelId: Int) {
        let viewController = DeletePopupViewController(
            userNovelRepository: DefaultUserNovelRepository(
                userNovelService: DefaultUserNovelService()
            ),
            popupStatus: .novelDelete,
            userNovelId: userNovelId
        )
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }
    
    func popToLastViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension UIViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
