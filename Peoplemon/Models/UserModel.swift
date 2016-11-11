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
    var username: String?
    
    var id: String?
    var hasRegistered: Bool?
    var loginProvider: String?
    var lastCheckinLongitude: Double?
    var lastCheckinLatitude: Double?
    var lastCheckinDateTime: String?
    
    var oldPassword: String?
    var newPassword: String?
    var confirmPassword: String?
    
    var grantType: String? = "password"
    
    enum RequestType {
        case userInfo
        case getUserInfo
        case changePassword
        case setPassword
        case register
        case login
        
    }
    
    required init() {
    requestType = .getUserInfo
    }

    
    required init(json: JSON) throws {
        token = try? json.getString(at: Constants.PeopleMon.token)
        expirationDate = try? json.getString(at: Constants.PeopleMon.expirationDate)
        id = try? json.getString(at: Constants.PeopleMon.id)
        email = try? json.getString(at: Constants.PeopleMon.email)
        hasRegistered = try? json.getBool(at: Constants.PeopleMon.hasRegistered)
        loginProvider = try? json.getString(at: Constants.PeopleMon.loginProvider)
        fullName = try? json.getString(at: Constants.PeopleMon.fullName)
        avatarBase64 = try? json.getString(at: Constants.PeopleMon.avatarBase64)
        lastCheckinDateTime = try? json.getString(at: Constants.PeopleMon.lastCheckInDateTime)
        lastCheckinLongitude = try? json.getDouble(at: Constants.PeopleMon.lastCheckInLongitude)
        lastCheckinLatitude = try? json.getDouble(at: Constants.PeopleMon.lastCheckInLatitude)
        // check on why try! and not try?
        grantType = try? json.getString(at: Constants.PeopleMon.grantType)
        username = try? json.getString(at: Constants.PeopleMon.email)
        password = try? json.getString(at: Constants.PeopleMon.token)
        print(avatarBase64)
        
    }
    //Login inits
    init(username: String, password: String) {
           // self.grantType = grantType
            self.username = username
            self.password = password
            requestType = .login

    
        }
    
    //Register inits
    init(email: String, password: String, fullName: String, avatarBase64: String) {
        self.email = email
        self.password = password
        self.fullName = fullName
        self.avatarBase64 = avatarBase64
        self.apiKey = Constants.apiKey
        
        requestType = .register
    }
    //getUserInfo inits
    init(id: String, email: String, hasRegistered: Bool, loginProvider: String, fullName: String, avatarBase64: String, lastCheckinLongitude: Double, lastCheckinLatitude: Double, lastCheckInDateTime: String) {
        self.id = id
        self.email = email
        self.hasRegistered = true
        self.loginProvider = loginProvider
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
    //updateInfo init
    init(avatarBase64 : String, fullName: String) {
        self.avatarBase64 = avatarBase64
        self.fullName = fullName
        requestType = .userInfo
    }

    
    func method() -> Alamofire.HTTPMethod {
        switch requestType {
        case .getUserInfo:
            return .get
        default:
            return .post
        }
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
        case .login:
            return "/token"
        }
    }
    func toDictionary() -> [String: AnyObject]? {
        var params: [String: AnyObject] = [:]
        switch requestType {
        case .register:
            params[Constants.PeopleMon.email] = email as AnyObject?
            params[Constants.PeopleMon.fullName] = fullName as AnyObject?
            params[Constants.PeopleMon.avatarBase64] = avatarBase64 as AnyObject?
            params[Constants.PeopleMon.apiKey] = self.apiKey as AnyObject?
            params[Constants.PeopleMon.password] = password as AnyObject?
        case .login:
            params[Constants.PeopleMon.grantType] = grantType as AnyObject?
            params[Constants.PeopleMon.username] = username as AnyObject?
            params[Constants.PeopleMon.password] = password as AnyObject?
        case .userInfo:
            params[Constants.PeopleMon.avatarBase64] = avatarBase64 as AnyObject?
            params[Constants.PeopleMon.fullName] = fullName as AnyObject?
 
        case .getUserInfo:
            break
        
            
           
        default:
            break
        }
        
        return params
    }

}
