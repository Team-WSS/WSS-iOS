//
//  UserService.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol UserService {
    func getUserData() -> Single<UserMeResponse>
    func patchUserName(userNickName: String) -> Single<Void>
    func getUserNovelStatus(userId: Int) -> Single<UserNovelStatusResponse>
    func getUserInfo() -> Single<UserInfoResponse>
    func putUserInfo(userData: ChangeUserInfoRequest) -> Single<Void>
    func getUserProfileVisibility() -> Single<UserProfileVisibilityResponse>
    func patchUserProfileVisibility(isProfilePublic: UserProfileVisibilityRequest) -> Single<Void>
    func getMyProfile() -> Single<MyProfileResponse>
    func getOtherProfile(userId: Int) -> Single<OtherProfileResponse>
    func getUserNovelPreferences(userId: Int) -> Single<UserNovelPreferencesResponse>
    func getUserGenrePreferences(userId: Int) -> Single<UserGenrePreferencesListResponse>
    func patchUserProfile(updatedFields: [String: Any]) -> Single<Void>
    func getNicknameisValid(nickname: String) -> Single<OnboardingResponse>
    func getUserFeed(userId: Int, lastFeedId: Int, size: Int) -> Single<MyFeedListResponse>
    func getUserNovelList(userId: Int,
                          readStatus: String,
                          lastUserNovelId: Int,
                          size: Int,
                          sortType: String) -> Single<UserNovelListResponse>
    func getAppMinimumVersion() -> Single<AppMinimumVersion>
    
    // 약관동의 관련
    func getTermSetting() -> Single<TermSettingResponse>
    func patchTermSetting(_ termSettingRequest: TermSettingRequest) -> Single<Void>
}

final class DefaultUserService: NSObject, Networking {
    private let userNickNameQueryItems: [URLQueryItem] = [URLQueryItem(name: "userNickname",
                                                                       value: String(describing: 10))]
    
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
    func getUserData() -> Single<UserMeResponse> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.User.userme,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: UserMeResponse.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func patchUserName(userNickName: String) -> Single<Void> {
        guard let userNickNameData = try? JSONEncoder().encode(UserNickNameRequest(userNickname: userNickName))
                
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
    
    func getUserNovelStatus(userId: Int) -> Single<UserNovelStatusResponse> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.User.getUserNovelStatus(userId: userId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: UserNovelStatusResponse.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func getUserInfo() -> Single<UserInfoResponse> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.User.userInfo,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: UserInfoResponse.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func putUserInfo(userData: ChangeUserInfoRequest) -> Single<Void> {
        guard let userInfoData = try? JSONEncoder().encode(userData)
                
        else {
            return .error(NetworkServiceError.invalidRequestError)
        }
        
        do {
            let request = try makeHTTPRequest(method: .put,
                                              path: URLs.User.userInfo,
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
    
    func getUserProfileVisibility() -> Single<UserProfileVisibilityResponse> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.User.isProfileVisibility,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map {
                    try self.decode(data: $0,
                                    to: UserProfileVisibilityResponse.self)
                }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func getMyProfile() -> Single<MyProfileResponse> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.User.myProfile,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: MyProfileResponse.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func getOtherProfile(userId: Int) -> Single<OtherProfileResponse> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.User.otherProfile(userId: userId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: OtherProfileResponse.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func patchUserProfileVisibility(isProfilePublic: UserProfileVisibilityRequest) -> Single<Void> {
        guard let userProfileVisibility = try? JSONEncoder().encode(isProfilePublic)  else {
            return .error(NetworkServiceError.invalidRequestError)
        }
        do {
            let request = try makeHTTPRequest(method: .patch,
                                              path: URLs.User.isProfileVisibility,
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
    
    func getUserNovelPreferences(userId: Int) -> Single<UserNovelPreferencesResponse> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.User.novelPreferencesstatic(userId: userId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: UserNovelPreferencesResponse.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func getUserGenrePreferences(userId: Int) -> Single<UserGenrePreferencesListResponse> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.User.genrePreferencesstatic(userId: userId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: UserGenrePreferencesListResponse.self) }
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
    
    func getNicknameisValid(nickname: String) -> Single<OnboardingResponse> {
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
                                       to: OnboardingResponse.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func getUserFeed(userId: Int, lastFeedId: Int, size: Int) -> Single<MyFeedListResponse> {
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
                                       to: MyFeedListResponse.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func getUserNovelList(userId: Int,
                          readStatus: String,
                          lastUserNovelId: Int,
                          size: Int,
                          sortType: String) -> Single<UserNovelListResponse> {
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
                                       to: UserNovelListResponse.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func getAppMinimumVersion() -> Single<AppMinimumVersion> {
        let appMinimumVersionQueryItem: [URLQueryItem] = [URLQueryItem(name: "os", value: "ios")]
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.User.getAppMinimumVersion,
                                              queryItems: appMinimumVersionQueryItem,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: AppMinimumVersion.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    // 약관동의 관련
    func getTermSetting() -> Single<TermSettingResponse> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.User.termSetting,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: TermSettingResponse.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func patchTermSetting(_ termSettingRequest: TermSettingRequest) -> Single<Void> {
        guard let termSettingBody = try? JSONEncoder().encode(termSettingRequest) else {
            return Single.error(NetworkServiceError.invalidRequestError)
        }
        
        do {
            let request = try makeHTTPRequest(method: .patch,
                                              path: URLs.User.termSetting,
                                              headers: APIConstants.accessTokenHeader,
                                              body: termSettingBody)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
}
