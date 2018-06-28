//
//  RequestsTableViewController.swift
//  Empower
//
//  Created by Aaron Zhong on 25/06/18.
//  Copyright © 2018 Aaron Zhong. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RequestsTableViewController: UITableViewController, ContactRequestResponseDelegate {
    
    var contactRequests: [Contact] = [Contact]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(UINib(nibName: "ContactRequestCell", bundle: nil), forCellReuseIdentifier: "ContactRequestCell")
        
        loadRequests()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contactRequests.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactRequestCell", for: indexPath) as! ContactRequestCell
        cell.nameLabel.text = contactRequests[indexPath.row].fullName
        cell.delegate = self
        
        // Configure the cell...

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Network
    
    func loadRequests() {
        DatabaseReference.contacts(uid: (CurrentUser.currentUser?.uid)!).reference().queryOrdered(byChild: "status").queryEqual(toValue: Status.REQUEST_RECEIVED.rawValue).observe(.value) { (snapshot) in
            for snap in snapshot.children {
                guard let dict = (snap as! DataSnapshot).value as? [String: Any] else {fatalError()}

                let contact = Contact(uid: dict["uid"]! as! String, favourite: false, status: Status.element(at: dict["status"]! as! Int)!, fullName: dict["fullName"]! as! String)

                self.contactRequests.append(contact)
            }

            self.tableView.reloadData()
        }
    }
    
    // MARK: - Contact Requests Response Delegate
    
    func declineRequest(_ sender: ContactRequestCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        
        DatabaseReference.contacts(uid: (CurrentUser.currentUser?.uid)!).reference().child(contactRequests[indexPath.row].uid).removeValue { (error, databaseReference) in
            self.contactRequests.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        
        DatabaseReference.contacts(uid: contactRequests[indexPath.row].uid).reference().child((CurrentUser.currentUser?.uid)!).removeValue { (error, databaseReference) in
            self.tableView.reloadData()
        }
    }
    
    func acceptRequest(_ sender: ContactRequestCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        
    
        DatabaseReference.contacts(uid: (CurrentUser.currentUser?.uid)!).reference().child(contactRequests[indexPath.row].uid).updateChildValues(["status": Status.CONNECTED.rawValue]) { (error, databaseReference) in
            self.contactRequests.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        
        DatabaseReference.contacts(uid: contactRequests[indexPath.row].uid).reference().child((CurrentUser.currentUser?.uid)!).updateChildValues(["status": Status.CONNECTED.rawValue])
        
    }

}
