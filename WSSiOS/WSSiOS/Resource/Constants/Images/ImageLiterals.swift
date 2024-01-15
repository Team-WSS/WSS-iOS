//
//  ImageLiterals.swift
//  WSSiOS
//
//  Created by 최서연 on 1/4/24.
//

import UIKit

enum ImageLiterals {
    
    enum icon {
        enum Alert {
            static var success: UIImage{ .load(named: "icAlertSuccess")}
            static var warning: UIImage{ .load(named: "icAlertWarning")}
        }
        
        enum BookRegistration {
            static var noResult: UIImage{ .load(named: "icBookRegistrationNoresult")}
            static var plus: UIImage{ .load(named: "icBookRegistrationPlus")}
        }
        
        enum Memo {
            static var big: UIImage{ .load(named: "icCreateMemoBig")}
            static var small: UIImage{ .load(named: "icCreateMemoSmall")}
            static var delete: UIImage{ .load(named: "icDeleteMemo")}
        }
        
        enum Genre {
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
        
        enum Star {
            static var fill: UIImage{ .load(named: "icStarFill")}
            static var half: UIImage{ .load(named: "icStarHalf")}
            static var empty: UIImage{ .load(named: "icStarEmpty")}
        }
        
        enum TagStatus {
            static var stop: UIImage{ .load(named: "icTagStop")}
            static var reading: UIImage{ .load(named: "icTagReading")}
            static var interest: UIImage{ .load(named: "icTagInterest")}
            static var finished: UIImage{ .load(named: "icTagFinished")}
        }
        
        enum Tabbar {
            static var home: UIImage{ .load(named: "icNavigateHome")}
            static var homeSelected: UIImage{ .load(named: "icNavigateHomeSelected")}
            static var library: UIImage{ .load(named: "icNavigateLibrary")}
            static var librarySelected: UIImage{ .load(named: "icNavigateLibrarySelected")}
            static var record: UIImage{ .load(named: "icNavigateRecord")}
            static var recordSelected: UIImage{ .load(named: "icNavigateRecordSelected")}
            static var myPage: UIImage{ .load(named: "icNavigateMy")}
            static var myPageSelected: UIImage{ .load(named: "icNavigateMySelected")}
        }
        
        enum Badge {
            static var logo: UIImage{ .load(named: "badgeLogo")}
            static var RF: UIImage{ .load(named: "badgeRF")}
            static var HF: UIImage{ .load(named: "badgeHF")}
            static var MH: UIImage{ .load(named: "badgeMH")}
            static var M: UIImage{ .load(named: "badgeM")}
            static var F: UIImage{ .load(named: "badgeF")}
            static var LN: UIImage{ .load(named: "badgeLN")}
            static var D: UIImage{ .load(named: "badgeD")}
            static var R: UIImage{ .load(named: "badgeR")}
            static var BL: UIImage{ .load(named: "badgeBL")}
        }
        
        enum MyPage {
            static var register: UIImage{ .load(named: "register")}
            static var record: UIImage{ .load(named: "record")}
            static var right: UIImage{ .load(named: "icRight")}
        }
        
        static var calender: UIImage{ .load(named: "icCalendar")}
        static var dropDown: UIImage{ .load(named: "icDropDown")}
        static var linkPlatform: UIImage{ .load(named: "icLinkPlatform")}
        static var navigateLeft: UIImage{ .load(named: "icNavigateLeft")}
        static var meatballMemo: UIImage{ .load(named: "icMeatballMemo")}
        static var plusKeyword: UIImage{ .load(named: "icPlusKeyword")}
        static var search: UIImage{ .load(named: "icSearch")}
        static var searchCancel: UIImage{ .load(named: "icSearchCancel")}
        static var imgLogoType: UIImage{ .load(named: "imgLogoType")}
        static var sosopickCircle: UIImage { .load(named: "sosopickCircle")}
        static var warning: UIImage { .load(named: "icWarning")}
    }
}
