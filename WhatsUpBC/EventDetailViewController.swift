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
    
    @IBOutlet weak var rsvpButton: UIBarButtonItem!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var hostLabel: UILabel!
    @IBOutlet weak var rsvpCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var event = Event()
    var tag = ""
    var rsvps = RSVPS()
    var rsvpList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        event.loadEventFromTagAndID {
                if self.rsvpList.contains(self.event.documentID) {
                    self.rsvpButton.title = "UN-RSVP"
                }
        
            self.nameLabel.text = self.event.name
            self.descriptionLabel.text = self.event.description
            self.hostLabel.text = self.event.host
            self.locationLabel.text = self.event.location
            self.rsvpCountLabel.text = String(self.event.rsvp)
            self.dateLabel.text = self.event.dateString
            
            self.event.loadEventPhoto {
                self.eventFlyerImageView.isUserInteractionEnabled = self.event.flyerExist
                
                self.eventFlyerImageView.image = self.event.flyerImage
            }
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
    
    
    @IBAction func rsvp(_ sender: UIBarButtonItem) {
        let rsvp = RSVP(name: event.name, date: event.dateString, documentID: event.documentID, user: self.rsvps.user, tag: event.tag)
        if rsvpButton.title == "RSVP" {
            rsvp.saveData { success in
                self.rsvpButton.title = "UN-RSVP"
                self.event.addRSVP() {
                    self.rsvpCountLabel.text = String(self.event.rsvp)
                }
            }
        }
        else {
            rsvp.deleteData { success in
                self.deleteFromRSVPList(element: rsvp.documentID)
                self.rsvpButton.title = "RSVP"
                self.event.removeRSVP() {
                    self.rsvpCountLabel.text = String(self.event.rsvp)
                }
            }
        }
    }
    
}
