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
        if let existingToastView = self.view.subviews.first(where: { $0 is WSSToastView }) {
            existingToastView.removeFromSuperview()
        }
        
        let toastView = WSSToastView(toastStatus)
        
        self.view.addSubview(toastView)
        
        toastView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.snp.bottom).offset(-212)
        }
        
        UIView.animate(withDuration: 0.3, delay: 3.0, animations: {
            toastView.alpha = 0
        }, completion: { _ in
            toastView.removeFromSuperview()
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
            let tabBar = WSSTabBarController(isLoggedIn: true)
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
        let viewController = ModuleFactory.shared.makeNovelDetailViewController(novelId: novelId)
        viewController.navigationController?.isNavigationBarHidden = false
        viewController.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToLoginViewController() {
        let viewController = ModuleFactory.shared.makeLoginViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToOnboardingViewController() {
        let viewController = ModuleFactory.shared.makeOnboardingViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentToOnboardingSuccessViewController(nickname: String) {
        let viewController = ModuleFactory.shared.makeOnboardingSuccessViewController(nickname: nickname)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    func presentToAlertViewController(iconImage: UIImage?,
                                      titleText: String?,
                                      contentText: String?,
                                      leftTitle: String?,
                                      rightTitle: String?,
                                      rightBackgroundColor: CGColor?) -> Observable<AlertButtonType> {
        let alertViewController = WSSAlertViewController(iconImage: iconImage,
                                                         titleText: titleText,
                                                         contentText: contentText,
                                                         leftTitle: leftTitle,
                                                         rightTitle: rightTitle,
                                                         rightBackgroundColor: rightBackgroundColor)
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        
        self.present(alertViewController, animated: true)
        
        let leftButtonTap = alertViewController.leftButtonTap.map { AlertButtonType.left }
        let rightButtonTap = alertViewController.rightButtonTap.map { AlertButtonType.right }
        
        return Observable.merge(leftButtonTap, rightButtonTap)
    }
    
    func pushToMyPageDeleteIDWarningViewController() {
        let viewController = MyPageDeleteIDWarningViewController(
            userRepository: DefaultUserRepository(
                userService: DefaultUserService(),
                blocksService: DefaultBlocksService()
            )
        )
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToMyPageDeleteIDViewController() {
        let viewController = MyPageDeleteIDViewController(viewModel: MyPageDeleteIDViewModel())
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToMyPageInfoViewController() {
        let viewController = MyPageInfoViewController(
            viewModel: MyPageInfoViewModel(
                userRepository: DefaultUserRepository(
                    userService: DefaultUserService(),
                    blocksService: DefaultBlocksService())))
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentModalViewController(_ viewController: UIViewController) {
        let blackOverlayView = UIView(frame: self.view.bounds).then {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0)
            $0.tag = 999
        }
        
        self.view.addSubview(blackOverlayView)
        
        UIView.animate(withDuration: 0.3) {
            blackOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        }
        
        viewController.modalPresentationStyle = .overFullScreen
        
        self.present(viewController, animated: true)
    }
    
    func dismissModalViewController() {
        guard let blackOverlayView = self.presentingViewController?.view.viewWithTag(999) else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            blackOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0)
        }, completion: { _ in
            blackOverlayView.removeFromSuperview()
        })
        
        self.dismiss(animated: true)
    }
    
    func pushToBlockIDViewController() {
        let viewController = MyPageBlockUserViewController(
            viewModel:MyPageBlockUserViewModel(
                userRepository: DefaultUserRepository(
                    userService: DefaultUserService(),
                    blocksService: DefaultBlocksService()
                )
            )
        )
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToFeedEditViewController(feedId: Int? = nil, relevantCategories: [NewNovelGenre] = [], initialFeedContent: String = "", novelId: Int? = nil, novelTitle: String? = nil, isSpoiler: Bool = false) {
        let viewController = FeedEditViewController(
            viewModel: FeedEditViewModel(
                feedRepository: DefaultFeedRepository(
                    feedService: DefaultFeedService()
                ),
                feedId: feedId,
                relevantCategories: relevantCategories,
                initialFeedContent: initialFeedContent,
                novelId: novelId,
                novelTitle: novelTitle,
                isSpoiler: isSpoiler
            )
        )
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToNovelReviewViewController(readStatus: ReadStatus, novelId: Int, novelTitle: String) {
        let viewController = NovelReviewViewController(
            viewModel: NovelReviewViewModel(
                novelReviewRepository: DefaultNovelReviewRepository(
                    novelReviewService: DefaultNovelReviewService()
                ),
                readStatus: readStatus,
                novelId: novelId,
                novelTitle: novelTitle
            )
        )
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToFeedDetailViewController(feedId: Int) {
        let viewController = FeedDetailViewController(
            viewModel: FeedDetailViewModel(
                feedDetailRepository: DefaultFeedDetailRepository(
                    feedDetailService: DefaultFeedDetailService()
                ),
                feedId: feedId
            )
        )
        viewController.navigationController?.isNavigationBarHidden = false
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToSettingViewController() {
        let viewController = MyPageSettingViewController()
        viewController.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToMyPageViewController(isMyPage: Bool) {
        let viewController = MyPageViewController(
            viewModel: MyPageViewModel(
                userRepository: DefaultUserRepository(
                    userService: DefaultUserService(),
                    blocksService: DefaultBlocksService()
                )
            ),
            isMyPage: isMyPage)
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToMyPageEditViewController() {
        let viewController = MyPageEditProfileViewController(viewModel: MyPageEditProfileViewModel())
        
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentToDetailSearchViewController(selectedKeywordList: [KeywordData]) {
        let detailSearchViewController = DetailSearchViewController(viewModel: DetailSearchViewModel(keywordRepository: DefaultKeywordRepository(keywordService: DefaultKeywordService()), searchRepository: DefaultSearchRepository(searchService: DefaultSearchService()), selectedKeywordList: selectedKeywordList))
        self.presentModalViewController(detailSearchViewController)
    }
}

extension UIViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
