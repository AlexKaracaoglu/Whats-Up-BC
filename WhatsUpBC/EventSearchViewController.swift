//
//  EventSearchViewController.swift
//  WhatsUpBC
//
//  Created by Alex Karacaoglu on 4/12/19.
//  Copyright © 2019 Alex Karacaoglu. All rights reserved.
//

import UIKit
import Firebase

class EventSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var eventTypePickerView: UIPickerView!
    
    let tags = ["Speech", "Panel", "Workshop", "Volunteering", "Activity", "Other"]
    
    var eventTag = "Speech"
    
    var rsvpList: [String] = []
    
    var rsvps = RSVPS()
    
    var events = Events()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        events.tag = eventTag
        setTitle()
        
        self.rsvps.user = (Auth.auth().currentUser?.email!)!
        self.rsvps.loadData {
            self.makeRSVPList()
            self.events.loadEventsFromTag {
                if self.events.eventArray.count > 0 {
                    self.events.eventArray = self.events.eventArray.filter({$0.date > Date()})
                    self.events.eventArray.sort(by: {$0.date < $1.date})
                    self.tableView.reloadData()
                }
            }
        }
        
        eventTypePickerView.dataSource = self
        eventTypePickerView.delegate = self
    }
    
    func makeRSVPList() {
        for rsvp in rsvps.rsvpArray {
            rsvpList.append(rsvp.documentID)
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
    
    @IBAction func unwindFromEventDetailVC(for segue: UIStoryboardSegue) {
        let source = segue.source as! EventDetailViewController
        self.rsvpList = source.rsvpList
    }
    
    @IBAction func searchForEventButtonPressed(_ sender: UIButton) {
        events.tag = eventTag
        events.loadEventsFromTag {
            if self.events.eventArray.count > 0 {
                self.events.eventArray = self.events.eventArray.filter({$0.date > Date()})
                self.events.eventArray.sort(by: {$0.date < $1.date})
            }
            self.setTitle()
            self.tableView.reloadData()
        }
    }
    

}

extension EventSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventSearchTableViewCell
        cell.eventNameLabel.text = events.eventArray[indexPath.row].name
        cell.eventDateLabel.text = events.eventArray[indexPath.row].dateString
        let rsvpImage = rsvpList.contains(events.eventArray[indexPath.row].documentID) ? "star-filled" : "star-empty"
        cell.rsvpImage.image = UIImage(named: rsvpImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


extension EventSearchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tags.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tags[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        eventTag = tags[row]
    }
    
}
