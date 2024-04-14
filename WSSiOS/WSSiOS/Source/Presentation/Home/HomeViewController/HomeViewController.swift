//
//  HomeViewController.swift
//  WSSiOS
//
//  Created by 최서연 on 1/9/24.
//

import UIKit

import RxSwift
import RxCocoa
import Lottie

final class HomeViewController: UIViewController {
    
    //MARK: - Properties
    
    private let userRepository: UserRepository
    private let recommendRepository: RecommendRepository
    private var characterId: Int = 0
    private var userNickname: String = ""
    private var userCharacter = UserCharacter(avatarId: 0, avatarTag: "", avatarComment: "", userNickname: "")
    private var sosopickListRelay = BehaviorRelay<[SosopickNovel]>(value: [])
    private let disposeBag = DisposeBag()
    
    let lotties = [[LottieLiterals.Home.Sosocat.bread, LottieLiterals.Home.Sosocat.tail],
                   [LottieLiterals.Home.Regressor.greeting, LottieLiterals.Home.Regressor.sword],
                   [LottieLiterals.Home.Villainess.fan, LottieLiterals.Home.Villainess.tea]]
    
    //MARK: - UI Components
    
    private let rootView = HomeView()
    
    //MARK: - Life Cycle
    
    init(userRepository: UserRepository, recommendRepository: RecommendRepository) {
        self.userRepository = userRepository
        self.recommendRepository = recommendRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bindDataToUI()
        navigationController?.setNavigationBarHidden(true, animated: false)
        showTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        registerCell()
        addTapGesture()
    }
    
    private func setUI() {
        self.view.do {
            $0.backgroundColor = .White
        }
    }
    
    private func registerCell() {
        
    }
    
    func getDataFromAPI(disposeBag: DisposeBag,
                        completion: @escaping (Int, UserCharacter, SosopickNovels)
                        -> Void) {
        let userObservable = self.userRepository.getUserCharacter()
            .do(onNext: { [weak self] user in
                guard let self = self else { return }
                self.userCharacter = user
                self.characterId = user.avatarId
            })
        
        let sosopickObservable = self.recommendRepository.getSosopickNovels()
            .do(onNext: { [weak self] sosopicks in
                guard self != nil else { return }
            })
        
        Observable.zip(userObservable, sosopickObservable)
            .subscribe(
                onNext: { [weak self] user, sosopicks in
                    guard let self = self else { return }
                    completion(self.characterId, user, sosopicks)
                },
                onError: { error in
                    print(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func bindDataToUI() {
        getDataFromAPI(disposeBag: disposeBag) { [weak self] characterId, user, sosopick in
            self?.updateUI(user: user, sosopickList: sosopick)
        }
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pushSearchVC(_:)))
    }
    
    @objc private func pushSearchVC(_ sender: UITapGestureRecognizer) {
        let searchViewController = SearchViewController(
            searchViewModel: SearchViewModel(
                novelRepository: DefaultNovelRepository(
                    novelService: DefaultNovelService())))
        
        hideTabBar()
        searchViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    private func getLottie(avatarId: Int) -> LottieAnimationView {
        let random = (0...1).randomElement() ?? 0
        return lotties[avatarId-1][random]
    }
    
    private func updateUI(user: UserCharacter, sosopickList: SosopickNovels) {
        
    }
}
