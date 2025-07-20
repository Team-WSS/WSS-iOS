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
    var attractivePointOptions: [AttractivePoint] = []
    var starRatingOption: NovelRatingStatus? = nil
}
