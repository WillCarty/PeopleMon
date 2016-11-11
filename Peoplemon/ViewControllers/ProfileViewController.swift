//
//  ProfileViewController.swift
//  Peoplemon
//
//  Created by Will Carty on 11/10/16.
//  Copyright © 2016 Will Carty. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProfileViewController: UIViewController {
    //IBOutlets
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    let defaultAvatarImage = #imageLiteral(resourceName: "defaultpng")
    var avatar: String = ""
    var user = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user.requestType = .getUserInfo
        
        
        
        
        
        WebServices.shared.getObject(user, completion: { (object, error) in
            if let object = object {
                self.user = object
                self.emailLabel.text = self.user.email
                self.fullnameLabel.text = self.user.fullName
                print(self.user.avatarBase64)
                
                self.profilePicture.image = self.convertBase64ToImage(base64String: self.user.avatarBase64)
                print(self.user.avatarBase64)
            }
        })
    }
    
    func convertImageToBase64(image: UIImage?) -> String {
        
        if let image = image, let imageData = UIImagePNGRepresentation(image){
            let base64String = imageData.base64EncodedString()
            
            return base64String
        }
        return ""
    }
    
    
    
    
    
    func convertBase64ToImage(base64String: String?) -> UIImage? {
        
        if let base64String = base64String, let photoData = NSData(base64Encoded: base64String, options: .ignoreUnknownCharacters) {
            return UIImage(data: photoData as Data)
        }
        
        return defaultAvatarImage
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func showPicker(_ type: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func choosePhoto(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Picture", message: "Choose a picture type", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.showPicker(.camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.showPicker(.photoLibrary)
        }))
        present(alert, animated: true, completion: nil)
    }
        @IBAction func saveButton(_ sender: AnyObject) {
        guard let newFullName = fullnameLabel.text, newFullName != "" else {
            let alert = Utils.createAlert("Login Error", message: "Please provide a Full Name", dismissButtonTitle: "Dismiss")
            present(alert, animated: true, completion: nil)
            return
        }
        
        
        
        let user = UserModel(avatarBase64: convertImageToBase64(image: profilePicture.image), fullName: newFullName)
        
        MBProgressHUD.showAdded(to: view, animated: true)
        WebServices.shared.postObject(user) { (success, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if (success != nil) {
                self.dismiss(animated: true, completion: nil)
            } else if let error = error {
                self.present(Utils.createAlert(message: error), animated: true, completion: nil)
            } else {
                self.present(Utils.createAlert(message: Constants.JSON.unknownError), animated: true, completion: nil)
            }
            
            
        }
        
        
        
        
    }
}
    extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            picker.dismiss(animated: true, completion: nil)
            
            if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
                let maxSize: CGFloat = 100
                let scale = maxSize / image.size.width
                let newHeight = image.size.height * scale
                
                UIGraphicsBeginImageContext(CGSize(width: maxSize, height: newHeight))
                image.draw(in: CGRect(x: 0, y: 0, width: maxSize, height: newHeight))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                profilePicture.image = resizedImage
            }
        }
}
