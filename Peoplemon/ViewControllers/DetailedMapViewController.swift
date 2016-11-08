//
//  DetailedMapViewController.swift
//  Peoplemon
//
//  Created by Will Carty on 11/8/16.
//  Copyright © 2016 Will Carty. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class MapDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var webButton: UIButton!
    
    var mapPin: MapPin!
    var region: MKCoordinateRegion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = mapPin.title {
            nameLabel.text = name
        } else {
            stackView.removeArrangedSubview(nameLabel)
        }
        
        if let address = mapPin.subtitle {
            addressLabel.text = address
        } else {
            stackView.removeArrangedSubview(addressLabel)
        }
        
        if let phoneNumber = mapPin.phone {
            phoneButton.setTitle(phoneNumber, for: .normal)
        } else {
            stackView.removeArrangedSubview(phoneButton)
        }
        
        if let _ = mapPin.url {
            webButton.setTitle("View Website", for: .normal)
        } else {
            stackView.removeArrangedSubview(webButton)
        }
        
        let options = MKMapSnapshotOptions()
        
        options.region = region
        options.size = CGSize(width: view.frame.size.width, height: 120)
        options.scale = UIScreen.main.scale
        
        let snapShotter = MKMapSnapshotter(options: options)
        self.imageView.image = #imageLiteral(resourceName: "MapMarker")
        snapShotter.start(with: DispatchQueue.global(qos: .default)) { (snapshot, error) in
            guard let snapshot = snapshot else {
                return
            }
            
            let pin = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
            let image = snapshot.image
            
            UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
            image.draw(at: CGPoint.zero)
            
            let visibleRect = CGRect(origin: CGPoint.zero, size: image.size)
            var point = snapshot.point(for: self.mapPin.coordinate)
            if visibleRect.contains(point) {
                point.x = point.x + pin.centerOffset.x - (pin.bounds.size.width / 2)
                point.y = point.y + pin.centerOffset.y - (pin.bounds.size.height / 2)
                pin.image?.draw(at: point)
            }
            
            let compositeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            DispatchQueue.main.async(execute: {
                self.imageView.image = compositeImage
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    // MARK: - IBActions
    @IBAction func callNumber(_ sender: AnyObject) {
        if let number = mapPin.phone {
            let alert = UIAlertController(title: "Make Call", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Call \(number)", style: .default, handler: { (action) in
                let stringArray = number.components(separatedBy: CharacterSet.decimalDigits.inverted)
                let numberString = stringArray.joined(separator: "")
                UIApplication.shared.open(URL(string: "tel://\(numberString)")!, options: [:], completionHandler: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func visitWebsite(_ sender: AnyObject) {
        if let url = mapPin.url {
            let safariVC = SFSafariViewController(url: url)
            safariVC.delegate = self
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func openInMap(_ sender: AnyObject) {
        var urlString = "http://maps.apple.com/?ll=\(mapPin.coordinate.latitude),\(mapPin.coordinate.longitude)"
        if let name = mapPin.title {
            let nameString = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            urlString += "&q=\(nameString)"
        }
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}


// MARK: - SFSafariViewControllerDelegate
extension MapDetailViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true, completion: nil)
    }
}
