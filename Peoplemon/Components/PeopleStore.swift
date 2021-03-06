//
//  PeopleStore.swift
//  Peoplemon
//
//  Created by Will Carty on 11/7/16.
//  Copyright © 2016 Will Carty. All rights reserved.
//
import UIKit
import Foundation

protocol PeopleStoreDelegate: class {
    func userLoggedIn()
}

class PeopleStore {
    static let shared = PeopleStore()
    
    var selectedImage: UIImage?
    
    var UserModel: UserModel? {
        didSet{
            if let _ = UserModel{
                delegate?.userLoggedIn()
            }
        }
    }
    weak var delegate: PeopleStoreDelegate?
    
    func register(_ registerUser: UserModel, completion:@escaping (_ success: Bool, _ error: String?) -> Void) {
        WebServices.shared.registerUser(registerUser) { (user, error) -> () in
            if let user = user {
                WebServices.shared.setAuthToken(user.token, expiration: user.expirationDate)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    func login(_ loginUser: UserModel, completion:@escaping (_ success: Bool, _ error: String?) -> Void) {
        WebServices.shared.authUser(loginUser) { (user, error) -> () in
            if let user = user {
                WebServices.shared.setAuthToken(user.token, expiration: user.expirationDate)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    func logout(_ completion:() -> Void) {
        WebServices.shared.clearUserAuthToken()
        completion()
    }
   
}
