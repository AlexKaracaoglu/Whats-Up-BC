//
//  EventDetailViewController.swift
//  WhatsUpBC
//
//  Created by Alex Karacaoglu on 4/6/19.
//  Copyright © 2019 Alex Karacaoglu. All rights reserved.
//

import UIKit
import Firebase

class EventDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var documentIDLabel: UILabel!
    
    var event = Event()
    var tag = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = event.name
        documentIDLabel.text = tag
    }

    
    @IBAction func rsvp(_ sender: UIButton) {
        let rsvp = RSVP(name: event.name, date: event.date, documentID: event.documentID, user: (Auth.auth().currentUser?.email)!, tag: event.tag)
        rsvp.saveData { success in
            print("ddid it work?")
        }
    }
    
}
