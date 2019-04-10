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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        rsvps.loadData {
            self.tableView.reloadData()
        }
    }

}

extension ShowRSVPSViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rsvps.rsvpArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventsViewTableViewCell
        cell.eventNameLabel.text = rsvps.rsvpArray[indexPath.row].name
        cell.eventDateLabel.text = rsvps.rsvpArray[indexPath.row].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
