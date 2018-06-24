//
//  CurrentUser.swift
//  Empower
//
//  Created by Aaron Zhong on 22/06/18.
//  Copyright © 2018 Aaron Zhong. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CurrentUser {
    
    static var currentUser: User?
    
    static func loadUser(uid: String, completion: @escaping () -> Void){
        
//        Database.database().reference().child("users").queryOrdered(byChild: "username").queryEqual(toValue: "aaronzhong").observe(.value) { (snapshot) in
//            for snap in snapshot.children {
//                print("KEY: \((snap as! DataSnapshot).key)")
//                print("USERNAME: \((snap as! DataSnapshot).value)")
//
//                guard let dict = (snap as! DataSnapshot).value as? [String: String] else {fatalError()}
//            }
//        }
        
        let user = Database.database().reference().child("users/\(uid)")
        user.observeSingleEvent(of: .value) { (snapshot) in
            guard let userDict = snapshot.value as? [String: Any] else {fatalError()}

            currentUser = User(uid: snapshot.key, username: userDict["username"] as! String, firstName: userDict["firstName"] as! String, lastName: userDict["lastName"] as! String, profileImage: nil, email: userDict["email"] as! String)
            
             completion()
        }
    }
}
