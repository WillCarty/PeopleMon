
//
//  Utilities.swift
//  Peoplemon
//
//  Created by Will Carty on 11/7/16.
//  Copyright © 2016 Will Carty. All rights reserved.
//

import UIKit
import AFDateHelper

class Utils {
    class func createAlert(_ title: String = "Error", message: String, dismissButtonTitle: String = "Dismiss") -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: dismissButtonTitle, style: .default, handler: nil))
        return alert
    }
    
    class func isValidEmail(_ testStr: String) -> Bool {
        let emailRegEx = "[A-Za-z0-9-_.]+[@]{1}[A-Za-z0-9-]+[.]*[A-Za-z0-9-]+[.]{1}[A-Za-z]+"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func adjustedTime(_ date: Date = Date()) -> Date {
        return date.dateByAddingSeconds(TimeZone.current.secondsFromGMT())
    }
    
    class func isNumber(_ string: String) -> Bool {
        let set = CharacterSet(charactersIn:"0123456789.-").inverted
        let components = string.components(separatedBy: set)
        let filtered = components.joined(separator: "")
        return string == filtered
    }
    
    class func formatNumber(_ amount: Double, prefix: String) -> String {
        return String(format: "\(prefix)$%.2f", abs(amount))
    }
   
    class func convertBase64ToImage(base64String: String?) -> UIImage? {
        
        if let base64String = base64String, let photoData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) {
            return UIImage(data: photoData as Data)
        }
        
        return #imageLiteral(resourceName: "defaultpng")
    }
   
   class func convertImageToBase64(image: UIImage?) -> String {
        
        if let image = image, let imageData = UIImagePNGRepresentation(image){
            let base64String = imageData.base64EncodedString()
            
            return base64String
        }
        return ""
    }
    
    class func resizeImage(image: UIImage, maxSize: CGFloat) -> UIImage {
        let newSize: CGSize!
        if image.size.width > image.size.height {
            newSize = CGSize(width: maxSize, height: maxSize * (image.size.height / image.size.width))
        } else {
            newSize = CGSize(width: maxSize * (image.size.width / image.size.height), height: maxSize)
        }
        
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context!.interpolationQuality = .high
        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
        context!.concatenate(flipVertical)
        context!.draw(image.cgImage!, in: newRect)
        let newImage = UIImage(cgImage: context!.makeImage()!)
        UIGraphicsEndImageContext()
        return newImage
    }

}
