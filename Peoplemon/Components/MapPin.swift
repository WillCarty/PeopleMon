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
        var person: AccountModel?
        var title: String?
        
        
        init(person: AccountModel?) {
            self.person = person
            self.title = (person?.userName)!
            if let latitude = person?.latitude, let longitude = person?.longitude{
                self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            } else {
                self.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            }
            
        }
}
