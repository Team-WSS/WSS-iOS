//
//  UserService.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol UserService {
    func getUserData() -> Single<UserMeResult>
    func patchUserName(userNickName: String) -> Single<Void>
    func getUserNovelStatus(userId: Int) -> Single<UserNovelStatus>
    func getUserInfo() -> Single<UserInfo>
    func putUserInfo(gender: String, birth: Int) -> Single<Void>
    func getUserProfileVisibility() -> Single<UserProfileVisibility>
    func patchUserProfileVisibility(isProfilePublic: Bool) -> Single<Void>
    func getMyProfile() -> Single<MyProfileResult>
    func getOtherProfile(userId: Int) -> Single<OtherProfileResult> 
    func getUserNovelPreferences(userId: Int) -> Single<UserNovelPreferences>
    func getUserGenrePreferences(userId: Int) -> Single<UserGenrePreferences>
    func patchUserProfile(updatedFields: [String: Any]) -> Single<Void>
    func getNicknameisValid(nickname: String) -> Single<OnboardingResult>
    func getUserFeed(userId: Int, lastFeedId: Int, size: Int) -> Single<MyFeedResult>
    func getUserNovelList(userId: Int,
                              readStatus: String,
                              lastUserNovelId: Int,
                              size: Int,
                              sortType: String) -> Single<UserNovelList>
}

final class DefaultUserService: NSObject, Networking {
    private let userNickNameQueryItems: [URLQueryItem] = [URLQueryItem(name: "userNickname",
                                                                       value: String(describing: 10))]
    
    private func makeUserInfoQueryItems(gender: String,
                                        birth: Int) -> [URLQueryItem] {
        return [
            URLQueryItem(name: "gender", value: gender),
            URLQueryItem(name: "birth", value: String(describing: birth))
        ]
    }
    
    private func makeUserProfileVisibilityQueryItems(isProfilePublic: Bool) -> [URLQueryItem] {
        return [ URLQueryItem(name: "isProfilePublic",
                              value: String(isProfilePublic))]
    }
    
    func makeNovelListQuery(readStatus: String, lastUserNovelId: Int, size: Int, sortType: String) -> [URLQueryItem] {
            return [
                URLQueryItem(name: "readStatus", value: readStatus),
                URLQueryItem(name: "lastUserNovelId", value: String(describing: lastUserNovelId)),
                URLQueryItem(name: "size", value: String(describing: size)),
                URLQueryItem(name: "sortType", value: sortType)
            ]
        }
}

extension DefaultUserService: UserService {
    func getUserData() -> Single<UserMeResult> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.User.userme,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: UserMeResult.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func patchUserName(userNickName: String) -> Single<Void> {
        guard let userNickNameData = try? JSONEncoder().encode(UserNickNameResult(userNickname: userNickName))
                
        else {
            return .error(NetworkServiceError.invalidRequestError)
        }
        
        do {
            let request = try makeHTTPRequest(method: .patch,
                                              path: URLs.User.patchUserNickname,
                                              queryItems: userNickNameQueryItems,
                                              headers: APIConstants.accessTokenHeader,
                                              body: userNickNameData)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func getUserNovelStatus(userId: Int) -> Single<UserNovelStatus> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.User.getUserNovelStatus(userId: userId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: UserNovelStatus.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func getUserInfo() -> Single<UserInfo> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.User.userInfo,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: UserInfo.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func putUserInfo(gender: String, birth: Int) -> Single<Void> {
        guard let userInfoData = try? JSONEncoder().encode(ChangeUserInfo(gender: gender,
                                                                          birth: birth))
                
        else {
            return .error(NetworkServiceError.invalidRequestError)
        }
        
        do {
            let request = try makeHTTPRequest(method: .put,
                                              path: URLs.User.userInfo,
                                              queryItems: makeUserInfoQueryItems(gender: gender, birth: birth),
                                              headers: APIConstants.accessTokenHeader,
                                              body: userInfoData)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func getUserProfileVisibility() -> Single<UserProfileVisibility> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.MyPage.ProfileVisibility.isProfileVisibility,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map {
                    try self.decode(data: $0,
                                    to: UserProfileVisibility.self)
                }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func getMyProfile() -> Single<MyProfileResult> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.User.myProfile,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: MyProfileResult.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func getOtherProfile(userId: Int) -> Single<OtherProfileResult> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.User.otherProfile(userId: userId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: OtherProfileResult.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
  
    func patchUserProfileVisibility(isProfilePublic: Bool) -> Single<Void> {
        guard let userProfileVisibility = try? JSONEncoder().encode(UserProfileVisibility(isProfilePublic: isProfilePublic))  else {
            return .error(NetworkServiceError.invalidRequestError)
        }
        do {
            let request = try makeHTTPRequest(method: .patch,
                                              path: URLs.MyPage.ProfileVisibility.isProfileVisibility,
                                              queryItems: makeUserProfileVisibilityQueryItems(isProfilePublic: isProfilePublic),
                                              headers: APIConstants.accessTokenHeader,
                                              body: userProfileVisibility)
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func getUserNovelPreferences(userId: Int) -> Single<UserNovelPreferences> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.User.novelPreferencesstatic(userId: userId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: UserNovelPreferences.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func getUserGenrePreferences(userId: Int) -> Single<UserGenrePreferences> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.User.genrePreferencesstatic(userId: userId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: UserGenrePreferences.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func patchUserProfile(updatedFields: [String: Any]) -> Single<Void> {
        do {
            let userProfileData = try JSONSerialization.data(withJSONObject: updatedFields, options: [])
            let request = try makeHTTPRequest(method: .patch,
                                              path: URLs.User.editUserProfile,
                                              headers: APIConstants.accessTokenHeader,
                                              body: userProfileData)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func getNicknameisValid(nickname: String) -> Single<OnboardingResult> {
        let nicknameisValidQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "nickname", value: String(describing: nickname))
        ]
        
        do {
            let request = try self.makeHTTPRequest(
                method: .get,
                path: URLs.Onboarding.nicknameCheck,
                queryItems: nicknameisValidQueryItems,
                headers: APIConstants.accessTokenHeader,
                body: nil
            )
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: OnboardingResult.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func getUserFeed(userId: Int, lastFeedId: Int, size: Int) -> Single<MyFeedResult> {
        let feedQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "lastFeedId", value: String(describing: lastFeedId)),
            URLQueryItem(name: "size", value: String(describing: size))
        ]
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.User.getProfileFeed(userId: userId),
                                              queryItems: feedQueryItems,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: MyFeedResult.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func getUserNovelList(userId: Int, readStatus: String, lastUserNovelId: Int, size: Int, sortType: String) -> RxSwift.Single<UserNovelList> {
            do {
                let request = try makeHTTPRequest(method: .get,
                                                  path: URLs.User.getUserNovel(userId: userId),
                                                  queryItems: makeNovelListQuery(readStatus: readStatus,
                                                                                 lastUserNovelId: lastUserNovelId,
                                                                                 size: size,
                                                                                 sortType: sortType),
                                                  headers: APIConstants.accessTokenHeader,
                                                  body: nil)

                NetworkLogger.log(request: request)

                return tokenCheckURLSession.rx.data(request: request)
                    .map { try self.decode(data: $0,
                                           to: UserNovelList.self) }
                    .asSingle()
            } catch {
                return Single.error(error)
            }
        }
}
