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
    
    // Step 7: Add keychain strings
    public static let keychainIdentifier = "EFABKeychain"
    public static let authTokenExpireDate = "authTokenExpireDate"
    public static let authToken = "authToken"
    
    // Step 19: Add Notification constant
    static let newExpensesFound = "NewExpensesFound"
    
    // Step 3: Create Test Model Constants
    // MARK: Test Model
    struct Test {
        static let userId = "userId"
        static let id = "id"
        static let title = "title"
        static let body = "body"
    }
    
    // Step 4: JSON Constants
    struct JSON {
        static let unknownError = "An Unknown Error Has Occurred"
        static let processingError = "There was an error processing the response"
    }
    
    // Step 9: PeopleMon Constants
    struct PeopleMon {
        static let id = "id"
        static let email = "email"
        static let hasRegistered = true
        static let loginProvider = "loginProvider"
        static let avatarBase64 = "avatar"
        static let lastCheckInLongitude = 0
        static let lastCheckInLatitude = 0
        static let lastCheckInDateTime = "2016-11-07T15:07:43.771Z"
        static let token = "token"
        static let expirationDate = "expiration"
        static let oldPassword = "string"
        static let newPassword = "string"
        static let confirmPassword = "string"
        static let apiKey = "iOS301november2016"
        static let grantType = "string"
        static let fullName = "string"
        static let password = "string"
    }
}
// MARK: - Colors
// Step 14: UIColor extension and
extension UIColor {
    public class func rgba(red: NSInteger, green: NSInteger, blue: NSInteger, alpha: Float = 1.0) -> UIColor {
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha))
    }
}

struct ColorPalette {
    static let PositiveColor = UIColor.rgba(red: 15, green: 181, blue: 46)
    static let NegativeColor = UIColor.rgba(red: 219, green: 31, blue: 31)
    static let BlueColor = UIColor.rgba(red: 12, green: 35, blue: 64)
    static let GoldColor = UIColor.rgba(red: 201, green: 151, blue: 0)
    static let calendarCellColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.1)
    static let calendarTodayColor = UIColor.rgba(red: 12, green: 35, blue: 64, alpha: 0.3)
    static let calendarBorderColor = UIColor.rgba(red: 12, green: 35, blue: 64, alpha: 0.8)
}
