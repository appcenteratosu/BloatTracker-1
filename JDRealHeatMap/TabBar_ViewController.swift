//
//  TabBar_ViewController.swift
//  JDRealHeatMap
//
//  Created by osuappcenter on 2/21/19.
//  Copyright © 2019 james12345. All rights reserved.
//

import UIKit

class TabBar_ViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem?.isEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        
    }
}

