//
//  LibraryFilterOption.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/27/25.
//

import UIKit

struct LibraryFilterOption: Equatable, Codable {
    var interestedOption: Bool = false
    var readStatusOptions: [ReadStatus] = []
    var genreOptions: [NovelGenre] = []
    var publicationStatusOptions: [PublicationStatus] = []
    var minimumStarRateOption: CGFloat = 0.0
    var maximumStarRateOption: CGFloat = 5.0
    var notStarRatedOption: Bool = false
    var attractivePointOptions: [AttractivePoint] = []
    var keywordOptions: [KeywordData] = []
}
