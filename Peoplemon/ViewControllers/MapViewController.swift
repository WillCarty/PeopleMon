//
//  MapViewController.swift
//  Peoplemon
//
//  Created by Will Carty on 11/8/16.
//  Copyright © 2016 Will Carty. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var listDirectionsButton: UIBarButtonItem!
    
    let locationManager = CLLocationManager()
    var updatingLocation = true
    let latitudeDelta = 0.2
    let longitudeDelta = 0.2
    
    var search: MKLocalSearch!
    let searchController = UISearchController(searchResultsController: nil)
    var searchResults: [MKMapItem] = []
    
    var annotations: [MapPin] = []
    
    let transitionManager = TransitionManager()
    
    var overlay: MKOverlay?
    var route: MKRoute?
    
    var directionsView: UIView!
    var directionsTableView: UITableView!
    var showingDirections = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Locations"
        self.navigationItem.titleView = searchController.searchBar
        
        tableView.isHidden = true
        
        mapView.delegate = self
        definesPresentationContext = true
        
        navigationController?.delegate = self
        
        setupDirectionsView()
        showDirectionsListButton(false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - IBActions
    @IBAction func updateLocation(_ sender: AnyObject) {
        if !updatingLocation {
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func showDirectionsList(_ sender: AnyObject) {
        showingDirections = true
        directionsTableView.reloadData()
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
            self.directionsView.alpha = 1.0
            self.directionsView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            }, completion: nil)
    }
    
    @IBAction func hideDirectionsList(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
            self.directionsView.alpha = 0.0
            self.directionsView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8).concatenating(CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height))
        }) { (finished) in
            self.showingDirections = false
        }
    }
    
    
    // MARK: - Private Functions
    fileprivate func searchPlaces(_ searchText: String, plotOnMap: Bool) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText
        request.region = mapView.region
        
        if let search = search, search.isSearching {
            search.cancel()
        }
        
        search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let response = response {
                self.searchResults = []
                for item in response.mapItems {
                    print(item.name)
                    self.searchResults.append(item)
                }
                
                if plotOnMap {
                    self.plotLocations()
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    fileprivate func addressString(_ place: MKMapItem) -> String {
        let address = place.placemark.addressDictionary!
        var addressString = ""
        if let formatted = address["FormattedAddressLines"] as? [String] {
            addressString = formatted.joined(separator: ", ")
        }
        return addressString
    }
    
    fileprivate func plotLocations() {
        mapView.removeAnnotations(annotations)
        annotations = []
        for place in searchResults {
            //            let annotation = MKPointAnnotation()
            //            annotation.coordinate = place.placemark.coordinate
            //            annotation.title = place.name
            //            annotation.subtitle = addressString(place)
            let annotation = MapPin(coordinate: place.placemark.coordinate, title: place.name, address: addressString(place), phone: place.phoneNumber, url: place.url)
            
            annotations.append(annotation)
            mapView.addAnnotation(annotation)
        }
        if !searchResults.isEmpty {
            mapView.centerCoordinate = searchResults.first!.placemark.coordinate
        }
    }
    
    fileprivate func plotRoute(_ destination: CLLocationCoordinate2D) {
        if let overlay = overlay {
            mapView.remove(overlay)
        }
        
        if let route = route {
            let polyline = route.polyline
            mapView.add(polyline, level: .aboveRoads)
            mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
            
            showDirectionsListButton(true)
        }
    }
    
    fileprivate func setupDirectionsView() {
        let bounds = UIScreen.main.bounds
        let navbarHeight: CGFloat = 64
        let toolbarHeight: CGFloat = 44
        let padding: CGFloat = 20
        let buttonSize: CGFloat = 32
        let directionsViewFrame = CGRect(x: padding,
                                         y: navbarHeight + padding,
                                         width: bounds.width - (padding * 2),
                                         height: bounds.height - navbarHeight - toolbarHeight - (padding * 2))
        let directionsTableFrame = CGRect(x: 0,
                                          y: buttonSize,
                                          width: directionsViewFrame.size.width,
                                          height: directionsViewFrame.size.height - buttonSize)
        
        let closeButton = UIButton(frame: CGRect(x: 0, y: 0,
                                                 width: directionsViewFrame.width, height: buttonSize))
        
        closeButton.setBackgroundImage(#imageLiteral(resourceName: "CloseButton"), for: UIControlState())
        closeButton.addTarget(self, action: #selector(hideDirectionsList(_:)), for: .touchUpInside)
        
        directionsView = UIView(frame: directionsViewFrame)
        directionsView.backgroundColor = UIColor.white
        
        directionsTableView = UITableView(frame: directionsTableFrame)
        directionsTableView.dataSource = self
        directionsTableView.delegate = self
        directionsTableView.rowHeight = UITableViewAutomaticDimension
        directionsTableView.estimatedRowHeight = 44
        
        directionsView.layer.cornerRadius = 8
        directionsView.clipsToBounds = true
        directionsView.layer.masksToBounds = true
        directionsView.layer.shadowColor = UIColor.black.cgColor
        directionsView.layer.shadowOffset = CGSize(width: 0, height: 5)
        directionsView.layer.shadowOpacity = 0.3
        directionsView.layer.shadowRadius = 10.0
        directionsView.alpha = 0.0
        let scaleTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        let translateTransform = CGAffineTransform(translationX: 0, y: bounds.height)
        directionsView.transform = scaleTransform.concatenating(translateTransform)
        
        directionsView.addSubview(directionsTableView)
        directionsView.addSubview(closeButton)
        
        view.addSubview(directionsView)
    }
    
    fileprivate func showDirectionsListButton(_ show: Bool) {
        if show {
            listDirectionsButton.title = "List Directions"
            listDirectionsButton.isEnabled = true
        } else {
            listDirectionsButton.title = ""
            listDirectionsButton.isEnabled = false
        }
    }
}


// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpanMake(latitudeDelta, longitudeDelta))
        mapView.setRegion(region, animated: true)
        updatingLocation = false
        locationManager.stopUpdatingLocation()
    }
}


// MARK: - UISearchResultsUpdating
extension MapViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text,
            searchText != "" {
            searchPlaces(searchText, plotOnMap: false)
        } else {
            searchResults = []
            if let search = search, search.isSearching {
                search.cancel()
            }
            
            tableView.reloadData()
        }
    }
}


