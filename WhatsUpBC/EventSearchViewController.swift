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
    @IBOutlet weak var orderByBarButton: UIBarButtonItem!
    @IBOutlet weak var eventTypePickerView: UIPickerView!
    
    let tags = Tags().tagArray
    
    var eventTag = "Speeches"
    
    var rsvpList: [String] = []
    
    var rsvps = RSVPS()
    
    var events = Events()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("😀 viewDidLoad")

        tableView.delegate = self
        tableView.dataSource = self
        
        events.tag = eventTag
        setTitle()
        
        self.rsvps.user = (Auth.auth().currentUser?.email!)!
        self.rsvps.loadData {
            self.rsvpList = []
            self.makeRSVPList()
            self.events.loadEventsFromTag {
                if self.events.eventArray.count > 0 {
                    self.events.eventArray = self.events.eventArray.filter({$0.date > Date()})
                    self.sortEvents()
                }
            }
        }
        
        eventTypePickerView.dataSource = self
        eventTypePickerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sortEvents()
    }
    
    func sortEvents() {
        if orderByBarButton.title == "Order By Date" {
            self.events.eventArray.sort(by: {$0.rsvp > $1.rsvp})
        }
        else {
            self.events.eventArray.sort(by: {$0.date < $1.date})
        }
        self.tableView.reloadData()
    }
    
    func makeRSVPList() {
        for rsvp in rsvps.rsvpArray {
            rsvpList.append(rsvp.documentID)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEventDetail" {
            let destination = segue.destination as! EventDetailTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.event = events.eventArray[selectedIndexPath.row]
            destination.tag = events.tag
            destination.rsvpList = self.rsvpList
            destination.rsvps.user = self.rsvps.user
        }
    }
    
    func setTitle() {
        self.title = events.tag
    }
    
    
    @IBAction func orderByBarButtonPressed(_ sender: UIBarButtonItem) {
        if orderByBarButton.title == "Order By RSVP" {
            orderByBarButton.title = "Order By Date"
            sortEvents()
        }
        else {
            orderByBarButton.title = "Order By RSVP"
            sortEvents()
        }
    }
    
    @IBAction func searchForEventButtonPressed(_ sender: UIButton) {
        events.tag = eventTag
        events.loadEventsFromTag {
            if self.events.eventArray.count > 0 {
                self.events.eventArray = self.events.eventArray.filter({$0.date > Date()})
            }
            self.setTitle()
            self.sortEvents()
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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EventSearchViewController.rsvp(_:)))
        
        cell.rsvpImage.isUserInteractionEnabled = true
        cell.rsvpImage.tag = indexPath.row
        cell.rsvpImage.addGestureRecognizer(tapGestureRecognizer)
        
        return cell
    }
    
    @objc func rsvp(_ sender:AnyObject){
        let rsvp = RSVP(name: events.eventArray[sender.view.tag].name, date: events.eventArray[sender.view.tag].dateString, documentID: events.eventArray[sender.view.tag].documentID, user: (Auth.auth().currentUser?.email)!, tag: events.eventArray[sender.view.tag].tag)
        if rsvpList.contains(events.eventArray[sender.view.tag].documentID) {
            rsvp.deleteData { success in
                self.deleteFromRSVPList(element: rsvp.documentID)
                self.events.eventArray[sender.view.tag].removeRSVP() {
                    self.sortEvents()
                    self.tableView.reloadData()
                }
            }
        }
        else {
            
            rsvp.saveData { success in
                self.events.eventArray[sender.view.tag].addRSVP() {
                    self.sortEvents()
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
