//
//  EntryViewController.swift
//  WhatsUpBC
//
//  Created by Alex Karacaoglu on 4/6/19.
//  Copyright © 2019 Alex Karacaoglu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn

class EntryViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addNewEventButton: UIButton!
    @IBOutlet weak var viewRSVPsButton: UIButton!
    @IBOutlet weak var searchEventsButton: UIButton!
    
    var authUI: FUIAuth!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        signIn()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewRSVPS" {
            let destination = segue.destination as! ShowRSVPSViewController
            destination.rsvps.user = (Auth.auth().currentUser?.email)!
        }
    }
    
    func signIn() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            FUIEmailAuth(),
            ]
        if authUI.auth?.currentUser == nil {
            self.authUI?.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        }
        else {
            showElements()
        }
        
    }
    
    func hideElements() {
        addNewEventButton.isHidden = true
        searchEventsButton.isHidden = true
        viewRSVPsButton.isHidden = true
        titleLabel.isHidden = true
    }
    
    func showElements() {
        addNewEventButton.isHidden = false
        searchEventsButton.isHidden = false
        viewRSVPsButton.isHidden = false
        titleLabel.isHidden = false
    }
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI!.signOut()
            print("SUCCESSFULLY SIGNED OUT")
            hideElements()
            signIn()
        }
        catch {
            hideElements()
            print("ERROR: COULDNT SIGN OUT")
        }
    }
    
}

extension EntryViewController: FUIAuthDelegate {
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            showElements()
            print("We signed in with user \(user.email ?? "Unknown email")")
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        let loginImage = UIImage(named: "logo")
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        loginViewController.view.backgroundColor = UIColor.white
        let marginInsets: CGFloat = 16
        let imageHeight: CGFloat = (loginImage?.size.height)!
        let imageY = self.view.center.y - (imageHeight/1.5)
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width: self.view.frame.width - (marginInsets*2), height: imageHeight)
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = loginImage
        logoImageView.contentMode = .scaleAspectFit
        loginViewController.view.addSubview(logoImageView)
        return loginViewController
    }
    
}

