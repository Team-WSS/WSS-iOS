//
//  ImageLiterals.swift
//  WSSiOS
//
//  Created by 최서연 on 1/4/24.
//

import UIKit

enum ImageLiterals {
    
    enum icon {
        enum icAlert {
            static var icDefault: UIImage{ .load(named: "default")}
            static var icWarning: UIImage{ .load(named: "warning")}
        }
        
        enum icBookRegistration {
            static var icNoResult: UIImage{ .load(named: "no result")}
            static var icPlus: UIImage{ .load(named: "plus")}
        }
        
        enum icCreateMemo {
            static var icBig: UIImage{ .load(named: "big")}
            static var icSmall: UIImage{ .load(named: "small")}
        }
        
        enum icGenre {
            static var bl: UIImage{ .load(named: "icGenreBL")}
            static var drama: UIImage{ .load(named: "icGenreD")}
            static var rantasy: UIImage{ .load(named: "icGenreF")}
            static var modernFantasy: UIImage{ .load(named: "icGenreHF")}
            static var lightNovel: UIImage{ .load(named: "icGenreLN")}
            static var orientalFantasy: UIImage{ .load(named: "icGenreMH")}
            static var mystery: UIImage{ .load(named: "icGenreMT")}
            static var romance: UIImage{ .load(named: "icGenreR")}
            static var romanceFantasy: UIImage{ .load(named: "icGenreRF")}
        }
        
        enum icStar {
            static var fill: UIImage{ .load(named: "icStarFill")}
            static var half: UIImage{ .load(named: "icStarHalf")}
            static var empty: UIImage{ .load(named: "icStarUnfilled")}
        }
        
        enum icTagStatus {
            static var stop: UIImage{ .load(named: "icTagStop")}
            static var reading: UIImage{ .load(named: "icTagReading")}
            static var interest: UIImage{ .load(named: "icTagInterest")}
            static var finished: UIImage{ .load(named: "icTagFinished")}
        }
        
        static var calender: UIImage{ .load(named: "icCalender")}
        static var deleteMemo: UIImage{ .load(named: "icDeleteMemo")}
        static var dropDown: UIImage{ .load(named: "icDropDown")}
        static var linkPlatform: UIImage{ .load(named: "icLinkPlatform")}
        static var meatballMemo: UIImage{ .load(named: "icMeatballMemo")}
        static var navigateLeft: UIImage{ .load(named: "icNavigateLeft")}
        static var plusKeyword: UIImage{ .load(named: "icPlusKeyword")}
        static var search: UIImage{ .load(named: "icSearch")}
    }
}
