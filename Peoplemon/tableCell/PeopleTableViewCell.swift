//
//  PeopleTableViewCell.swift
//  Peoplemon
//
//  Created by Will Carty on 11/10/16.
//  Copyright © 2016 Will Carty. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {
   @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateCaughtLabel: UILabel!
    @IBOutlet weak var caughtImage: UIImageView!
    

        var people: AccountModel!
        
        func convertBase64ToImage(base64String: String?) -> UIImage? {
            
            if let base64String = base64String, let photoData = NSData(base64Encoded: base64String, options: .ignoreUnknownCharacters) {
                return UIImage(data: photoData as Data)
            }
            
            return #imageLiteral(resourceName: "defaultpng")
        }
        
        func setupCell(people: AccountModel) {
            self.people = people
            
            nameLabel.text = people.userName
            
            caughtImage.image = convertBase64ToImage(base64String: people.avatarBase64)
            
        }
        
}


