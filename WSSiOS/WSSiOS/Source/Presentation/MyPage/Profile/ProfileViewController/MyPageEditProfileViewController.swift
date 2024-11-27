//
//  MyPageProfileEditViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 7/26/24.
//

import UIKit

import RxSwift
import RxGesture

final class MyPageEditProfileViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: MyPageEditProfileViewModel
    
    //MARK: - Components
    
    private let rootView = MyPageEditProfileView()
    
    // MARK: - Life Cycle
    
    init(viewModel: MyPageEditProfileViewModel) {
        
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
        
        delegate()
        register()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigation()
        hideTabBar()
        swipeBackGesture()
    }
    
    //MARK: - Bind
    
    private func register() {
        rootView.genreCollectionView.register(
            MyPageEditProfileGenreCollectionViewCell.self,
            forCellWithReuseIdentifier: MyPageEditProfileGenreCollectionViewCell.cellIdentifier)
    }
    
    private func delegate() {
        rootView.genreCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = MyPageEditProfileViewModel.Input(
            backButtonDidTap: rootView.backButton.rx.tap,
            completeButtonDidTap: rootView.completeButton.rx.tap,
            profileViewDidTap: rootView.myPageProfileView.rx.tapGesture().when(.recognized).asObservable(),
            avatarImageNotification: NotificationCenter.default.rx.notification(Notification.Name("ChangRepresentativeAvatar")).asObservable(),
            updateNicknameText: rootView.nicknameTextField.rx.text.orEmpty.distinctUntilChanged(),
            textFieldBeginEditing: rootView.nicknameTextField.rx.controlEvent(.editingDidBegin),
            clearButtonDidTap: rootView.nicknameClearButton.rx.tap,
            checkButtonDidTap: rootView.nicknameDuplicatedButton.rx.tap,
            viewDidTap: view.rx.tapGesture(configuration: { gestureRecognizer, delegate in
                gestureRecognizer.cancelsTouchesInView = false
            }),
            updateIntroText: rootView.introTextView.rx.text.orEmpty.asObservable(),
            textViewBeginEditing: rootView.introTextView.rx.didBeginEditing,
            genreCellTap: rootView.genreCollectionView.rx.itemSelected
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.bindGenreCell
            .bind(to: rootView.genreCollectionView.rx.items(
                cellIdentifier: MyPageEditProfileGenreCollectionViewCell.cellIdentifier,
                cellType: MyPageEditProfileGenreCollectionViewCell.self)) { row, element, cell in
                    cell.bindData(genre: element.0)
                    cell.updateCell(isSelected: element.1)
                }
                .disposed(by: disposeBag)
        
        output.popViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        output.pushToAvatarViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, nickname in
                owner.presentModalViewController(
                    MyPageEditAvatarViewController(
                        viewModel: MyPageEditAvatarViewModel(
                            avatarRepository: DefaultAvatarRepository(
                                avatarService: DefaultAvatarService()),
                            userNickname: nickname)))
            })
            .disposed(by: disposeBag)
        
        output.updateProfileImage
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, image in
                owner.rootView.updateProfileImage(image: image)
            })
            .disposed(by: disposeBag)
        
        output.nicknameText
            .bind(with: self, onNext: { owner, text in
                owner.rootView.updateNicknameText(text: text)
            })
            .disposed(by: disposeBag)
        
        output.checkButtonIsAbled
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, isEnabled in
                owner.rootView.updateNicknameDuplicatedButton(isEnabled: isEnabled)
            })
            .disposed(by: disposeBag)

        Observable.combineLatest(
            output.editingTextField.startWith(false),
            output.checkShwonWarningMessage.startWith(.notStarted)
        )
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, tuple in
                let (isEditing, availability) = tuple
                
                owner.rootView.updateNicknameTextField(isEditing: isEditing, availablity: availability)
                owner.rootView.updateNickNameWarningLabel(isEditing: isEditing, availablity: availability)
                owner.rootView.updateNicknameClearButton(isEditing: isEditing, availablity: availability)
            })
            .disposed(by: disposeBag)
        
        output.introText
            .bind(with: self, onNext: { owner, text in
                owner.rootView.updateIntro(text: text)
            })
            .disposed(by: disposeBag)
        
        output.editingTextView
            .bind(with: self, onNext: { owner, editing in
                owner.rootView.updateIntroTextViewColor(update: editing)
                
                if !editing {
                    owner.rootView.introTextView.endEditing(true)
                }
            })
            .disposed(by: disposeBag)
        
        output.endEditing
            .bind(with: self, onNext: { owner, endEditing in
                owner.view.endEditing(endEditing)
            })
            .disposed(by: disposeBag)
        
        output.updateCell
            .bind(with: self, onNext: { owner, cellData in
                let (indexPath, update) = cellData
                if let cell = owner.rootView.genreCollectionView.cellForItem(at: indexPath) as? MyPageEditProfileGenreCollectionViewCell {
                    cell.updateCell(isSelected: update)
                }
            })
            .disposed(by: disposeBag)
        
        output.completeButtonIsAbled
            .bind(with: self, onNext: { owner, isAbled in
                owner.rootView.isAbledCompleteButton(isAbled: isAbled)
            })
            .disposed(by: disposeBag)
        
        output.bindProfileData
            .bind(with: self, onNext: { owner, data in
                owner.rootView.bindData(data: data)
            })
            .disposed(by: disposeBag)
    }
}

extension MyPageEditProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var text: String?
        
        text = self.viewModel.genreList[indexPath.item]
        
        guard let unwrappedText = text else {
            return CGSize(width: 0, height: 0)
        }
        
        let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 26
        return CGSize(width: width, height: 35)
    }
}

//MARK: - UI

extension MyPageEditProfileViewController {
    private func setNavigation() {
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.editProfile,
                                    left: self.rootView.backButton,
                                    right: self.rootView.completeButton)
    }
}
