//
//  AccountModel.swift
//  Peoplemon
//
//  Created by Will Carty on 11/7/16.
//  Copyright © 2016 Will Carty. All rights reserved.
//

import Foundation
import Alamofire
import Freddy

class AccountModel: NetworkModel {
    
    var requestType: RequestType = .nearby
    
    ///v1/User/Nearby Get vars
    var UserId: String?
    var UserName: String?
    var AvatarBase64: String?
    var Created: String?
    
    ///v1 and v2/User/CheckIn Vars
    var Longitude: Double?
    var Latitude: Double?
    
    ///v1/User/Catch vars
    var CaughtUserId: String?
    var RadiusInMeters: Double?
    
    enum RequestType{
        case nearby
        case checkin
        case Catch
        case caught
        
    }
    
    required init() {}
    
    required init(json: JSON) throws {
        UserId = try? json.getString(at: Constants.PeopleMon.UserId)
        UserName = try? json.getString(at: Constants.PeopleMon.UserName)
        AvatarBase64 = try? json.getString(at: Constants.PeopleMon.AvatarBase64)
        Created = try? json.getString(at: Constants.PeopleMon.Created)
        Longitude = try? json.getDouble(at: Constants.PeopleMon.Longitude)
        Latitude = try? json.getDouble(at: Constants.PeopleMon.Latitude)
        CaughtUserId = try? json.getString(at: Constants.PeopleMon.CaughtUserId)
        RadiusInMeters = try? json.getDouble(at: Constants.PeopleMon.RadiusInMeters)

    }
    
    func method() -> HTTPMethod {
        return .post
        }
    func path() -> String {
        switch requestType {
        case .nearby :
            return "/v1/User/Nearby"
        case .checkin:
            return "/v1/User/CheckIn"
        case .Catch:
            return "/v1/User/Catch"
        case .caught:
            return "/v1/User/Caught"
                    }
    }
    func toDictionary() -> [String : AnyObject]? {
        var params: [String: AnyObject] = [:]
        switch requestType {
        case .nearby:
            params[Constants.PeopleMon.UserId] = UserId as AnyObject?
            params[Constants.PeopleMon.UserName] = UserName as AnyObject?
            params[Constants.PeopleMon.AvatarBase64] = AvatarBase64 as AnyObject
            params[Constants.PeopleMon.Longitude] = Longitude as AnyObject
            params[Constants.PeopleMon.Latitude] = Latitude as AnyObject
            params[Constants.PeopleMon.Created] = Created as AnyObject
        case .checkin:
            params[Constants.PeopleMon.Longitude] = Longitude as AnyObject
            params[Constants.PeopleMon.Latitude] = Latitude as AnyObject
        case .Catch:
            params[Constants.PeopleMon.CaughtUserId] = CaughtUserId as AnyObject
            params[Constants.PeopleMon.RadiusInMeters] = RadiusInMeters as AnyObject
        case .caught:
            params[Constants.PeopleMon.UserId] = UserId as AnyObject
            params[Constants.PeopleMon.UserName] = UserName as AnyObject
            params[Constants.PeopleMon.Created] = Created as AnyObject
            params[Constants.PeopleMon.AvatarBase64] = AvatarBase64 as AnyObject
        }

    
    
}
