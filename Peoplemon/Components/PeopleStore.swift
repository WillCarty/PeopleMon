//
//  PeopleStore.swift
//  Peoplemon
//
//  Created by Will Carty on 11/7/16.
//  Copyright © 2016 Will Carty. All rights reserved.
//

import Foundation

class PeopleStore {
    static let shared = PeopleStore()
    
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

}
