//
//  LoginViewController.swift
//  BruRestaurant
//
//  Created by Simon Mc Neil on 2018-12-10.
//  Copyright © 2018 Simon Mc Neil. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI


class LoginViewController: UIViewController, FUIAuthDelegate {

    @IBOutlet weak var loginBtnStyleSettings: UIButton!
    
    var authUI: FUIAuth?
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtnStyleSettings.layer.cornerRadius = 20
        
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let providers: [FUIAuthProvider] = [FUIGoogleAuth()]
        authUI?.providers = providers
        
    }
    
    @IBAction func doBtnLogin(_ sender: Any) {
        if Auth.auth().currentUser == nil {
            if let authVC = authUI?.authViewController() {
                present(authVC, animated: true, completion: nil)
            }
        }
        else {
            do {
                try Auth.auth().signOut()
            } catch {
                print("Error Signing out")
            }
        }
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error == nil {
            self.performSegue(withIdentifier: "LoginToTableView", sender: nil)
        }
    }
}
