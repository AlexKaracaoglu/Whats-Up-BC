//
//  RSVP.swift
//  WhatsUpBC
//
//  Created by Alex Karacaoglu on 4/10/19.
//  Copyright © 2019 Alex Karacaoglu. All rights reserved.
//

import Foundation
import Firebase

class RSVP {
    
    var name = ""
    var date = ""
    var documentID = ""
    var tag = ""
    var user = ""
    
    var dictionary: [String: Any] {
        return ["name": name, "date": date, "documentID": documentID, "tag": tag]
    }
    
    init(name: String, date: String, documentID: String, user: String, tag: String) {
        self.name = name
        self.date = date
        self.documentID = documentID
        self.user = user
        self.tag = tag
    }
    
    convenience init() {
        self.init(name: "", date: "", documentID: "", user: "", tag: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let date = dictionary["date"] as! String? ?? ""
        let documentID = dictionary["documentID"] as! String? ?? ""
        let user = dictionary["user"] as! String? ?? ""
        let tag = dictionary["tag"] as! String? ?? ""
        self.init(name: name, date: date, documentID: documentID, user: user, tag: tag)
    }
    
    func deleteData(completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
         let ref = db.collection("rsvps").document(self.user).collection("rsvps").document(self.documentID).delete() { error in
            if let error = error {
                print("ERROR")
                completed(false)
            }
            else {
                completed(true)
            }
        }
    }
    
    func saveData(completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let dataToSave = self.dictionary
            let ref = db.collection("rsvps").document(self.user).collection("rsvps").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("Error updating document \(error)")
                    completed(false)
                }
                else {
                    completed(true)
                }
            }
    }
    
}

