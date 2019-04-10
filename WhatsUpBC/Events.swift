//
//  Events.swift
//  WhatsUpBC
//
//  Created by Alex Karacaoglu on 4/10/19.
//  Copyright © 2019 Alex Karacaoglu. All rights reserved.
//

import Foundation
import Firebase

class Events {
    
    var eventArray: [Event] = []
    var db: Firestore!
    var tag = ""
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("events").document(self.tag).collection("events").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("ERROR ADDING SNAPSHOT LISTENER")
                return completed()
            }
            self.eventArray = []
            for document in querySnapshot!.documents {
                let event = Event(dictionary: document.data())
                event.documentID = document.documentID
                event.tag = self.tag
                self.eventArray.append(event)
            }
            completed()
        }
    }
    
    
}
