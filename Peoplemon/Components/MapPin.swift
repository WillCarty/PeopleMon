//
//  MapPin.swift
//  Peoplemon
//
//  Created by Will Carty on 11/8/16.
//  Copyright © 2016 Will Carty. All rights reserved.
//

import Foundation
import MapKit


class MapPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var people: AccountModel?
    var title: String?
    var userid: String?
    
    
    init(people: AccountModel) {
        self.people = people
        self.title = people.userName
        self.userid = people.userId
        if let lat = people.latitude, let long = people.longitude {
            self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        } else {
            self.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
    }
}
