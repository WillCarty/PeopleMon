//
//  RegisterViewController.swift
//  Peoplemon
//
//  Created by Will Carty on 11/7/16.
//  Copyright © 2016 Will Carty. All rights reserved.
//

import UIKit
import MBProgressHUD

class RegisterViewController: UIViewController {
    
    //IBOutlet
    @IBOutlet weak var enterEmailText: UITextField!
    @IBOutlet weak var enterFullNameText: UITextField!
    @IBOutlet weak var enterPasswordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var profilePicturePick: UIImageView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //IBActions
    @IBAction func registerButton(_ sender: UIButton) {
        guard let email = enterEmailText.text , email != "" else {
            let alert = Utils.createAlert("Login Error", message: "Please provide a username")
            present(alert, animated: true, completion: nil)
            return
        }
        guard let fullName = enterFullNameText.text , fullName != "" else {
            let alert = Utils.createAlert("Login Error", message: "Please provide full name")
            present(alert, animated: true, completion: nil)
            return
        }

        guard let password = enterPasswordText.text , password != "" else {
            present(Utils.createAlert("Login Error", message: "Please provide a password"), animated: true, completion: nil)
            return
        }
        
        guard let confirm = confirmPasswordText.text , password == confirm else {
            present(Utils.createAlert("Login Error", message: "Passwords do not match"), animated: true, completion: nil)
            return
        }
        
        func convertImageToBase64(image: UIImage?) -> String {
            
            if let image = profilePicturePick.image, let imageData = UIImagePNGRepresentation(image){
                let base64String = imageData.base64EncodedString()
                
                return base64String
            }
            return ""
        }
        
        MBProgressHUD.showAdded(to: view, animated: true)
        
        let user = UserModel(email: email, password: password, fullName: fullName, avatarBase64: convertImageToBase64(image: profilePicturePick.image))
        PeopleStore.shared.register(user) { (success, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if success {
                self.dismiss(animated: true, completion: nil)
            } else if let error = error {
                self.present(Utils.createAlert(message: error), animated: true, completion: nil)
            } else {
                self.present(Utils.createAlert(message: Constants.JSON.unknownError), animated: true, completion: nil)
            }
        }

    }
    fileprivate func showPicker(_ type: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func addProfilePictureButton(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Picture", message: "Choose a picture type", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.showPicker(.camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.showPicker(.photoLibrary)
        }))
        present(alert, animated: true, completion: nil)
    }
    
}
extension RegisterViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
            profilePicturePick.image = resizedImage
        }
    }
}
