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
import MapKit

class AccountModel: NetworkModel {
    
    var requestType: RequestType = .nearby
    
    ///v1/User/Nearby Get vars
    var userId: String?
    var userName: String?
    var avatarBase64: String?
    var created: String?
    
    ///v1 and v2/User/CheckIn Vars
    var longitude: Double?
    var latitude: Double?
    
    ///v1/User/Catch vars
    var caughtUserId: String?
    var radius: Double?
    
    enum RequestType{
        case nearby
        case checkin
        case Catch
        case caught
        
    }
    
    required init() {}
    
    required init(json: JSON) throws {
        userId = try? json.getString(at: Constants.PeopleMon.UserId)
        userName = try? json.getString(at: Constants.PeopleMon.UserName)
        avatarBase64 = try? json.getString(at: Constants.PeopleMon.AvatarBase64)
        created = try? json.getString(at: Constants.PeopleMon.Created)
        longitude = try? json.getDouble(at: Constants.PeopleMon.longitude)
        latitude = try? json.getDouble(at: Constants.PeopleMon.latitude)
        caughtUserId = try? json.getString(at: Constants.PeopleMon.CaughtUserId)
        radius = try? json.getDouble(at: Constants.PeopleMon.radius)
        
    }
    
    //nearby inits
    init(radius: Double?) {
        self.requestType = .nearby
        self.radius = radius
        
    }
    //checkIn init
    init(coordinate: CLLocationCoordinate2D) {
        self.longitude = coordinate.longitude
        self.latitude = coordinate.latitude
        self.requestType = .checkin
    }
    init(caughtUserId: String?, radius: Double?){
        self.caughtUserId = caughtUserId
        self.radius = radius
        self.requestType = .caught
    }

    
    func method() -> HTTPMethod {
        switch requestType {
        case .checkin:
            return .post
        case . Catch:
            return .post
        case .nearby:
            return .get
        case .caught:
            return .get
        }
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
            params[Constants.PeopleMon.radius] = radius as AnyObject?
        case .checkin:
            params[Constants.PeopleMon.longitude] = longitude as AnyObject?
            params[Constants.PeopleMon.latitude] = latitude as AnyObject?
        case .Catch:
            params[Constants.PeopleMon.CaughtUserId] = caughtUserId as AnyObject?
            params[Constants.PeopleMon.radius] = radius as AnyObject?
        case .caught:
        params[Constants.PeopleMon.Created] = created as AnyObject?
            params[Constants.PeopleMon.AvatarBase64] = avatarBase64 as AnyObject?
        }
        
        return params
        
    }
    
}
