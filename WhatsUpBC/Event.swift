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
    var dateString: String
    var documentID: String
    var flyerImage: UIImage
    var flyerExist: Bool
    
    var date: Date {
        return dateString.toDate()
    }
    
    
    var dictionary: [String: Any] {
        return ["name": name, "host": host, "contact": contact, "location": location, "description": description, "rsvp": rsvp, "dateString": dateString, "tag": tag, "flyerExist": flyerExist]
    }
    
    init(name: String, host: String, contact: String, location: String, description: String, tag: String, rsvp: Int, dateString: String, documentID: String, flyerImage: UIImage, flyerExist: Bool) {
        self.name = name
        self.host = host
        self.contact = contact
        self.location = location
        self.description = description
        self.tag = tag
        self.rsvp = rsvp
        self.dateString = dateString
        self.documentID = documentID
        self.flyerImage = flyerImage
        self.flyerExist = flyerExist
    }
    
    convenience init() {
        self.init(name: "", host: "", contact: "", location: "", description: "", tag: "", rsvp: 0, dateString: "", documentID: "", flyerImage: UIImage(), flyerExist: false)
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let host = dictionary["host"] as! String? ?? ""
        let contact = dictionary["contact"] as! String? ?? ""
        let location = dictionary["location"] as! String? ?? ""
        let description = dictionary["description"] as! String? ?? ""
        let rsvp = dictionary["rsvp"] as! Int? ?? 0
        let dateString = dictionary["dateString"] as! String? ?? ""
        let tag = dictionary["tag"] as! String? ?? ""
        let flyerExist = dictionary["flyerExist"] as! Bool? ?? false
        self.init(name: name, host: host, contact: contact, location: location, description: description, tag: tag, rsvp: rsvp, dateString: dateString, documentID: "", flyerImage: UIImage(), flyerExist: flyerExist)
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
    
    func saveImage(completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        guard let photoData = self.flyerImage.jpegData(compressionQuality: 0.5) else {
            print("ERROR")
            return completed(false)
        }
        let storageRef = storage.reference().child(self.documentID)
        let uploadTask = storageRef.putData(photoData)
        uploadTask.observe(.success) { (snapshot) in
            completed(true)
            print("did the photo go to storage?")
        }
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                print("error")
            }
            return completed(false)
        }
    }
    
    func loadEventFromTagAndID(completed: @escaping () -> ()) {
        let db = Firestore.firestore()
        let ref = db.collection("events").document(self.tag).collection("events").document(self.documentID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let event = Event(dictionary: data!)
                self.contact = event.contact
                self.dateString = event.dateString
                self.description = event.description
                self.host = event.host
                self.location = event.location
                self.flyerExist = event.flyerExist
                self.name = event.name
                self.rsvp = event.rsvp
                completed()
            } else {
                print("ERROR: DOCUMENT DOES NOT EXIST")
                completed()
            }
        }
    }
    
    func loadEventPhoto(completed: @escaping () -> ()) {
        let storage = Storage.storage()
        let photoRef = storage.reference().child(self.documentID)
        photoRef.getData(maxSize: 25 * 1025 * 1025) {data, error in
        if let error = error {
            print("ERROR getting the photo")
        }
        else {
            let image = UIImage(data: data!)
            self.flyerImage = image!
            completed()
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
            self.documentID = UUID().uuidString
            ref =  db.collection("events").document(self.tag).collection("events").document(self.documentID)
            ref!.setData(dataToSave) { (error) in
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
