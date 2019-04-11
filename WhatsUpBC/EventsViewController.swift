//
//  EventsViewController.swift
//  WhatsUpBC
//
//  Created by Alex Karacaoglu on 4/6/19.
//  Copyright © 2019 Alex Karacaoglu. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var images = ["star-empty", "star-filled"]
    
    var events = Events()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        setTitle()
    }
    
    func setTitle() {
        switch events.tag {
        case "Speech":
            self.title = "Speeches"
        case "Panel":
            self.title = "Panels"
        case "Workshop":
            self.title = "Workshops"
        case "Volunteering":
            self.title = "Volunteering"
        case "Activity":
            self.title = "Activities"
        case "Other":
            self.title = "Other Events"
        default:
            self.title = "How did you get here?"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        events.loadEventsFromTag {
            if self.events.eventArray.count > 0 {
                self.events.eventArray = self.events.eventArray.filter({$0.date > Date()})
                self.events.eventArray.sort(by: {$0.date < $1.date})
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEventDetail" {
            let destination = segue.destination as! EventDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.event = events.eventArray[selectedIndexPath.row]
            destination.tag = events.tag
        }
    }
    
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventsViewTableViewCell
        cell.eventNameLabel.text = events.eventArray[indexPath.row].name
        cell.eventDateLabel.text = events.eventArray[indexPath.row].dateString
//        cell.rsvpImage.image = UIImage(named: images[rsvp])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
