//
//  ManageAccountViewController.swift
//  BloatTracker
//
//  Created by osuappcenter on 11/20/17.
//  Copyright © 2017 AppCenter. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ManageAccountViewController: UIViewController ,UITextFieldDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
    }
    
    // Declaration of UI Objects
    @IBOutlet weak var emailTextField: UITextField!
    
    // Reset Password Action
    @IBAction func submitAction(_ sender: AnyObject) {
        if self.emailTextField.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        else
        {
            Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!, completion: { (error) in
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "Error!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.emailTextField.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    
    // Logout button takes to sign up page.
    @IBAction func logOutAction(sender: AnyObject) {
        if Auth.auth().currentUser != nil  {
            do{
                try? Auth.auth().signOut()
                if Auth.auth().currentUser == nil {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUp") as! SignUPViewController
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func back_Button(_ sender: Any) {
//        _ = navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    // when the keyboard appears the view goesup.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.frame.origin.y = -150
    }
    
    // when the keyboard is dismissed the view comes to normal position.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.frame.origin.y = 0
        emailTextField.resignFirstResponder()
        
        return true
    }
}

