//
//  FeedDetailContentView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 6/23/24.
//

import UIKit

import SnapKit
import Then

final class FeedDetailContentView: UIView {
    
    //MARK: - UI Components
    
    private let contentLabel = UILabel()
    private let linkNovelView = FeedNovelView()
    private let genreLabel = UILabel()
    private let reactView = FeedReactView()
    private let dividerView = UIView()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        contentLabel.do {
            $0.applyWSSFont(.body2, with: "여주가 세계를 구함\n이름이 나여주입니다ㅋㅋㅋ읽던 소설이 세계멸망엔딩나서 댓글달았다가 그 세계의 본인에게 빙의하게 되었는데 S급 힐러에 세계관 관련 중요스킬까지 얻고 시작하는 스토리. 121화 최신화 기준 큰 고구마없고 남주가 질서선 댕댕이입니다. \n\n이름이 나여주입니다ㅋㅋㅋ읽던 소설이 세계멸망엔딩나서 댓글달았다가 그 세계의 본인에게 빙의하게 되었는데 S급 힐러에 세계관 관련 중요스킬까지 얻고 시작하는 스토리라구요오오오오옷")
            $0.textColor = .wssBlack
            $0.numberOfLines = 0
            $0.textAlignment = .left
        }
        
        linkNovelView.do {
            $0.backgroundColor = .wssPrimary20
            $0.bindData(title: "여주가 세계를 구한답니다일이삼사오육칠팔구십십십", rating: 4.0, participants: 1116)
        }
        
        genreLabel.do {
            $0.applyWSSFont(.body2, with: "무협, 로맨스, 판타지, BL, 호러")
            $0.textColor = .wssGray200
        }
        
        reactView.do {
            $0.bindData(likeRating: 23, isLiked: true, commentRating: 7)
        }
        
        dividerView.do {
            $0.backgroundColor = .wssGray50
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(contentLabel,
                         linkNovelView,
                         genreLabel,
                         reactView,
                         dividerView)
    }
    
    private func setLayout() {
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        linkNovelView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
        
        genreLabel.snp.makeConstraints {
            $0.top.equalTo(linkNovelView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        reactView.snp.makeConstraints {
            $0.top.equalTo(genreLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(reactView.snp.bottom).offset(22)
            $0.height.equalTo(7)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
