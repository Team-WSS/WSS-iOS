//
//  StringLiterals+MyPage.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/1/25.
//

import Foundation

extension StringLiterals {
    enum MyPage {
        enum Modal {
            static let keepOriginally = "원래대로 유지하기"
            static let changeCharacter = "대표 캐릭터 설정하기"
        }
        
        enum Profile {
            static let registerNovel = "등록 작품"
            static let record = "기록"
            static let inventoryTitle = "서재"
            static let preferenceEmpty = "취향 분석"
            static let preferenceEmptyLabel = "작품 취향을 파악할 수 없어요"
            static let genrePreferenceTitle = "장르 취향"
            static let novelPreferenceTitle = "작품 취향"
            static let novelPreferenceLabel = "(이)가 매력적인 작품을 선호해요"
            static let privateLabel = "님의 프로필은\n비공개 상태예요"
            static let unknownAlertButtonTitle = "확인"
            static let myProfileLibrary = "내 통계"
            static let otherProfileLibrary = "통계"
            static let myProfileFeed = "내 활동"
            static let otherProfileFeed = "활동"
            static let activityButton = "활동기록 더보기"
            static let emptyFeed = "작성한 글이 없어요"
        }
        
        enum Setting: String, CaseIterable {
            case accountInfo = "계정정보"
            case profileStatus = "프로필 공개 설정"
            case pushNotification = "알림 설정"
            case webSoso = "웹소소 공식 계정"
            case qNA = "문의하기 & 의견 보내기"
            case review = "개인정보 처리 방침"
            case termsOfService = "서비스 이용약관"
        }
        
        enum SettingURL {
            static let QNAInHompageURL = "https://websoso.notion.site/144600bd746881d4b012fbaf586c264d?pvs=105"
            static let instaURL = "https://www.instagram.com/websoso_official/"
            static let termsURL = "https://websoso.notion.site/143600bd746880668556fb005fcef491?pvs=4"
            static let infoURL = "https://websoso.notion.site/143600bd74688050be18f4da31d9403e?pvs=4"
        }
        
        enum SettingInfo: String, CaseIterable {
            case changeProfile = "성별/나이 변경"
            case email = "이메일"
            case blockList = "차단유저 목록"
            case logout = "로그아웃"
            case secession = "회원탈퇴"
        }
        
        enum EditProfile {
            static let complete = "완료"
            static let nickname = "닉네임"
            static let nicknameCheck = "중복확인"
            static let intro = "소개"
            static let introPlaceholder = "소개글을 적어보세요!"
            static let genre = "선호장르"
            static let genreDescription = "선택한 장르에 맞춰 작품을 추천해 드려요"
            
            static let defaultAvatarName = "소소냥이"
            static let defaultAvatarDescription = "만나서 반가워"
        }
        
        enum EditProfileWarningMessage: String {
            case noGap = "공백은 포함될 수 없어요"
            case exist = "이미 사용 중인 닉네임이에요"
            case guid = "한글. 영문, 숫자 2~10자까지 입력가능해요"
            case noUse = "사용할 수 없는 단어가 포함되어 있어요"
        }
        
        enum BlockUser {
            static let buttonTitle = "차단 해제"
            static let emptyLabel = "차단한 유저가 없어요"
            static let toastText = "차단하기"
        }
        
        enum DeleteIDWarning {
            static let title = "정말 탈퇴하시겠어요?"
            static let description = "남겼던 평가와 기록들이 모두 사라져요.."
            static let buttonTitle = "탈퇴하기"
            
            static let interest = "관심"
            static let watching = "보는 중"
            static let watched = "봤어요"
            static let quit = "하차"
        }
        
        enum DeleteID {
            static let reasonTitle = "탈퇴사유를 알려주세요."
            static let reasonTitleColor = "탈퇴사유"
            static let reasonPlaceHolder = "위 항목 외의 탈퇴 사유를 자유롭게 작성해 주세요."
            static let checkTitle = "탈퇴하기 전에 확인해주세요"
            static let agreeTitle = "위 주의사항을 모두 확인했고, 탈퇴에 동의합니다."
        }
        
        enum DeleteIDReason: String, CaseIterable {
            case first = "자주 사용하지 않아서"
            case second = "이용이 불편하고 장애가 많아서"
            case third = "삭제하고 싶은 내용이 있어서"
            case fourth = " 원하는 작품이 없어서"
            case etc = "직접 입력"
            
            static func reasonForIndex(_ index: Int) -> String {
                if(index <= 3) {
                    return StringLiterals.MyPage.DeleteIDReason.allCases[index].rawValue
                } else { return "" }
            }
        }
        
        enum DeleteIDCheckTitle: String, CaseIterable {
            case first = "삭제된 계정 정보는 복구할 수 없어요"
            case second = "게시글 및 댓글은 자동 삭제되지 않아요"
            case third = "처음부터 다시 가입해야 해요"
        }
        
        enum DeleteIDCheckContent: String, CaseIterable {
            case first = "회원님이 평가하고 기록한 서재 정보와 계정 정보는 탈퇴 즉시 삭제되며, 절대 복구할 수 없어요."
            case second = "리뷰, 피드 게시글, 댓글은 탈퇴 시 자동으로 삭제되지 않아요. 탈퇴 전 개별적으로 삭제해 주세요."
            case third = "계정 정보는 탈퇴 즉시 삭제되어 바로 재가입 가능하지만, 회원가입부터 작품 평가를 다시 해야 해요."
        }
        
        enum ChangeUserInfo {
            static let gender = "성별"
            static let male = "남성"
            static let female = "여성"
            static let birthYear = "출생연도"
            static let complete = "완료"
        }
        
        enum isVisiableProfile {
            static let completeTitle = "완료"
            static let isPrivateProfile = "비공개"
        }
        
        enum PushNotification {
            static let activePushTitle = "활동 알림"
            static let activePushDescription = "댓글, 좋아요 등 알림"
            
            static let moveToSettingAlertTitle = "앱 알림을 켤까요?"
            static let moveToSettingAlertDescription = "웹소소 알림을 받으려면,\n기기 설정에서 알림 허용이 필요해요."
            static let moveCancel = "다음에 하기"
            static let moveAccept = "설정하러 가기"
        }
        
        enum Logout {
            static let logoutTitle = "로그아웃 할까요?"
            static let cancel = "취소"
            static let logout = "로그아웃"
        }
    }
}
