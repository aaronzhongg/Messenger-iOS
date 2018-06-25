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

protocol FavouritedContactsDelegate {
    func updateFavouriteContacts(_ favourites: [Contact])
}

class ContactsTableViewController: UITableViewController {

    let categories = ["Favourites", "Contacts"]
    var contacts: [Contact] = [Contact]()
    
    var favouritesDelegate: FavouritedContactsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(UINib(nibName: "FavouriteContactsTableRowCell", bundle: nil), forCellReuseIdentifier: "FavouriteContactsRowCell")
        
        tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        
        loadContacts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return categories.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0 {
            return 1
        } else {
            return contacts.count
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteContactsRowCell") as! FavouriteContactsTableRowCell
            favouritesDelegate = cell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
            
            cell.contactNameLabel.text = contacts[indexPath.row].fullName
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        
        return 50
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
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
    
    func loadContacts() {
        DatabaseReference.contacts(uid: (CurrentUser.currentUser?.uid)!).reference().observeSingleEvent(of: .value) { (snapshot) in
            var favourites: [Contact] = [Contact]()
            
            for snap in snapshot.children {
                guard let contactsDict = (snap as! DataSnapshot).value as? [String: Any] else {fatalError()}
                
                let contact = Contact(uid: contactsDict["uid"] as! String, favourite: contactsDict["favourite"] as! Bool, status: Status.element(at: contactsDict["status"] as! Int)!, fullName: contactsDict["fullName"] as! String)
                
                if contact.favourite == true {
                    favourites.append(contact)
                } else {
                    self.contacts.append(contact)
                }
            }
            self.favouritesDelegate?.updateFavouriteContacts(favourites)
            self.tableView.reloadData()
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
