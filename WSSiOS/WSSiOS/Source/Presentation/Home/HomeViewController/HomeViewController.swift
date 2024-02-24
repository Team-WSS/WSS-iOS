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
        bindDataToSosoPickCollectionView()
    }
    
    private func setUI() {
        self.view.do {
            $0.backgroundColor = .White
        }
    }
    
    private func registerCell() {
        rootView.sosopickView.sosoPickCollectionView.register(HomeSosoPickCollectionViewCell.self,
                                                              forCellWithReuseIdentifier: HomeSosoPickCollectionViewCell.identifier)
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
    
    private func bindDataToSosoPickCollectionView() {
        sosopickListRelay.bind(to: rootView.sosopickView.sosoPickCollectionView.rx.items(
            cellIdentifier: HomeSosoPickCollectionViewCell.identifier,
            cellType: HomeSosoPickCollectionViewCell.self)) { (row, element, cell) in
                cell.bindData(data: element)
            }
            .disposed(by: disposeBag)
        rootView.sosopickView.sosoPickCollectionView
            .rx
            .itemSelected
            .subscribe(onNext:{ indexPath in
                let novelID = self.sosopickListRelay.value[indexPath.row].novelId
                self.pushToRegisterNormalViewController(novelId: novelID)
                self.hideTabBar()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindDataToUI() {
        getDataFromAPI(disposeBag: disposeBag) { [weak self] characterId, user, sosopick in
            self?.updateUI(user: user, sosopickList: sosopick)
        }
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pushSearchVC(_:)))
        rootView.headerView.headerSearchView.addGestureRecognizer(tapGesture)
        rootView.headerView.headerSearchView.isUserInteractionEnabled = true
    }
    
    @objc private func pushSearchVC(_ sender: UITapGestureRecognizer) {
        let searchVC = SearchViewController(novelRepository: DefaultNovelRepository(novelService: DefaultNovelService()))
        hideTabBar()
        searchVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    private func getLottie(avatarId: Int) -> LottieAnimationView {
        let random = (0...1).randomElement() ?? 0
        return lotties[avatarId-1][random]
    }
    
    private func updateUI(user: UserCharacter, sosopickList: SosopickNovels) {
        Observable.just(userCharacter)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, user in
                owner.rootView.characterView.tagView.setTagLabelStyle(text: user.avatarTag)
                owner.rootView.characterView.setCommentLabelStyle(text: user.avatarComment)
                
                //MARK: - characterId값에 따른 캐릭터 로띠 이미지 분기처리 필요
                owner.characterId = user.avatarId
                owner.userNickname = user.userNickname
                
                owner.rootView.characterView.setLottie(view: self.getLottie(avatarId: owner.characterId))
                owner.sosopickListRelay.accept(sosopickList.sosoPickNovels)
            })
            .disposed(by: disposeBag)
    }
}
