//
//  UIViewController+.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/17/24.
//

import UIKit

import RxSwift
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
        }
    }
    
    func hideTabBar() {
        if let tabBarController = self.tabBarController as? WSSTabBarController {
            tabBarController.tabBar.isHidden = true
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
    
    func pushToRegisterNormalViewController(novelId: Int) {
        let registerNormalViewController = ModuleFactory.shared.makeRegisterNormalViewController(novelId: novelId)
        self.navigationController?.pushViewController(registerNormalViewController,
                                                      animated: true)
    }
    
    func pushToRegisterSuccessViewController(userNovelId: Int) {
        let successViewController = ModuleFactory.shared.makeRegisterSuccessViewController(userNovelId: userNovelId)
        self.navigationController?.pushViewController(successViewController,
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
                viewModel: MemoReadViewModel(
                    memoRepository: DefaultMemoRepository(
                        memoService: DefaultMemoService()
                    )
                ),
                memoId: memoId
            ), animated: true)
    }
    
    func pushToMemoEditViewController(userNovelId: Int? = nil, memoId: Int? = nil, novelTitle: String, novelAuthor: String, novelImage: String, memoContent: String? = nil) {
        self.navigationController?.pushViewController(MemoEditViewController(
            viewModel: MemoEditViewModel(
                memoRepository: DefaultMemoRepository(
                    memoService: DefaultMemoService()
                ),
                userNovelId: userNovelId,
                memoId: memoId,
                memoContent: memoContent
            ),
            novelTitle: novelTitle,
            novelAuthor: novelAuthor,
            novelImage: novelImage
        ), animated: true)
    }
    
    func pushToChangeNicknameViewController(userNickname: String) {
        let viewController = MyPageChangeNicknameViewController(
            userNickName: userNickname,
            viewModel: MyPageChangeNickNameViewModel(
                userRepository: DefaultUserRepository(
                    userService: DefaultUserService()),
                userNickname: userNickname))
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentDeleteUserNovelViewController(userNovelId: Int) {
        let viewController = DeletePopupViewController(
            viewModel: DeletePopupViewModel(
                userNovelRepository: DefaultUserNovelRepository(
                    userNovelService: DefaultUserNovelService()
                ),
                userNovelId: userNovelId),
            popupStatus: .novelDelete
        )
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }
    
    func presentMemoDeleteViewController(memoId: Int) {
        let viewController = DeletePopupViewController(
            viewModel: DeletePopupViewModel(
                memoRepository: DefaultMemoRepository(
                    memoService: DefaultMemoService()
                ),
                memoId: memoId),
            popupStatus: .memoDelete
        )
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }
    
    func presentMemoEditCancelViewController() {
        let viewController = DeletePopupViewController(
            viewModel: DeletePopupViewModel(
                memoRepository: DefaultMemoRepository(
                    memoService: DefaultMemoService()
                )
            ),
            popupStatus: .memoEditCancel
        )
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }
    
    func popToLastViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func popToRootViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func pushToDetailViewController(novelId: Int) {
        let viewController = ModuleFactory.shared.makeDetailViewController(novelId: novelId)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentToAlertViewController(iconImage: UIImage?,
                                      titleText: String?,
                                      contentText: String?,
                                      cancelTitle: String?,
                                      actionTitle: String?,
                                      actionBackgroundColor: CGColor?) -> Observable<Void> {
        let alertViewController = WSSAlertViewController(iconImage: iconImage,
                                                         titleText: titleText,
                                                         contentText: contentText,
                                                         cancelTitle: cancelTitle,
                                                         actionTitle: actionTitle,
                                                         actionBackgroundColor: actionBackgroundColor)
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        
        self.present(alertViewController, animated: true)
        
        return alertViewController.actionButtonTap
    }
    
    func pushToMyPageDeleteIDWarningViewController() {
        let viewController = MyPageDeleteIDWarningViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToMyPageDeleteIDViewController() {
        let viewController = MyPageDeleteIDViewController(viewModel: MyPageDeleteIDViewModel())
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension UIViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
