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
    
    func signIn() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            FUIEmailAuth(),
            ]
        if authUI.auth?.currentUser == nil {
            self.authUI?.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        }
    }
    
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI!.signOut()
            print("SUCCESSFULLY SIGNED OUT")
            signIn()
        }
        catch {
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
            print("We signed in with user \(user.email ?? "Unknown email")")
        }
    }
    
}

