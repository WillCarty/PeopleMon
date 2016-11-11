//
//  PeopleCaughtTableViewController.swift
//  Peoplemon
//
//  Created by Will Carty on 11/10/16.
//  Copyright © 2016 Will Carty. All rights reserved.
//

import UIKit

class CaughtTableViewController: UITableViewController {
    
    var caught: [AccountModel] = []
    
    //    private let reuseIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let people = AccountModel()
        people.requestType = .caught
        WebServices.shared.getObjects(people) { (objects, error) in
            if let objects = objects {
                self.caught = objects
                print(self.caught)
                self.tableView.reloadData()
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("This is the array count size \(caught.count)")
        
        return caught.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CaughtTableViewCell", for: indexPath) as? PeopleTableViewCell {
            
            let people = caught[indexPath.row]
            
            cell.setupCell(people: people)
            
            return cell
        } else {
            
            print("ERROR WITH TABLE VIEW CELL")
            
            return UITableViewCell()
        }
   }
}
