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
    func convertBase64ToImage(base64String: String?) -> UIImage? {
       
        if let base64String = base64String, let photoData = NSData(base64Encoded: base64String, options: .ignoreUnknownCharacters) {
            return UIImage(data: photoData as Data)
        }
        
        return #imageLiteral(resourceName: "defaultpng")
    }


   
    func getPeople(){
        let people = AccountModel(radius: Constants.radius)
        WebServices.shared.getObjects(people) { (objects, error) in
            if let objects = objects {
                self.annotations = []
                for person in objects {
                    let pin = MapPin(people: person)
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

extension PeopleMonViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView?.isEnabled = true
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            let catcher = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
            catcher.setTitle("Catch", for: .normal)
            catcher.backgroundColor = #colorLiteral(red: 0, green: 0.9771030545, blue: 0.043536596, alpha: 1)
            catcher.sizeToFit()
            
            pinView?.leftCalloutAccessoryView = catcher
           // pinView?.rightCalloutAccessoryView = convertBase64ToImage(base64String: Constants.PeopleMon.avatarBase64)
            
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation1 = view.annotation as! MapPin
        let caughtPerson = AccountModel(caughtUserId: annotation1.userid!, radius: 5000)
        WebServices.shared.postObject(caughtPerson, completion: { (object, error) in
           
        })
        
        
        mapView.removeAnnotation(view.annotation!)
    }
}

