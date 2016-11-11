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
    
    var checkInTimer: Timer?
    
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
        
        
        mapView.delegate = self
        checkInTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(PeopleMonViewController.checkIn), userInfo: nil, repeats: true)
        
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
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView?.isEnabled = true
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            if let mapPin = annotation as? MapPin {
                let user = mapPin.people
                if let pinImage = Utils.convertBase64ToImage(base64String: user?.avatarBase64) {
                    pinView?.image = Utils.resizeImage(image: pinImage , maxSize: 20)
                } else {
                    pinView?.image = Utils.resizeImage(image: #imageLiteral(resourceName: "defaultpng"), maxSize: 20)
                }
                let catcher = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
                catcher.setTitle("Catch", for: .normal)
                catcher.backgroundColor = #colorLiteral(red: 0, green: 0.9771030545, blue: 0.043536596, alpha: 1)
                catcher.sizeToFit()
                
                
                
                pinView?.leftCalloutAccessoryView = catcher
                let imgView = UIImageView()
                let image = Utils.convertBase64ToImage(base64String: user?.avatarBase64)
                pinView?.layer.borderWidth = 2
                pinView?.layer.borderColor = UIColor(red: 0, green: 0 , blue: 0, alpha: 1).cgColor
                pinView?.layer.cornerRadius = 5
                imgView.image = image
                pinView?.rightCalloutAccessoryView = imgView
                
            }
            
            
            
            
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation1 = view.annotation as! MapPin
        let caughtPerson = AccountModel(userId: Constants.PeopleMon.UserId, radius: 500.0)
        WebServices.shared.postObject(caughtPerson, completion: { (object, error) in
            
        })
        
        
        mapView.removeAnnotation(view.annotation!)
    }
}

