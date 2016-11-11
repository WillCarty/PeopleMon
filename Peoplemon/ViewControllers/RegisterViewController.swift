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
        
        MBProgressHUD.showAdded(to: view, animated: true)
        
        let user = UserModel(email: email, password: password , fullName: fullName)
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
}
