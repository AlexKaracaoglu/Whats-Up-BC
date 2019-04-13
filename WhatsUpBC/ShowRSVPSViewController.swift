//
//  ShowRSVPSViewController.swift
//  WhatsUpBC
//
//  Created by Alex Karacaoglu on 4/10/19.
//  Copyright © 2019 Alex Karacaoglu. All rights reserved.
//

import UIKit

class ShowRSVPSViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var rsvps = RSVPS()
    var rsvpList: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        rsvps.loadData {
            self.rsvps.rsvpArray = self.rsvps.rsvpArray.filter({$0.date.toDate() > Date()})
            self.rsvps.rsvpArray.sort(by: {$0.date.toDate() < $1.date.toDate()})
            self.tableView.reloadData()
            self.makeRSVPList()
        }
        self.title = "Your Upcoming Events"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEventDetail" {
            let destination = segue.destination as! EventDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            
            var event = Event()
            event.tag = rsvps.rsvpArray[selectedIndexPath.row].tag
            event.documentID = rsvps.rsvpArray[selectedIndexPath.row].documentID
            
            destination.rsvpList = self.rsvpList
            destination.event = event
            destination.tag = rsvps.rsvpArray[selectedIndexPath.row].tag
            destination.rsvps.user = self.rsvps.user
        }
    }
    
    func makeRSVPList() {
        for rsvp in rsvps.rsvpArray {
            rsvpList.append(rsvp.documentID)
        }
    }

}

extension ShowRSVPSViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rsvps.rsvpArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShowRSVPSTableViewCell
        cell.eventNameLabel.text = rsvps.rsvpArray[indexPath.row].name
        cell.eventDateLabel.text = rsvps.rsvpArray[indexPath.row].date
        let rsvpImage = rsvpList.contains(rsvps.rsvpArray[indexPath.row].documentID) ? "star-filled" : "star-empty"
        cell.rsvpImage.image = UIImage(named: rsvpImage)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EventSearchViewController.rsvp(_:)))
        
        cell.rsvpImage.isUserInteractionEnabled = true
        cell.rsvpImage.tag = indexPath.row
        cell.rsvpImage.addGestureRecognizer(tapGestureRecognizer)
        
        return cell
    }
    
    @objc func rsvp(_ sender:AnyObject){
        print("ALEX")
        var event = Event()
        let rsvp = RSVP(name: rsvps.rsvpArray[sender.view.tag].name, date: rsvps.rsvpArray[sender.view.tag].date, documentID: rsvps.rsvpArray[sender.view.tag].documentID, user: self.rsvps.user, tag: rsvps.rsvpArray[sender.view.tag].tag)
        event.documentID = rsvp.documentID
        event.tag = rsvp.tag
        rsvp.deleteData { success in
            event.loadEventFromTagAndID {
                self.deleteFromRSVPList(element: rsvp.documentID)
                event.removeRSVP() {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func deleteFromRSVPList(element: String) {
        rsvpList = rsvpList.filter() { $0 != element }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
