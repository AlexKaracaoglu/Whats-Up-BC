//
//  EventDetailTableViewController.swift
//  WhatsUpBC
//
//  Created by Alex Karacaoglu on 4/24/19.
//  Copyright © 2019 Alex Karacaoglu. All rights reserved.
//

import UIKit
import Firebase

class EventDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var eventFlyerImageView: UIImageView!
    @IBOutlet weak var rsvpButton: UIBarButtonItem!
    @IBOutlet var showFlyerTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var hostLabel: UILabel!
    @IBOutlet weak var rsvpCountLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
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
            self.descriptionTextView.text = self.event.description
            self.hostLabel.text = self.event.host
            self.locationLabel.text = self.event.location
            self.rsvpCountLabel.text = String(self.event.rsvp)
            self.dateLabel.text = self.event.dateString
            
            if self.event.flyerExist {
                self.event.loadEventPhoto {
                    self.eventFlyerImageView.image = self.event.flyerImage
                }
            }
            else {
                self.eventFlyerImageView.isUserInteractionEnabled = false
                self.eventFlyerImageView.isHidden = true
                self.showFlyerTapGesture.isEnabled = false
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
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = UIColor( red: CGFloat(61/255.0), green: CGFloat(6/255.0), blue: CGFloat(3/255.0), alpha: CGFloat(1.0) )
            header.contentView.backgroundColor = UIColor( red: CGFloat(174/255.0), green: CGFloat(158/255.0), blue: CGFloat(114/255.0), alpha: CGFloat(1.0) )
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
