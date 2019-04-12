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

    @IBOutlet weak var eventFlyerImageView: UIImageView!
    @IBOutlet weak var rsvpButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var documentIDLabel: UILabel!
    
    var event = Event()
    var tag = ""
    var rsvps = RSVPS()
    var rsvpList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        event.loadEventFromTagAndID {
            self.rsvps.user = (Auth.auth().currentUser?.email!)!
            self.rsvps.loadData {
                self.makeRSVPList()
                // check if this in rsvp list
                if self.rsvpList.contains(self.event.documentID) {
                    self.rsvpButton.setTitle("Un-RSVP", for: .normal)
                }
            }
            
            self.event.loadEventPhoto {
                self.eventFlyerImageView.image = self.event.flyerImage
            }
            
            self.eventFlyerImageView.isUserInteractionEnabled = self.event.flyerExist
            
            self.nameLabel.text = self.event.name
            self.documentIDLabel.text = self.tag
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFlyer" {
            let destination = segue.destination as! FlyerViewController
            destination.flyer = eventFlyerImageView.image!
        }
    }
    
    func deleteFromRSVPList(element: String) {
        rsvpList = rsvpList.filter() { $0 != element }
    }
    
    func makeRSVPList() {
        for rsvp in rsvps.rsvpArray {
            rsvpList.append(rsvp.documentID)
        }
    }

    @IBAction func rsvp(_ sender: UIButton) {
        let rsvp = RSVP(name: event.name, date: event.dateString, documentID: event.documentID, user: (Auth.auth().currentUser?.email)!, tag: event.tag)
        if rsvpButton.titleLabel?.text == "RSVP" {
            rsvp.saveData { success in
                print("ddid it work?")
                self.rsvpButton.setTitle("Un-RSVP", for: .normal)
                self.event.addRSVP() {
                    
                }
            }
        }
        else {
            rsvp.deleteData { success in
                self.deleteFromRSVPList(element: rsvp.documentID)
                self.rsvpButton.setTitle("RSVP", for: .normal)
                self.event.removeRSVP() {
                    
                }
            }
        }
    }
    
}
