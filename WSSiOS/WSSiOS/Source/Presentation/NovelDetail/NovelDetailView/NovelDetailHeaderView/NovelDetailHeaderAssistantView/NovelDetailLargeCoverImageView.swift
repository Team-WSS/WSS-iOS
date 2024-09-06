//
//  NovelDetailLargeCoverImageView.swift
//  WSSiOS
//
//  Created by 이윤학 on 6/12/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class NovelDetailLargeCoverImageButton: UIButton {
    
    //MARK: - Components
    
    private let novelCoverImageView = UIImageView()
    let dismissButton = UIButton()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .wssBlack60
        }
        
        novelCoverImageView.do {
            $0.image = .imgLoadingThumbnail
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 14
            $0.isUserInteractionEnabled = true
        }
        
        dismissButton.do {
            $0.setImage(.icCacelModal.withTintColor(.wssWhite,
                                                    renderingMode: .alwaysOriginal),
                        for: .normal)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(novelCoverImageView,
                         dismissButton)
    }
    
    private func setLayout() {
        novelCoverImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        dismissButton.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.trailing.equalToSuperview().inset(12)
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailHeaderResult) {
        if let novelImageUrl = URL(string: data.novelImage) {
            KingfisherManager.shared.retrieveImage(with: novelImageUrl, completionHandler: { result in
                switch(result) {
                case .success(let imageResult):
                    // 이미지 자체 비율 그대로 이미지 뷰의 사이즈를 잡는 과정,
                    // 이때 세로가 긴 이미지는 세로 길이 제한에 맞추고, 가로가 긴 이미지는 가로 길이 제한에 맞춘다.
                    let imageSize = imageResult.image.size
                    let screenSize = UIScreen.main.bounds
                    let imageRatio = (imageSize.height/imageSize.width)
                    let heightInset: CGFloat = UIScreen.isSE ? 100 : 200
                    
                    if (screenSize.width-40)*imageRatio > (screenSize.height-heightInset) {
                        self.novelCoverImageView.snp.makeConstraints {
                            $0.height.equalTo(screenSize.height-heightInset)
                            $0.width.equalTo((screenSize.height-heightInset)/imageRatio)
                        }
                    } else {
                        self.novelCoverImageView.snp.makeConstraints {
                            $0.height.equalTo((screenSize.width-40)*imageRatio)
                            $0.width.equalTo(screenSize.width-40)
                        }
                    }
                    self.novelCoverImageView.image = imageResult.image
                case .failure(let error):
                    self.novelCoverImageView.image = .imgLoadingThumbnail
                    print(error)
                }
            })
        }
    }
}
