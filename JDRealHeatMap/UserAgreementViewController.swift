//
//  UserAgreementViewController.swift
//  BloatTracker
//
//  Created by OSU App Center on 11/19/18.
//  Copyright © 2018 AppCenter. All rights reserved.
//

import UIKit

class UserAgreementViewController: UIViewController {
    
    var disclaimer: String = ""
    
    @IBOutlet weak var agreedButtonTapped: UIButton!
    @IBOutlet weak var disAgreedButtonTapped: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "EULA") == "disclaimer Shown" {
            // EULAAccept
            performSegue(withIdentifier: "EULAAccept", sender: nil)
        }
    }
    
    @IBAction func agreedButtonTapped(_ sender: UIButton) {
        disclaimer = "disclaimer Shown"
        UserDefaults.standard.set(disclaimer, forKey: "EULA")
        UserDefaults.standard.synchronize()
        performSegue(withIdentifier: "EULAAccept", sender: nil)
    }
    
    @IBAction func disAgreedButtonTapped(_ sender: UIButton) {
        disclaimer = "Disclaimer Not Accepted"
        UserDefaults.standard.set(disclaimer, forKey: "EULA")
        UserDefaults.standard.synchronize()
        exit(0)
    }
}
