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
    var user = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = "Your Upcoming Events"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        rsvps.loadData {
            self.rsvps.rsvpArray = self.rsvps.rsvpArray.filter({$0.date.toDate() > Date()})
            self.rsvps.rsvpArray.sort(by: {$0.date < $1.date})
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEventDetail" {
            let destination = segue.destination as! EventDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            
            var event = Event()
            event.tag = rsvps.rsvpArray[selectedIndexPath.row].tag
            event.documentID = rsvps.rsvpArray[selectedIndexPath.row].documentID
            
            destination.event = event
            destination.tag = rsvps.rsvpArray[selectedIndexPath.row].tag
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
