//
//  LayoutType.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/26/25.
//

import UIKit

enum LayoutType {
    case grid
    case list
    
    var image: UIImage {
        switch self {
        case .grid: .layoutGrid
        case .list: .layoutList
        }
    }
}
