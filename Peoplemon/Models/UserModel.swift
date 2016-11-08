//
//  UserModel.swift
//  Peoplemon
//
//  Created by Will Carty on 11/7/16.
//  Copyright © 2016 Will Carty. All rights reserved.
//

import Foundation
import Alamofire
import Freddy

class UserModel: NetworkModel {
    
    var requestType: RequestType = .changePassword
    
    var email: String?
    var fullName: String?
    var avatarBase64: String?
    var apiKey: String?
    var password: String?
    var token: String?
    var expirationDate: String?
    
    var id: String?
    var hasRegistered: Bool?
    var loginProvided: String?
    var lastCheckinLongitude: Double?
    var lastCheckinLatitude: Double?
    var lastCheckinDateTime: String?
    
    var oldPassword: String?
    var newPassword: String?
    var confirmPassword: String?
    
    enum RequestType {
        case userInfo
        case getUserInfo
        case changePassword
        case setPassword
        case register
        
    }
    
    required init() {}
    
    required init(json: JSON) throws {
        token = try? json.getString(at: Constants.PeopleMon.token)
        expirationDate = try? json.getString(at: Constants.PeopleMon.expirationDate)
        
    }
    //
    //    init(username: String, password: String) {
    //        self.email = email
    //        self.password = password
    //        requestType = .login
    //    }
    
    //Register inits
    init(email: String, fullName: String, password: String, apiKey: String, avatarBase64: String?) {
        self.email = email
        self.fullName = fullName
        self.avatarBase64 = avatarBase64
        self.apiKey = apiKey
        self.password = password
        requestType = .register
    }
    //getUserInfo inits
    init(id: String, email: String, hasRegistered: Bool, loginProvided: String, fullName: String, avatarBase64: String, lastCheckinLongitude: Double, lastCheckinLatitude: Double, lastCheckInDateTime: String) {
        self.id = id
        self.email = email
        self.hasRegistered = true
        self.loginProvided = loginProvided
        self.fullName = fullName
        self.avatarBase64 = avatarBase64
        self.lastCheckinLongitude = 0.0
        self.lastCheckinLatitude = 0.0
        self.lastCheckinDateTime = "EEE, dd MMM yyyy HH:mm:ss Z"
        requestType = .getUserInfo
    }
    //userInfo inits
    init(fullName: String, avatarBase64: String) {
        self.fullName = fullName
        self.avatarBase64 = avatarBase64
        requestType = .userInfo
    }
    
    //changePassword inits
    init(oldPassword: String, newPassword: String, confirmPassword: String) {
        self.oldPassword = oldPassword
        self.newPassword = newPassword
        self.confirmPassword = confirmPassword
        requestType = .changePassword
    }
    
    //setPasswords inits
    init(newPassword: String) {
        self.newPassword = newPassword
        requestType = .setPassword
    }
    
    func method() -> Alamofire.HTTPMethod {
    return .post
    }
    
    func path() -> String {
        switch requestType {
        case .getUserInfo:
            return "/api/Account/UserInfo"
        case .userInfo:
            return "/api/Account/UserInfo"
        case .changePassword:
            return "/api/Account/ChangePassword"
        case .setPassword:
            return "/api/Account/SetPassword"
        case .register:
            return "/api/Account/Register"
        default:
            return "Error"
        
        }
    }
    func toDictionary() -> [String: AnyObject]? {
        var params: [String: AnyObject] = [:]
        params[Constants.PeopleMon.email] = email as AnyObject?
        params[Constants.PeopleMon.password] = password as AnyObject?
        params[Constants.PeopleMon.fullName] = fullName as AnyObject?
        params[Constants.PeopleMon.avatarBase64] = avatarBase64 as AnyObject?
        
        
        switch requestType {
        case .register:
            params[Constants.PeopleMon.email] = email as AnyObject?
        default:
            break
        }
        
        return params
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
