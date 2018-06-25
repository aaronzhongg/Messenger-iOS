//
//  Contact.swift
//  Empower
//
//  Created by Aaron Zhong on 25/06/18.
//  Copyright © 2018 Aaron Zhong. All rights reserved.
//

import Foundation

enum Status: Int {
    case REQUEST_SENT = 0
    case REQUEST_RECEIVED = 1
    case CONNECTED = 2
    
    static func element(at index: Int) -> Status? {
        let elements = [Status.REQUEST_SENT, Status.REQUEST_RECEIVED, Status.CONNECTED]
        
        if index >= 0 && index < elements.count {
            return elements[index]
        } else {
            return nil
        }
    }
}

class Contact {
    var uid: String
    var favourite: Bool
    var status: Status
    var fullName: String
    
    init(uid: String, favourite: Bool, status: Status, fullName: String) {
        self.uid = uid
        self.favourite = favourite
        self.status = status
        self.fullName = fullName
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "uid": uid,
            "favourite": favourite,
            "status": status.rawValue,
            "fullName": fullName
        ]
    }
    
//    func addContact(uid: String) {
//
//    }
}
