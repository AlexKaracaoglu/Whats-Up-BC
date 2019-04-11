//
//  Event.swift
//  WhatsUpBC
//
//  Created by Alex Karacaoglu on 4/10/19.
//  Copyright © 2019 Alex Karacaoglu. All rights reserved.
//

import Foundation
import Firebase

class Event {
    
    var name: String
    var host: String
    var contact: String
    var location: String
    var description: String
    var tag: String
    var rsvp: Int
    var date: String //FOR NOW
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["name": name, "host": host, "contact": contact, "location": location, "description": description, "rsvp": rsvp, "date": date, "tag": tag]
    }
    
    init(name: String, host: String, contact: String, location: String, description: String, tag: String, rsvp: Int, date: String, documentID: String) {
        self.name = name
        self.host = host
        self.contact = contact
        self.location = location
        self.description = description
        self.tag = tag
        self.rsvp = rsvp
        self.date = date
        self.documentID = documentID
    }
    
    convenience init() {
        self.init(name: "", host: "", contact: "", location: "", description: "", tag: "", rsvp: 0, date: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let host = dictionary["host"] as! String? ?? ""
        let contact = dictionary["contact"] as! String? ?? ""
        let location = dictionary["location"] as! String? ?? ""
        let description = dictionary["description"] as! String? ?? ""
        let rsvp = dictionary["rsvp"] as! Int? ?? 0
        let date = dictionary["date"] as! String? ?? ""
        let tag = dictionary["tag"] as! String? ?? ""
        self.init(name: name, host: host, contact: contact, location: location, description: description, tag: tag, rsvp: rsvp, date: date, documentID: "")
    }
    
    func addRSVP(completed: @escaping () -> ()) {
        let db = Firestore.firestore()
        let ref = db.collection("events").document(self.tag).collection("events").document(self.documentID)
        ref.getDocument { (querySnapshot, error) in
            guard error == nil else {
                print("ERROR")
                return completed()
            }
            self.rsvp += 1
            let dataToSave = self.dictionary
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("ERROR")
                    completed()
                }
                else {
                    completed()
                }
            }
        }
    }
    
    func removeRSVP(completed: @escaping () -> ()) {
        let db = Firestore.firestore()
        let ref = db.collection("events").document(self.tag).collection("events").document(self.documentID)
        ref.getDocument { (querySnapshot, error) in
            guard error == nil else {
                print("ERROR")
                return completed()
            }
            self.rsvp -= 1
            let dataToSave = self.dictionary
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("ERROR")
                    completed()
                }
                else {
                    completed()
                }
            }
        }
    }
    
    func saveData(completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let dataToSave = self.dictionary
        if self.documentID != "" {
            let ref = db.collection("events").document(self.tag).collection("events").document(self.documentID)
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
        else {
            var ref: DocumentReference? = nil
            ref =  db.collection("events").document(self.tag).collection("events").addDocument(data: dataToSave) { error in
                if let error = error {
                    print("Error creating document \(error)")
                    completed(false)
                }
                else {
                    completed(true)
                }
            }
        }
    }
    
}