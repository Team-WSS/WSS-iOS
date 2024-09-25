//
//  UserDTO.swift
//  WSSiOS
//
//  Created by 신지원 on 1/15/24.
//

import Foundation

struct MyProfileResult {
    let nickname, intro, avatarImage: String
    let genrePreferences: [String]
}

extension MyProfileResult {
    static let dummyData = 
    MyProfileResult(nickname: "밝보",
                    intro: "꺄울 로판에 절여진 밝보입니다~꺄울 로판에 절여진 밝보입니다~꺄울 로판에",
                    avatarImage: "https://mblogthumb-phinf.pstatic.net/MjAyMjAzMjlfMSAg/MDAxNjQ4NDgwNzgwMzkw.yDLPqC9ouJxYoJSgicANH0CPNvFdcixexP7hZaPlCl4g.n7yZDyGC06_gRTwEnAKIhj5bM04laVpNuKRz29dP83wg.JPEG.38qudehd/IMG_8635.JPG?type=w800",
                    genrePreferences: ["romance", "fantasy", "wuxia"])
}

struct UserResult: Codable {
    let representativeAvatarGenreBadge,
        representativeAvatarTag,
        representativeAvatarLineContent,
        representativeAvatarImg,
        userNickname: String
    let representativeAvatarId, 
        userNovelCount,
        memoCount: Int
    let userAvatars: [UserAvatar]
}

struct UserAvatar: Codable {
    let avatarId: Int
    let avatarImg: String
    let hasAvatar: Bool
}

struct UserNickNameResult: Codable {
    let userNickname: String
}