// MARK: - UISearchBarDelegate
extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, searchText != "" {
            searchPlaces(searchText, plotOnMap: true)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = false
        
        showDirectionsListButton(false)
        hideDirectionsList(self)
        
        if let overlay = overlay {
            mapView.remove(overlay)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        showDirectionsListButton(false)
        hideDirectionsList(self)
        
        if let overlay = overlay {
            mapView.remove(overlay)
        }
        
        searchResults = []
        tableView.reloadData()
        
        mapView.removeAnnotations(annotations)
        annotations = []
    }
}


// MARK: - UITableView Delegate/Datasource
extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return searchResults.count
        return showingDirections ? route!.steps.count : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if showingDirections {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "directionCell")
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.text = route!.steps[indexPath.row].instructions
            
            return cell
        } else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "searchCell")
            let place = searchResults[indexPath.row]
            
            cell.textLabel?.text = place.name
            cell.detailTextLabel?.text = addressString(place)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !showingDirections {
            tableView.deselectRow(at: indexPath, animated: true)
            let place = searchResults[indexPath.row]
            searchResults = [place]
            
            if let search = search, search.isSearching {
                search.cancel()
            }
            
            plotLocations()
            searchController.searchBar.resignFirstResponder()
            mapView.selectAnnotation(annotations.first!, animated: false)
            tableView.isHidden = true
        }
    }
}


// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            
            let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            leftButton.setImage(#imageLiteral(resourceName: "info"), for: .normal)
            pinView!.leftCalloutAccessoryView = leftButton
            
            let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            rightButton.setImage(#imageLiteral(resourceName: "directions"), for: .normal)
            pinView!.rightCalloutAccessoryView = rightButton
            
            if let mapPin = annotation as? MapPin {
                let addressLabel = UILabel()
                addressLabel.numberOfLines = 0
                addressLabel.font = UIFont.systemFont(ofSize: 12)
                addressLabel.text = mapPin.subtitle
                addressLabel.sizeToFit()
                addressLabel.preferredMaxLayoutWidth = 240
                
                var labels = [addressLabel]
                
                if let phone = mapPin.phone {
                    let phoneLabel = UILabel()
                    phoneLabel.font = UIFont.systemFont(ofSize: 12)
                    phoneLabel.text = phone
                    labels.append(phoneLabel)
                }
                
                let stackView = UIStackView(arrangedSubviews: labels)
                stackView.axis = .vertical
                stackView.alignment = .leading
                stackView.distribution = .equalSpacing
                stackView.spacing = 4
                
                pinView!.detailCalloutAccessoryView = stackView
                
                pinView!.leftCalloutAccessoryView!.tag = 0
                pinView!.rightCalloutAccessoryView!.tag = 1
            }
            
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control.tag == 0 {
            if let mapPin = view.annotation as? MapPin {
                let mapDetailVC = storyboard!.instantiateViewController(withIdentifier: String(describing: MapDetailViewController.self)) as! MapDetailViewController
                
                mapDetailVC.region = mapView.region
                
                mapDetailVC.mapPin = mapPin
                navigationController?.pushViewController(mapDetailVC, animated: true)
            }
        } else if control.tag == 1 {
            if let coordinate = view.annotation?.coordinate {
                let request = MKDirectionsRequest()
                mapView.deselectAnnotation(view.annotation, animated: true)
                request.source = MKMapItem.forCurrentLocation()
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
                
                let directions = MKDirections(request: request)
                directions.calculate(completionHandler: { (response, error) in
                    guard let response = response else {
                        return
                    }
                    self.route = response.routes.first
                    self.plotRoute(coordinate)
                })
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        self.overlay = overlay
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        renderer.lineWidth = 5.0
        renderer.lineCap = .round
        return renderer
    }
}


// MARK: - UINavigationControllerDelegate
extension MapViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionManager.reverse = operation == .pop
        return transitionManager
    }
}










