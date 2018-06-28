//
//  ContactsTableViewController.swift
//  Empower
//
//  Created by Aaron Zhong on 21/06/18.
//  Copyright © 2018 Aaron Zhong. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SVProgressHUD
import FirebaseAuth

protocol FavouritedContactsDelegate {
    func updateFavouriteContacts(_ favourites: [Contact])
}

class ContactsTableViewController: UITableViewController {

    let categories = ["Favourites", "Contacts"]
    var contacts: [Contact] = [Contact]()
    var favourites: [Contact] = [Contact]()
    
    var favouritesDelegate: FavouritedContactsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(UINib(nibName: "FavouriteContactsTableRowCell", bundle: nil), forCellReuseIdentifier: "FavouriteContactsRowCell")
        
        tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        
        self.contacts = (CurrentUser.currentUser?.contacts)!
        self.favourites = (CurrentUser.currentUser?.favourites)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return favourites.count == 0 ? (categories.count - 1) : categories.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count == 0 ? contacts.count : (section == 0 ? 1 : contacts.count)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if favourites.count != 0 && indexPath.section == 0 {
            return loadFavouritesCell(tableView, cellForRowAt: indexPath)
        } else {
            return loadContactCell(tableView, cellForRowAt: indexPath)
        }
    }
    
    func loadContactCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        
        cell.contactNameLabel.text = contacts[indexPath.row].fullName
        return cell
    }
    
    func loadFavouritesCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteContactsRowCell") as! FavouriteContactsTableRowCell
        favouritesDelegate = cell
        
        favouritesDelegate?.updateFavouriteContacts(favourites)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return favourites.count == 0 ? 50 : (indexPath.section == 0 ? 100 : 50)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return favourites.count == 0 ? categories[1] : categories[section]
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Button Actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Contact", message: "", preferredStyle: .alert)
        var textField: UITextField?
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Contact email"
            textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Send Request", style: .default, handler: { (action) in
                // Send contact request
            
                // Check email exists
                Database.database().reference().child("users").queryOrdered(byChild: "email").queryEqual(toValue: textField?.text).observe(.value) { (snapshot) in
                    if snapshot.childrenCount == 0 {
                        // Email doesn't exist
                        SVProgressHUD.showError(withStatus: "Email not found")
                    } else {
                        for snap in snapshot.children {
                            guard let dict = (snap as! DataSnapshot).value as? [String: String] else {fatalError()}
                            
                            CurrentUser.addContact(uid: dict["uid"]!, name: "\(dict["firstName"]!) \(dict["lastName"]!)")
                        }
                        
                        SVProgressHUD.showSuccess(withStatus: "Request sent")
                    }
                }
        }))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func requestsButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToRequests", sender: self)
    }

    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true)
        } catch {
            print(error)
        }
    }

}
