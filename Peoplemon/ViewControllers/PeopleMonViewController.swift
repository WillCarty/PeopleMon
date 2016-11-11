//
//  MapViewController.swift
//  Peoplemon
//
//  Created by Will Carty on 11/8/16.
//  Copyright © 2016 Will Carty. All rights reserved.
//
import Foundation
import UIKit
import MapKit
import CoreLocation


class PeopleMonViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var updatingLocation = true
    var latitudeDelta = 0.002
    var longitudeDelta = 0.002
    
    var annotations: [MapPin] = []
    var overlay: MKOverlay?
    var firstLocation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        mapView.mapType = MKMapType.hybrid
        mapView.showsUserLocation = true
        mapView.showsCompass = true
//        mapView.userLocation.title = "My Location"
//        mapView.userLocation.subtitle = "I am here"
       
        mapView.delegate = self
       // performSegue(withIdentifier: "PresentLoginNoAnimation", sender: self)
        checkIn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !WebServices.shared.userAuthTokenExists() || WebServices.shared.userAuthTokenExpired() {
            performSegue(withIdentifier: "PresentLoginNoAnimation", sender: self)
        }
        
    }
    // Do any additional setup after loading the view.
    func checkIn() {
        if updatingLocation == true {
            let coordinate = locationManager.location?.coordinate
            let user = AccountModel(coordinate: coordinate!)
            WebServices.shared.postObject(user, completion: { (object, error) in
            })
        }
    }


   
    func getPeople(){
        let people = AccountModel(radius: Constants.radius)
        WebServices.shared.getObjects(people) { (objects, error) in
            if let objects = objects {
                self.annotations = []
                for person in objects {
                    let pin = MapPin(person: person)
                    self.annotations.append(pin)
                
                }
                self.mapView.addAnnotations(self.annotations)
            }
        }
        
    }
        
    @IBAction func nearbyButton(_ sender: AnyObject) {
    getPeople()
    }
    
    @IBAction func logout(_ sender: AnyObject) {
            WebServices.shared.clearUserAuthToken()
            PeopleStore.shared.logout{}
            
            performSegue(withIdentifier: "PresentLoginNoAnimation", sender: self)
        }
    }
// MARK: - CLLocationManagerDelegate
extension PeopleMonViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations.last!
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpanMake(latitudeDelta, longitudeDelta))
        mapView.setRegion(region, animated: true)
       
        
        locationManager.stopUpdatingLocation()
    }
}

//extension PeopleMonViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation is MKUserLocation {
//            return nil
//        }
//        let reuseId = "pin"
//        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
//         if pinView == nil {
//            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//            pinView!.canShowCallout = true
//            pinView!.animatesDrop = true
//            
//           
//           } else {
//            pinView!.annotation = annotation
//        
//        }
//        
//        return pinView
//    }
//    
//
//        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//            if let mapPin = view.annotation as? MapPin, let person = mapPin.person, let name = person.userName  , let userId = person.userId {
//                let alert = UIAlertController(title: "Catch User", message: "Catch \(name)?", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Catch", style: .default, handler: { (action) in
//                    
//                    let catchPerson = AccountModel(caughtUserId: userId, radius: Constants.radius)
//                    WebServices.shared.postObject(catchPerson, completion: { (object, error) in
//                        if let error = error {
//                            self.present(Utils.createAlert(message: error), animated: true, completion: nil)
//                        } else {
//                            self.present(Utils.createAlert(message:(error)!), animated: true, completion: nil)
//                        }
//                    })
//                }))
//                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            }
//        }
//    }
//
//
