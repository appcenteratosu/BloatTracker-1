//
//  LoginViewController.swift
//  FirebaseTutorial
//
//  Created by James Dacombe on 16/11/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // Declaration of UI Objects
    @IBOutlet weak var emailTextField1: UITextField!
    @IBOutlet weak var passwordTextField1: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If the user log-in then it takes to the tabBar View Controller.
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
        emailTextField1.textColor = UIColor(red: 1.0,
                                            green: 1.0,
                                            blue: 1.0,
                                            alpha: 1)
        passwordTextField1.textColor = UIColor(red: 1.0,
                                               green: 1.0,
                                               blue: 1.0,
                                               alpha: 1)
    }
    
    //Login Action
    @IBAction func loginAction1(_ sender: AnyObject) {
        if self.emailTextField1.text == "" || self.passwordTextField1.text == "" {
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().signIn(withEmail: self.emailTextField1.text!, password: self.passwordTextField1.text!) { (user, error) in
                
                if error == nil {
                    //Go to the HomeViewController if the login is sucessful
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Tab_Bar") as! TabBar_ViewController
                    self.present(nextViewController, animated: true, completion: nil)
                }
                else
                {
                    //Tells the user that there is an error and then gets firebase to tell them the error
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
        emailTextField1.resignFirstResponder()
        passwordTextField1.resignFirstResponder()
        
        return true
    }
}
