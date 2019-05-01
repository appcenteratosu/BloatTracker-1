//
//  SignUPViewController.swift
//  BloatTracker
//
//  Created by osuappcenter on 11/17/17.
//  Copyright © 2017 AppCenter. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUPViewController: UIViewController ,UITextFieldDelegate{
    var disclaimer: String = ""
    
    // Declaration of UI Objects
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If the user log-in then it takes to the tabBar View Controller.
        self.userLoggedIn { (User) in
            if User != nil {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Tab_Bar") as! TabBar_ViewController
                self.navigationController?.pushViewController(nextViewController, animated: true)
            }
        }
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
        
        emailTextField.textColor = UIColor(red: 1.0,
                                           green: 1.0,
                                           blue: 1.0,
                                           alpha: 1)
        passwordTextField.textColor = UIColor(red: 1.0,
                                              green: 1.0,
                                              blue: 1.0,
                                              alpha: 1)
    }
    
    //Sign Up Action for email
    @IBAction func createAccountAction(_ sender: AnyObject) {
        if emailTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        else
        {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    
                    self.performSegue(withIdentifier: "eula", sender: nil)
//                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "eula") as! UserAgreementViewController
//                    self.navigationController?.pushViewController(nextViewController, animated: true)
                }
                else
                {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // when the keyboard appears the view goesup.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.frame.origin.y = -150
    }
    
    // when the keyboard is dismissed the view comes to normal position.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.frame.origin.y = 0
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    // sign in of the user after one sign will be remembered.
    private func userLoggedIn (completion: (User?)->()) {
        if let User = Auth.auth().currentUser {
            completion(User)
        } else {
            completion(nil)
        }
    }
}
