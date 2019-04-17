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
    
    var imagepicker = UIImagePickerController()
    
    var flyerExist = false
    
    var tags = ["Speech", "Panel", "Workshop", "Show", "Volunteering", "Activity", "Other"]
    
    var eventTag = "Speech"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventDatePicker.backgroundColor = UIColor( red: CGFloat(174/255.0), green: CGFloat(158/255.0), blue: CGFloat(114/255.0), alpha: CGFloat(1.0) )
        
        eventDescriptionTextView.delegate = self
        
        eventNameTextField.delegate = self
        eventHostTextField.delegate = self
        eventLocationTextField.delegate = self
        
        eventTagPickerView.dataSource = self
        eventTagPickerView.delegate = self
        
        imagepicker.delegate = self
        
        self.title = "Add New Event"
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func missingDataAlert() {
        let alertMessage = UIAlertController(title: "Missing Data", message: "Please be sure to provide an event name, host, location and description.", preferredStyle: .alert)
        alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertMessage, animated: true, completion: nil)
    }
    
    func updateMissingDataUI() {
        if eventDescriptionTextView.text == "" {
            eventDescriptionTextView.backgroundColor = UIColor.red
        }
        if eventHostTextField.text == "" {
            eventHostTextField.backgroundColor = UIColor.red
        }
        if eventNameTextField.text == "" {
            eventNameTextField.backgroundColor = UIColor.red
        }
        if eventLocationTextField.text == "" {
            eventLocationTextField.backgroundColor = UIColor.red
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
        
        if eventDescriptionTextView.text == "" || eventHostTextField.text == "" || eventNameTextField.text == "" {
            updateMissingDataUI()
            missingDataAlert()
        }
        
        else {
            let event = Event(name: eventNameTextField.text!,
                              host: eventHostTextField.text!,
                              contact: Auth.auth().currentUser?.email ?? "Unknown",
                              location: eventLocationTextField.text!,
                              description: eventDescriptionTextView.text!,
                              tag: eventTag,
                              rsvp: 0,
                              dateString: eventDatePicker.date.toString(),
                              documentID: "",
                              flyerImage: eventFlyerImageView.image ?? UIImage(),
                              flyerExist: flyerExist)
            
            event.saveData { success in
                if success {
                    if event.flyerExist {
                        event.saveImage { success in
                        }
                    }
                    self.leaveViewController()
                }
                else {
                    print("COULDNT LEAVE VIEW CONTROLLER")
                }
            }
        }
        
        
    }
    
    @IBAction func flyerTapped(_ sender: UITapGestureRecognizer) {
    }
    
    @IBAction func addFlyerPressed(_ sender: UIButton) {
        cameraOrLibraryAlert()
    }
    
}

extension AddNewEventViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.backgroundColor == UIColor.red  {
            textField.text = nil
            textField.backgroundColor = UIColor.white
        }
    }
}

extension AddNewEventViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.backgroundColor == UIColor.red  {
            textView.text = nil
            textView.backgroundColor = UIColor.white
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

extension AddNewEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        eventFlyerImageView.image = selectedImage
        flyerExist = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func cameraOrLibraryAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if flyerExist {
            let removeAction = UIAlertAction(title: "Remove Flyer", style: .destructive) {_ in
                self.removeFlyer()
            }
            
            alertController.addAction(removeAction)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {_ in
            self.accessCamera()
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) {_ in
            self.accessLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func removeFlyer() {
        self.flyerExist = false
        eventFlyerImageView.image = nil
    }
    
    func accessLibrary() {
        imagepicker.sourceType = .photoLibrary
        present(imagepicker, animated: true, completion: nil)
    }
    
    func accessCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagepicker.sourceType = .camera
            present(imagepicker, animated: true, completion: nil)
        }
        else {
            print("no camera :/")
        }
    }
    
}
