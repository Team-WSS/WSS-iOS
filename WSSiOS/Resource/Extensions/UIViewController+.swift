//
//  UIViewController+.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/17/24.
//

import UIKit

import RxSwift
import RxKeyboard
import SnapKit
import Then

extension UIViewController {
    func showToast(_ toastStatus: ToastStatus, bottomHeight: CGFloat = 124) {
        if let existingToastView = self.view.subviews.first(where: { $0 is WSSToastView }) {
            existingToastView.removeFromSuperview()
        }
        
        let toastView = WSSToastView(toastStatus)
        
        self.view.addSubview(toastView)
        
        toastView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom).offset(-bottomHeight)
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
    
    func setWSSNavigationBar(title: String?, left: UIButton?, right: UIButton?, isVisibleBeforeScroll: Bool = true) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = title
        self.navigationItem.leftBarButtonItem = left != nil ? UIBarButtonItem(customView: left!) : nil
        self.navigationItem.rightBarButtonItem = right != nil ? UIBarButtonItem(customView: right!) : nil
        setNavigationBarVisibleBeforeScroll(isVisible: isVisibleBeforeScroll)
    }
    
    func setNavigationBarVisibleBeforeScroll(isVisible: Bool) {
        let clearAppearance = UINavigationBarAppearance().then {
            $0.configureWithTransparentBackground()
            $0.titleTextAttributes = [
                .font: UIFont.Title2,
                .kern: -0.6,
                .foregroundColor: UIColor.clear
            ]
            $0.shadowColor = .clear
        }
        
        let whiteAppearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .white
            $0.titleTextAttributes = [
                .font: UIFont.Title2,
                .kern: -0.6,
                .foregroundColor: UIColor.black
            ]
            $0.shadowColor = .clear
        }
        
        navigationItem.standardAppearance = whiteAppearance
        navigationItem.scrollEdgeAppearance = isVisible ? whiteAppearance : clearAppearance
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
    
    func popToLastViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func popToRootViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func pushToNovelDetailViewController(novelId: Int) {
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
                                      rightBackgroundColor: CGColor?,
                                      isDismissable: Bool = true) -> Observable<AlertButtonType> {
        let alertViewController = WSSAlertViewController(iconImage: iconImage,
                                                         titleText: titleText,
                                                         contentText: contentText,
                                                         leftTitle: leftTitle,
                                                         rightTitle: rightTitle,
                                                         rightBackgroundColor: rightBackgroundColor,
                                                         isDismissable: isDismissable)
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        
        self.present(alertViewController, animated: true)
        
        let leftButtonTap = alertViewController.leftButtonTap.map { AlertButtonType.left }
        let rightButtonTap = alertViewController.rightButtonTap.map { AlertButtonType.right }
        
        return Observable.merge(leftButtonTap, rightButtonTap)
    }
    
    func pushToMyPageDeleteIDWarningViewController() {
        let viewController = MyPageDeleteIDWarningViewController(
            userRepository: DefaultUserInfoRepository(
                userService: DefaultUserService()
            )
        )
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToMyPageDeleteIDViewController() {
        let viewController = MyPageDeleteIDViewController(
            viewModel: MyPageDeleteIDViewModel(
                authRepository: DefaultAuthRepository(
                    authService: DefaultAuthService()
                )
            )
        )
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToMyPageInfoViewController() {
        let viewController = MyPageInfoViewController(
            viewModel: MyPageInfoViewModel(
                userRepository: DefaultUserInfoRepository(
                    userService: DefaultUserService()),
                authRepository: DefaultAuthRepository(
                    authService: DefaultAuthService())))
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentModalViewController(_ viewController: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let blackOverlayView = UIView(frame: window.bounds).then {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0)
            $0.tag = 999
        }
        
        window.addSubview(blackOverlayView)
        
        blackOverlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.3) {
            blackOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        }
        
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true)
    }
    
    func dismissModalViewController() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        guard let blackOverlayView = window.viewWithTag(999) else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            blackOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0)
        }, completion: { _ in
            blackOverlayView.removeFromSuperview()
        })
        
        self.dismiss(animated: true)
    }
    
    func pushToBlockUserViewController() {
        let viewController = MyPageBlockUserViewController(
            userRepository: DefaultUserBlockRepository(
                blocksService: DefaultBlocksService()
            )
        )
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToFeedEditViewController(feedId: Int? = nil,
                                      novelId: Int? = nil,
                                      novelTitle: String? = nil) {
        let viewController = FeedEditViewController(
            viewModel: FeedEditViewModel(
                feedRepository: DefaultFeedRepository(
                    feedService: DefaultFeedService()
                ),
                feedDetailRepository: DefaultFeedDetailRepository(
                    feedDetailService: DefaultFeedDetailService()
                ),
                feedId: feedId,
                novelId: novelId,
                novelTitle: novelTitle
            )
        )
        
        viewController.navigationController?.isNavigationBarHidden = false
        viewController.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToNovelReviewViewController(isInterest: Bool, readStatus: ReadStatus, novelId: Int, novelTitle: String) {
        let viewController = NovelReviewViewController(
            viewModel: NovelReviewViewModel(
                novelReviewRepository: DefaultNovelReviewRepository(
                    novelReviewService: DefaultNovelReviewService()
                ),
                isInterest: isInterest,
                readStatus: readStatus,
                novelId: novelId,
                novelTitle: novelTitle
            )
        )
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToFeedDetailViewController(feedId: Int) {
        let viewController = ModuleFactory.shared.makeFeedDetailViewController(feedId: feedId)
        viewController.navigationController?.isNavigationBarHidden = false
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToSettingViewController() {
        let viewController = MyPageSettingViewController()
        viewController.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToMyPageViewController() {
        let viewController = ModuleFactory.shared.makeMyPageViewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToUserPageViewController(userId: Int) {
        let viewController = ModuleFactory.shared.makeUserPageViewController(profileId: userId)
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToMyPageEditViewController(entryType: MyPageEditEntryType, profile: MyProfileEntity?) {
        let viewController = ModuleFactory.shared.makeMyPageEditViewController(entryType: entryType, profile: profile)
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToDetailSearchViewController() {
        let detailSearchViewController = DetailSearchViewController(
            viewModel: DetailSearchViewModel(
                keywordRepository: DefaultKeywordRepository(
                    keywordService: DefaultKeywordService()
                )
            )
        )
        detailSearchViewController.navigationController?.isNavigationBarHidden = true
        detailSearchViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailSearchViewController,
                                                      animated: true)
    }
    
    func presentInduceLoginViewController() {
        let viewController = InduceLoginViewController()
        viewController.modalPresentationStyle = .overFullScreen
        
        self.present(viewController, animated: false)
    }
    
    func dismissViewController() {
        self.dismiss(animated: false)
    }
    
    func pushToNormalSearchViewController(searchText: String? = nil) {
        let normalSearchViewController = NormalSearchViewController(
            viewModel: NormalSearchViewModel(
                searchRepository: DefaultSearchRepository(searchService: DefaultSearchService()),
                initialSearchText: searchText
            )
        )
        normalSearchViewController.navigationController?.isNavigationBarHidden = false
        normalSearchViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(normalSearchViewController, animated: true)
    }
    
    func pushToMyPageProfileVisibilityViewController() {
        let viewController = MyPageProfileVisibilityViewController(
            userInfoRepository: DefaultUserInfoRepository(
                userService: DefaultUserService()
            )
        )
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToMyPagePushNotificationViewController() {
        let viewController = MyPagePushNotificationViewController(
            notificationRepository: DefaultNotificationRepository(
                notificationService: DefaultNotificationService()))
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func pushToChangeUserInfoViewController() {
        let viewController = MyPageChangeUserInfoViewController(
            userRepository: DefaultUserInfoRepository(
                userService: DefaultUserService()
            )
        )
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToLibraryViewController(userId: Int, pageIndex: Int = 0) {
        let viewController = UserLibraryViewController(userId: userId)
        
        viewController.setPageIndex(target: pageIndex)
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentFeedFilterViewController(_ selectedFilterOption: FeedFilterOption) -> Observable<FeedFilterOption> {
        let viewController = FeedFilterViewController(feedFilterOption: selectedFilterOption)
        self.presentModalViewController(viewController)
        
        return viewController.filterOption.asObservable()
    }
    
    func presentLibraryFilterViewController(_ selectedFilterOption: LibraryFilterOption) -> Observable<LibraryFilterOption> {
        let viewController = LibraryFilterViewController(libraryFilterOption: selectedFilterOption)
        self.presentModalViewController(viewController)
        
        return viewController.filterOption.asObservable()
    }
    
    func pushToUserPageFeedDetailViewController(userId: Int, userData: UserProfileEntity) {
        let viewController = UserPageFeedDetailViewController(
            viewModel: UserPageFeedDetailViewModel(
                userRepository: DefaultUserInfoRepository(
                    userService: DefaultUserService()
                ),
                profileId: userId,
                profileData: userData))
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentToFeedDetailUnknownFeedErrorViewController() {
        let feedDetailUnknownFeedErrorViewController = FeedDetailUnknownFeedErrorViewController()
        feedDetailUnknownFeedErrorViewController.modalPresentationStyle = .overFullScreen
        feedDetailUnknownFeedErrorViewController.modalTransitionStyle = .crossDissolve
        
        self.present(feedDetailUnknownFeedErrorViewController, animated: true)
    }
    
    func presentToFeedDetailAddImageViewerViewController(startIndex: Int, imageURLs: [URL?]) {
        let viewController = FeedDetailAddImageViewerController(startIndex: startIndex, imageURLs: imageURLs)
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true)
    }
    
    func topViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topViewController()
        }
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topViewController() ?? navigation
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topViewController() ?? tab
        }
        return self
    }
    
    func pushToNotificationViewController() {
        let viewController = HomeNotificationViewController(
            viewModel: HomeNotificationViewModel(
                notificationRepository: DefaultNotificationRepository(
                    notificationService: DefaultNotificationService()
                )
            )
        )
        viewController.navigationController?.isNavigationBarHidden = false
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToNotificationDetailViewController(notificationId: Int) {
        let viewController = HomeNotificationDetailViewController(
            viewModel: HomeNotificationDetailViewModel(
                notificationRepository: DefaultNotificationRepository(
                    notificationService: DefaultNotificationService()),
                notificationId: notificationId))
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension UIViewController: @retroactive UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view, touchedView is UITextField || touchedView is UITextView { return false }
        return true
    }
}
