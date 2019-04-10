//
//  AddNewEventViewController.swift
//  WhatsUpBC
//
//  Created by Alex Karacaoglu on 4/6/19.
//  Copyright © 2019 Alex Karacaoglu. All rights reserved.
//

import UIKit
import Firebase

class AddNewEventViewController: UIViewController {
    
    
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    @IBOutlet weak var eventFlyerImageView: UIImageView!
    @IBOutlet weak var eventTagPickerView: UIPickerView!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    @IBOutlet weak var eventLocationTextField: UITextField!
    @IBOutlet weak var eventHostTextField: UITextField!
    @IBOutlet weak var eventNameTextField: UITextField!
    
    var tags = ["Speech", "Panel", "Workshop", "Volunteering", "Activity", "Other"]
    
    var eventTag = "Speech"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventDescriptionTextView.delegate = self
        
        eventTagPickerView.dataSource = self
        eventTagPickerView.delegate = self
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        print("Event Name: \(eventNameTextField.text!)")
        print("Event Host: \(eventHostTextField.text!)")
        print("Event Contact: \(Auth.auth().currentUser?.email ?? "Unknown")")
        print("Event Location: \(eventLocationTextField.text!)")
        let formatter = DateFormatter()
        formatter.dateFormat = "EE, MMM d 'at' hh:mm aaa"
        print("Event Date: \(formatter.string(from: eventDatePicker.date))")
        print("Event Description: \(eventDescriptionTextView.text!)")
        print("Event Tag: \(eventTag)")
        
        var event = Event(name: eventNameTextField.text!,
                          host: eventHostTextField.text!,
                          contact: Auth.auth().currentUser?.email ?? "Unknown",
                          location: eventLocationTextField.text!,
                          description: eventDescriptionTextView.text!,
                          tag: eventTag,
                          rsvp: 0,
                          date: formatter.string(from: eventDatePicker.date),
                          documentID: ""
        
        )
        event.saveData { success in
            if success {
                self.leaveViewController()
            }
            else {
                print("COULDNT LEAVE VIEW CONTROLLER")
            }
        }
        
        
    }
    
    
}

extension AddNewEventViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor != UIColor.black {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
        }
    }
}

extension AddNewEventViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
