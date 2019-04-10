//
//  EventTypesViewController.swift
//  
//
//  Created by Alex Karacaoglu on 4/6/19.
//

import UIKit

class EventTypesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tags = ["Speech", "Panel", "Workshop", "Volunteer", "Activity", "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEventType" {
            let destination = segue.destination as! EventsViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.events.tag = tags[selectedIndexPath.row]
        }
    }

}

extension EventTypesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventTypeTableViewCell
        cell.eventTypeLabel.text = tags[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
