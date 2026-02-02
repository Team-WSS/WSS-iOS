//
//  NotificationName.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/4/25.
//

import Foundation

enum NotificationName {
    static let novelReviewKeywordSelected = Notification.Name("novelReviewKeywordSelected")
    static let novelReviewDataSelected = Notification.Name("novelReviewDataSelected")
    static let novelReviewDateRemoved = Notification.Name("novelReviewDateRemoved")
    static let feedEdited = Notification.Name("feedEdited")
    static let novelReviewed = Notification.Name("novelReviewed")
    static let popFeedDetailViewController = Notification.Name("popFeedDetailViewController")
    static let feedNovelConnected = Notification.Name("feedNovelConnected")
    static let blockUser = Notification.Name("BlockUser")
    static let pushToUpdateDetailSearchResult = Notification.Name("pushToUpdateDetailSearchResult")
    static let pushToDetailSearchResult = Notification.Name("pushToDetailSearchResult")
    static let changeRepresentativeAvatar = Notification.Name("changeRepresentativeAvatar")
    static let moveToLibraryTab = Notification.Name("moveToLibraryTab")
    static let editProfile = Notification.Name("editProfile")
}
