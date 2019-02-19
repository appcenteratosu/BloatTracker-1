//
//  Home_Page_ViewController.swift
//  BloatTracker
//
//  Created by AppCenter on 10/2/17.
//  Copyright © 2017 AppCenter. All rights reserved.
//

import UIKit

class Home_Page_ViewController: UIViewController, UITabBarDelegate ,UITabBarControllerDelegate{
    
    // Declaration of UI Objects
    @IBOutlet weak var blurView: UIImageView!
    weak var delegate: UITabBarDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.blurView.isHidden = false
        self.navigationItem.leftBarButtonItem?.isEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        
    }
}
