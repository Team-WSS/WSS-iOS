//
//  MyPageChangeNicknameViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/12/24.
//

import UIKit

import RxSwift
import RxCocoa

final class MyPageChangeNicknameViewController: UIViewController {
    
    //MARK: - Set Properties
    
    private var userNickName : String
    private var newNickName = ""
    private let disposeBag = DisposeBag()
    private let userRepository : UserRepository
    
    init(userNickName: String, userRepository: UserRepository) {
        self.userNickName = userNickName
        self.userRepository = userRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Components
    
    var rootView = MyPageChangeNicknameView()
    private var backButton = UIButton()
    private var completeButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNavigationBar()
        textFieldEvent()
    }
    
    //MARK: - Custom Method
    
    private func setUI() {
        backButton.do {
            $0.setImage(ImageLiterals.icon.navigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.rx.tap
                .subscribe(with: self, onNext: { owner, _ in 
                    owner.navigationController?.popViewController(animated: true)
                })
                .disposed(by: disposeBag)
        }
        
        completeButton.do {
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(.Primary100, for: .normal)
            $0.titleLabel?.font = .Title2
            $0.rx.tap
                .subscribe(with: self, onNext: { owner, _ in 
                    owner.patchUserNickName()
                })
        }
    }
    
    private func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.title = "닉네임 변경"
        
        if let navigationBar = self.navigationController?.navigationBar {
            let titleTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.Title2
            ]
            navigationBar.titleTextAttributes = titleTextAttributes
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.completeButton)
    }
    
    private func textFieldEvent() {
        rootView.changeNicknameTextField.rx.controlEvent([.editingDidBegin, .editingChanged])
            .asObservable()
            .subscribe(with: self, onNext: { owner, _ in
                owner.rootView.textFieldUnderBarView.backgroundColor = .Primary100
            })
            .disposed(by: disposeBag)
        
        rootView.changeNicknameTextField.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(with: self, onNext: { owner, _ in
                owner.rootView.textFieldUnderBarView.backgroundColor = .Gray200
            })
            .disposed(by: disposeBag)
        
        rootView.changeNicknameTextField.rx.text
            .subscribe(with: self, onNext: { owner, text in
                if let text = text {
                    var textCount = text.count
                    if textCount > 10 {
                        owner.rootView.countNicknameLabel.text = "10/10"
                    }
                    else {
                        owner.rootView.countNicknameLabel.text = "\(textCount)/10"
                        owner.newNickName = text
                    }
                    
                    print("🎈",text)
                    print("🧩",owner.userNickName)
                    if text == owner.userNickName || text == "" {
                        owner.completeButton.setTitleColor(.Gray200, for: .normal)
                    }
                    else {
                        owner.completeButton.setTitleColor(.Primary100, for: .normal)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        rootView.changeNicknameTextField.rx.text.orEmpty
            .subscribe(with: self, onNext: { owner, text in
                self.limitNum(text)
            })
            .disposed(by: disposeBag)
        
        rootView.setClearButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.rootView.changeNicknameTextField.text = ""
                owner.rootView.countNicknameLabel.text = "0/10"
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Bind Data
    
    private func patchUserNickName() {
        userRepository.patchUserName(userNickName: newNickName)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in 
                owner.navigationController?.popViewController(animated: true)
            }, onError: { owner, error in
                print(error)
            })
    }
    
    func bindData(_ data: String) {
        rootView.changeNicknameTextField.text = data
    }
}

extension MyPageChangeNicknameViewController {
    private func limitNum(_ text: String) {
        if text.count > 10 {
            self.rootView.changeNicknameTextField.text = String(text.prefix(10))
        }
    }
}
