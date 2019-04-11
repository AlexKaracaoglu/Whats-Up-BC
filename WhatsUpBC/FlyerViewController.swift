//
//  FlyerViewController.swift
//  WhatsUpBC
//
//  Created by Alex Karacaoglu on 4/11/19.
//  Copyright © 2019 Alex Karacaoglu. All rights reserved.
//

import UIKit

class FlyerViewController: UIViewController {
    
    
    @IBOutlet weak var flyerImage: UIImageView!
    
    var flyer: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flyerImage.image = flyer
        
        self.title = "Event Flyer"
    }
    

}
