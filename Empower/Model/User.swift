//
//  User.swift
//  Empower
//
//  Created by Aaron Zhong on 22/06/18.
//  Copyright © 2018 Aaron Zhong. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class User {
    
    let uid: String
    var username: String
    var firstName: String
    var lastName: String
    var profileImage: UIImage?
    var email: String
    var contacts: [Contact]
    var favourites: [Contact]
    
    init(uid: String, username: String, firstName: String, lastName: String, profileImage: UIImage?, email: String) {
        self.uid = uid
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.profileImage = profileImage
        self.email = email
        self.contacts = [Contact]()
        self.favourites = [Contact]()
    }
    
    func save() {
        Database.database().reference().child("users").child(uid).setValue(toDictionary())
        
//        if let profileImage = self.profileImage {
//            
//        }
    }
    
    func addContact(contact: Contact) {
        DatabaseReference.contacts(uid: uid).reference().child(contact.uid).setValue(contact.toDictionary())
        DatabaseReference.contacts(uid: contact.uid).reference().child(uid).setValue(Contact(uid: uid, favourite: false, status: Status.REQUEST_RECEIVED, fullName: "\(firstName) \(lastName)").toDictionary())
    }
    
    func loadContacts(completion: @escaping () -> Void) {
        DatabaseReference.contacts(uid: (CurrentUser.currentUser?.uid)!).reference().queryOrdered(byChild: "status").queryEqual(toValue: Status.CONNECTED.rawValue).observeSingleEvent(of: .value) { (snapshot) in
            var contacts = [Contact]()
            var favourites = [Contact]()
            for snap in snapshot.children {
                guard let contactsDict = (snap as! DataSnapshot).value as? [String: Any] else {fatalError()}
                
                let contact = Contact(uid: contactsDict["uid"] as! String, favourite: contactsDict["favourite"] as! Bool, status: Status.element(at: contactsDict["status"] as! Int)!, fullName: contactsDict["fullName"] as! String)
                
                if contact.favourite == true {
                    favourites.append(contact)
                } else {
                    contacts.append(contact)
                }
            }
            
            self.contacts = contacts
            self.favourites = favourites
            
            completion()
        }
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "uid": uid,
            "username": username,
            "firstName": firstName,
            "lastName": lastName,
            "email": email
        ]
    }
    
}
