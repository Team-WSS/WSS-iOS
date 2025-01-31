//
//  LoginViewController.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/17/24.
//

import UIKit

import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: LoginViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = LoginView()
    
    //MARK: - Life Cycle
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        
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
        
        registerCell()
        delegate()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setCarouselViewInitialState()
    }
    
    //MARK: - UI
    
    private func setNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func registerCell() {
        rootView.carouselView.bannerCollectionView.register(
            LoginBannerCollectionViewCell.self,
            forCellWithReuseIdentifier: LoginBannerCollectionViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.carouselView.bannerCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = createViewModelInput()
        let output = viewModel.transform(from: input,
                                         disposeBag: disposeBag)
        bindViewModelOutput(output)
    }
    
    private func bindViewModelOutput(_ output: LoginViewModel.Output) {
        output.bannerImages
            .drive(rootView.carouselView.bannerCollectionView.rx.items(
                cellIdentifier: LoginBannerCollectionViewCell.cellIdentifier,
                cellType: LoginBannerCollectionViewCell.self)) { _, element, cell in
                    cell.bindData(image: element)
                }
                .disposed(by: disposeBag)
        
        output.autoScrollTrigger
            .drive(with: self, onNext: { owner, _ in
                owner.scrollToNextItem()
            })
            .disposed(by: disposeBag)
        
        output.indicatorIndex
            .distinctUntilChanged()
            .drive(with: self, onNext: { owner, index in
                owner.rootView.carouselIndicatorView.updateUI(selectedIndex: index)
            })
            .disposed(by: disposeBag)
        
        output.navigateToOnboarding
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                // 온보딩 뷰로 이동
                print("Token: \(APIConstants.accessToken)")
                owner.pushToOnboardingViewController()
            })
            .disposed(by: disposeBag)
        
        output.navigateToHome
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                // 홈으로 이동
                print("Token: \(APIConstants.accessToken)")
                owner.loginCompleted()
            })
            .disposed(by: disposeBag)
    }
    
    private func createViewModelInput() -> LoginViewModel.Input {
        // 로그인 버튼들 전체가 같은 debounce로 제어되어야 하므로, 모든 탭 이벤트를 하나의 Observable로 연결해줌.
        let loginButtonDidTap = Observable.merge(
            rootView.platformButtonStackView.kakaoLoginButton.rx.tap.map { LoginButtonType.kakao },
            rootView.platformButtonStackView.appleLoginButton.rx.tap.map { LoginButtonType.apple },
            rootView.skipButton.rx.tap.map { LoginButtonType.skip }
        )
        
        return LoginViewModel.Input(
            bannerCollectionViewContentOffset: rootView.carouselView.bannerCollectionView.rx.contentOffset,
            loginButtonDidTap: loginButtonDidTap
        )
    }
    
    //MARK: - Custom Method
    
    /// banner의 다음 항목으로 이동
    private func scrollToNextItem() {
        let currentOffset = rootView.carouselView.bannerCollectionView.contentOffset
        let width = LoginBannerMetric.width
        let nextOffset = ((currentOffset.x/width) + 1) * width // 그냥 width 만큼만 이동시키면, 가끔 현재 위치가 어긋난 채로 메서드가 실행될 때 계속 어긋난 채로 스크롤 될 수 있어서 나눠주고 다시 곱해준다!
        
        rootView.carouselView.bannerCollectionView.setContentOffset(CGPoint(x: nextOffset, y: 0), animated: true)
    }
    
    /// 무한스크롤 구현을 위해 밀린 contentOffset 수정, 자동 스크롤 시작
    private func setCarouselViewInitialState() {
        rootView.carouselView.bannerCollectionView.setContentOffset(CGPoint(x: LoginBannerMetric.width, y: 0), animated: false)
        viewModel.resumeAutoScroll()
    }
    
    private func loginCompleted() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        sceneDelegate.setRootToWSSTabBarController()
    }
}

extension LoginViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxIndex = 5
        let width = LoginBannerMetric.width
        
        if scrollView.contentOffset.x <= 0 {
            scrollView.contentOffset.x = width * Double(maxIndex - 1)
        } else if scrollView.contentOffset.x >= width * Double(maxIndex) {
            scrollView.contentOffset.x = width
        }
    }
    
    // 사용자가 스크롤을 시작할 때 자동 스크롤을 일시 중지
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        viewModel.pauseAutoScroll()
    }
    
    // 사용자의 스크롤이 끝나면 자동 스크롤을 재개
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        viewModel.resumeAutoScroll()
    }
}
