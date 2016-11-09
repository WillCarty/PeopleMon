//
//  Constants.swift
//  Peoplemon
//
//  Created by Will Carty on 11/7/16.
//  Copyright © 2016 Will Carty. All rights reserved.
//

import Foundation
import UIKit
import Hue
struct Constants {
    // Step 16: Add monthDayYear
    static let monthDayYear = "MM/dd/yyyy"
    
    //SegueIdentifiers
    enum SegueIdentifier: String {
        case PresentLoginNoAnimation
        case PresentLogin
        case ShowRegister
        case ShowPeopleMon
        case ShowCredits
    }

    
    // Step 7: Add keychain strings
    public static let keychainIdentifier = "PeopleMonKeychain"
    public static let authTokenExpireDate = "authTokenExpireDate"
    public static let authToken = "authToken"
    static let apiKey = "iOSandroid301november2016"

    // Step 4: JSON Constants
    struct JSON {
        static let unknownError = "An Unknown Error Has Occurred"
        static let processingError = "There was an error processing the response"
    }
    
    // Step 9: PeopleMon Constants
    struct PeopleMon {
        static let id = "Id"
        static let email = "Email"
        static let hasRegistered = "HasRegistered"
        static let loginProvider = "LoginProvider"
        static let avatarBase64 = "AvatarBase64"
        static let lastCheckInLongitude = "LastCheckInLongitude"
        static let lastCheckInLatitude = "LastCheckInLatitude"
        static let lastCheckInDateTime = "2016-11-07T15:07:43.771Z"
        static let token = "access_token"
        static let expirationDate = ".expires"
        static let oldPassword = "OldPassword"
        static let newPassword = "NewPassword"
        static let confirmPassword = "ConfirmPassword"
        
        static let grantType = "grant_type"
        static let fullName = "FullName"
        static let password = "password"
        static let apiKey = "ApiKey"
        static let username = "username"
    
        //v1/User/Nearby Contants
        static let UserId = "UserId"
        static let UserName = "UserName"
        static let AvatarBase64 = "AvatarBase64"
        static let Longitude = "Longitude"
        static let Latitude = "Latitude"
        
        //catch constants
        static let CaughtUserId = "CaughtUserId"
        static let RadiusInMeters = "RadiusInMeters"
        
        //
        static let Created = "Created"

    }
}
// MARK: - Colors
// Step 14: UIColor extension and
//extension UIColor {
//    public class func rgba(red: NSInteger, green: NSInteger, blue: NSInteger, alpha: Float = 1.0) -> UIColor {
//        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha))
//    }
//}
//
//struct ColorPalette {
//    static let PositiveColor = UIColor.rgba(red: 15, green: 181, blue: 46)
//    static let NegativeColor = UIColor.rgba(red: 219, green: 31, blue: 31)
//    static let BlueColor = UIColor.rgba(red: 12, green: 35, blue: 64)
//    static let GoldColor = UIColor.rgba(red: 201, green: 151, blue: 0)
//    static let calendarCellColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.1)
//    static let calendarTodayColor = UIColor.rgba(red: 12, green: 35, blue: 64, alpha: 0.3)
//    static let calendarBorderColor = UIColor.rgba(red: 12, green: 35, blue: 64, alpha: 0.8)
//}
