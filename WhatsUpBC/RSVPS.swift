//
//  RSVPS.swift
//  WhatsUpBC
//
//  Created by Alex Karacaoglu on 4/10/19.
//  Copyright © 2019 Alex Karacaoglu. All rights reserved.
//

import Foundation
import Firebase

class RSVPS {
    
    var rsvpArray: [RSVP] = []
    var user = ""
    
    func loadData(completed: @escaping () -> ()) {
        let db = Firestore.firestore()
        db.collection("rsvps").document(self.user).collection("rsvps").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("ERROR ADDING SNAPSHOT LISTENER")
                return completed()
            }
            self.rsvpArray = []
            for document in querySnapshot!.documents {
                let rsvp = RSVP(dictionary: document.data())
                self.rsvpArray.append(rsvp)
            }
            completed()
        }
    }

    
}
