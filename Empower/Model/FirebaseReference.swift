//
//  FirebaseReference.swift
//  Empower
//
//  Created by Aaron Zhong on 22/06/18.
//  Copyright © 2018 Aaron Zhong. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

enum DatabaseReference {
    case root
    case users(uid: String)
    case contacts(uid: String)
    
    func reference() -> FirebaseDatabase.DatabaseReference {
        switch self {
        case .root:
            return rootReference
        default:
            return rootReference.child(path)
        }
    }
    
    private var rootReference: FirebaseDatabase.DatabaseReference {
        return Database.database().reference()
    }
    
    private var path: String {
        switch self {
        case .root:
            return ""
        case .users(let uid):
            return "users/\(uid)"
        case .contacts(let uid):
            return "contacts/\(uid)"
        }
    }
}

//enum StorageReference {
//    case root
//    case profileImages
//
//    func reference() -> FirebaseStorage.StorageReference {
//        switch self {
//        case .root:
//            return rootReference
//        default:
//            return rootReference.child(path)
//        }
//    }
//
//    private var rootReference: FirebaseStorage.StorageReference {
//        return Storage.storage().reference()
//    }
//
//    private var path: String {
//        switch self {
//        case .root:
//            return ""
//        case .profileImages:
//            return "profileImages"
//        }
//    }
//}
